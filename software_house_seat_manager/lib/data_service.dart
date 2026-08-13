import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'models.dart';
import 'notifier.dart';
import 'location_service.dart';

class DataService extends ChangeNotifier {
  static const String supabaseUrl = 'https://necbzbnfgzlyvtyrulro.supabase.co';
  static const String supabaseKey = 'sb_publishable_aL7ifStDQyHmXgoOOlsscg_qGFlDjLY';
  
  final _supabase = Supabase.instance.client;

  UserAccount? _currentUser;
  List<UserAccount> _allUsers = [];
  List<BookingEntry> _reservations = [];
  int _totalSeats = 20;
  
  TimeOfDay _reservationDeadline = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _attendanceStartTime = const TimeOfDay(hour: 11, minute: 0);
  
  TimeOfDay _remoteStartTime = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _remoteEndTime = const TimeOfDay(hour: 17, minute: 0);
  
  double? _officeLat;
  double? _officeLng;
  
  bool _isLoading = false;

  UserAccount? get currentUser => _currentUser;
  List<UserAccount> get users => _allUsers;
  List<BookingEntry> get reservations => _reservations;
  int get totalSeats => _totalSeats;
  TimeOfDay get reservationDeadline => _reservationDeadline;
  TimeOfDay get attendanceStartTime => _attendanceStartTime;
  TimeOfDay get remoteStartTime => _remoteStartTime;
  TimeOfDay get remoteEndTime => _remoteEndTime;
  bool get isLoading => _isLoading;
  bool get isLocationSet => _officeLat != null && _officeLng != null;

  DataService() {
    _init();
  }

  Future<void> _init() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await _loadUserData(session.user.id);
      _listenToChanges();
    }
    await _loadSettings();
  }

  void _listenToChanges() {
    _supabase.from('profiles').stream(primaryKey: ['id']).listen((data) {
      final newUsers = data.map((json) => _mapUser(json)).toList();
      
      if (_currentUser != null) {
        final updatedMe = newUsers.where((u) => u.id == _currentUser!.id).firstOrNull;
        if (updatedMe != null && updatedMe.fineAmount > _currentUser!.fineAmount) {
          AppNotifier.showFineAlert(updatedMe.fineAmount - _currentUser!.fineAmount);
        }
      }

      _allUsers = newUsers;
      if (_currentUser != null) {
        final updatedMe = _allUsers.where((u) => u.id == _currentUser!.id);
        if (updatedMe.isNotEmpty) _currentUser = updatedMe.first;
      }
      notifyListeners();
    });

    _supabase.from('reservations').stream(primaryKey: ['id']).listen((data) {
      _reservations = data.map((json) => _mapReservation(json)).toList();
      notifyListeners();
    });

    _supabase.from('settings').stream(primaryKey: ['key']).listen((data) {
      for (var row in data) {
        if (row['key'] == 'total_seats') _totalSeats = int.tryParse(row['value'].toString()) ?? 20;
        if (row['key'] == 'reservation_deadline') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _reservationDeadline = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'attendance_start_time') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _attendanceStartTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'remote_start_time') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _remoteStartTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'remote_end_time') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _remoteEndTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'office_lat') _officeLat = double.tryParse(row['value'].toString());
        if (row['key'] == 'office_lng') _officeLng = double.tryParse(row['value'].toString());
        if (row['key'] == 'fine_value') _fineValue = int.tryParse(row['value'].toString()) ?? 50;
      }
      notifyListeners();
    });
  }

  UserAccount _mapUser(Map<String, dynamic> json) {
    final roleStr = json['role']?.toString().toLowerCase() ?? 'student';
    return UserAccount(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: roleStr == 'admin' ? UserRole.admin : UserRole.student,
      isApproved: json['is_approved'] ?? false,
      fineAmount: json['fine_amount'] ?? 0,
    );
  }

  BookingEntry _mapReservation(Map<String, dynamic> json) {
    return BookingEntry(
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      category: json['reservation_type'] ?? 'office',
      isApproved: json['is_approved'] ?? false,
      showedUp: json['showed_up'] ?? false,
      isFinalized: json['is_finalized'] ?? false,
      assignedSeat: json['assigned_seat'],
      arrivalDeadline: json['arrival_deadline'],
    );
  }

  Future<void> _loadSettings() async {
    try {
      final res = await _supabase.from('settings').select();
      for (var row in res) {
        if (row['key'] == 'total_seats') _totalSeats = int.tryParse(row['value'].toString()) ?? 20;
        if (row['key'] == 'reservation_deadline') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _reservationDeadline = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'attendance_start_time') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _attendanceStartTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'remote_start_time') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _remoteStartTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'remote_end_time') {
          final parts = row['value'].toString().split(':');
          if (parts.length == 2) _remoteEndTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        if (row['key'] == 'office_lat') _officeLat = double.tryParse(row['value'].toString());
        if (row['key'] == 'office_lng') _officeLng = double.tryParse(row['value'].toString());
        if (row['key'] == 'fine_value') _fineValue = int.tryParse(row['value'].toString()) ?? 50;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      debugPrint('Loading user data for: $userId');
      final data = await _supabase.from('profiles').select().eq('id', userId).maybeSingle();
      
      if (data == null) {
        debugPrint('No profile found for ID: $userId. Creating one...');
        // Optional: Auto-create profile if missing during login (fallback)
        await _supabase.from('profiles').insert({
          'id': userId,
          'name': 'User',
          'email': _supabase.auth.currentUser?.email ?? '',
          'role': 'student',
          'is_approved': false,
          'fine_amount': 0,
        });
        final newData = await _supabase.from('profiles').select().eq('id', userId).single();
        _currentUser = _mapUser(newData);
      } else {
        _currentUser = _mapUser(data);
        debugPrint('User loaded: ${_currentUser!.name} as ${_currentUser!.role}');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('CRITICAL ERROR loading user data: $e');
    }
  }

  Future<void> reFetchUser(String userId) async {
    await _loadUserData(userId);
    _listenToChanges();
    await _loadSettings();
  }

  Future<String?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await _supabase.auth.signInWithPassword(email: email, password: password);
      if (res.user != null) {
        // Automatically promote the designated admin email if it logs in
        if (email.toLowerCase() == 'admin11@gmail.com') {
          await _supabase.from('profiles').update({
            'role': 'admin',
            'is_approved': true,
          }).eq('id', res.user!.id);
        }
        
        await _loadUserData(res.user!.id);
        _listenToChanges();
        notifyListeners();
        return null;
      }
      return 'Login failed';
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return 'Invalid email or password. Please try again.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> register(String name, String email, String password, UserRole role) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await _supabase.auth.signUp(email: email, password: password);
      if (res.user != null) {
        await _supabase.from('profiles').insert({
          'id': res.user!.id,
          'name': name,
          'email': email,
          'role': role == UserRole.admin ? 'admin' : 'student',
          'is_approved': role == UserRole.admin,
          'fine_amount': 0,
        });
        return null;
      }
      return 'Registration failed';
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('already registered') || e.message.toLowerCase().contains('already exists')) {
        return 'This email is already registered. Please login instead.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    _currentUser = null;
    _allUsers = [];
    _reservations = [];
    notifyListeners();
  }

  // Admin Actions
  Future<void> setTotalSeats(int count) async {
    await _supabase.from('settings').upsert({'key': 'total_seats', 'value': count.toString()});
  }

  Future<void> setReservationDeadline(TimeOfDay time) async {
    final value = '${time.hour}:${time.minute}';
    await _supabase.from('settings').upsert({'key': 'reservation_deadline', 'value': value});
  }

  Future<void> setAttendanceStartTime(TimeOfDay time) async {
    final value = '${time.hour}:${time.minute}';
    await _supabase.from('settings').upsert({'key': 'attendance_start_time', 'value': value});
  }

  Future<void> setRemoteTimes(TimeOfDay start, TimeOfDay end) async {
    await _supabase.from('settings').upsert({'key': 'remote_start_time', 'value': '${start.hour}:${start.minute}'});
    await _supabase.from('settings').upsert({'key': 'remote_end_time', 'value': '${end.hour}:${end.minute}'});
  }

  Future<String?> setOfficeLocation() async {
    Position? pos = await LocationService.getCurrentLocation();
    if (pos == null) return 'Could not get current location. check permissions.';
    
    await _supabase.from('settings').upsert({'key': 'office_lat', 'value': pos.latitude.toString()});
    await _supabase.from('settings').upsert({'key': 'office_lng', 'value': pos.longitude.toString()});
    return null;
  }

  Future<void> approveStudent(String userId) async {
    await _supabase.from('profiles').update({
      'is_approved': true,
    }).eq('id', userId);
  }

  Future<void> updateFineAmount(String userId, int newAmount) async {
    await _supabase.from('profiles').update({'fine_amount': newAmount}).eq('id', userId);
  }

  Future<void> cancelReservation(String userId, DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    await _supabase.from('reservations').update({
      'reservation_type': 'none',
      'is_finalized': true,
      'is_approved': false
    }).eq('user_id', userId).eq('date', dateStr);
  }

  Future<void> approveReservationWithDetails(String userId, DateTime date, String seat, TimeOfDay time) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    
    await _supabase.from('reservations').update({
      'is_approved': true,
      'assigned_seat': seat,
      'arrival_deadline': timeStr,
    }).eq('user_id', userId).eq('date', dateStr);
  }

  Future<void> approveReservation(String userId, DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    await _supabase.from('reservations').update({'is_approved': true}).eq('user_id', userId).eq('date', dateStr);
  }

  Future<void> promoteToAdmin(String userId) async {
    await _supabase.from('profiles').update({
      'role': 'admin',
      'is_approved': true,
    }).eq('id', userId);
  }

  Future<String?> createSecondaryAdmin(String name, String email, String password) async {
    try {
      final tempClient = SupabaseClient(supabaseUrl, supabaseKey);
      final res = await tempClient.auth.signUp(email: email, password: password);
      if (res.user != null) {
        await _supabase.from('profiles').insert({
          'id': res.user!.id,
          'name': name,
          'email': email,
          'role': 'admin',
          'is_approved': true,
          'fine_amount': 0,
        });
        return null;
      }
      return 'Creation failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> finalizeRemoteSection() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    final pendingRemote = _reservations.where((r) => 
      r.category == 'remote' && 
      DateFormat('yyyy-MM-dd').format(r.date) == today && 
      !r.showedUp && 
      !r.isFinalized
    ).toList();

    for (var res in pendingRemote) {
      await _supabase.from('reservations').update({
        'is_finalized': true,
        'showed_up': false
      }).eq('user_id', res.userId).eq('date', today);

      final user = _allUsers.firstWhere((u) => u.id == res.userId);
      await _supabase.from('profiles').update({
        'fine_amount': user.fineAmount + _fineValue
      }).eq('id', res.userId);
    }
  }

  int _fineValue = 50;
  int get fineValue => _fineValue;

  Future<void> setFineValue(int amount) async {
    await _supabase.from('settings').upsert({'key': 'fine_value', 'value': amount.toString()});
    _fineValue = amount;
    notifyListeners();
  }

  // Student Actions
  Future<String?> reserveSeat({bool isRemote = false}) async {
    try {
      if (_currentUser == null) return 'Login required';
      if (!_currentUser!.isApproved) return 'Account pending admin approval';

      final now = DateTime.now();
      
      // Use remote END time as deadline for remote registration to allow joining while active
      final deadlineTime = isRemote ? _remoteEndTime : _reservationDeadline;
      final deadline = DateTime(now.year, now.month, now.day, deadlineTime.hour, deadlineTime.minute);
      
      if (now.isAfter(deadline)) return 'Past reservation deadline (${DateFormat('hh:mm a').format(deadline)})';

      final dateStr = DateFormat('yyyy-MM-dd').format(now);
      
      // Check for existing reservation today
      final existing = await _supabase.from('reservations')
          .select()
          .eq('user_id', _currentUser!.id)
          .eq('date', dateStr);
      
      if (existing.isNotEmpty) return 'You already have a booking for today';

      if (!isRemote) {
        // Physical seat availability check
        final countRes = await _supabase.from('reservations')
            .select()
            .eq('date', dateStr)
            .eq('reservation_type', 'office');
        if (countRes.length >= _totalSeats) return 'No physical seats available';
      }

      await _supabase.from('reservations').insert({
        'user_id': _currentUser!.id,
        'date': dateStr,
        'showed_up': false,
        'is_approved': false,
        'reservation_type': isRemote ? 'remote' : 'office',
      });
      return null;
    } catch (e) {
      debugPrint('Error in reserveSeat: $e');
      return 'Database error: Check if all columns exist';
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<String?> markAttendance(String userId, DateTime date, bool showedUp) async {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    final currentRes = _reservations.firstWhere(
      (r) => r.userId == userId && DateFormat('yyyy-MM-dd').format(r.date) == dateStr,
      orElse: () => BookingEntry(
        userId: userId, 
        date: date, 
        category: 'office',
        isApproved: false,
        showedUp: false,
        isFinalized: false
      )
    );

    if (currentRes.category == 'office') {
      final startTime = DateTime(now.year, now.month, now.day, _attendanceStartTime.hour, _attendanceStartTime.minute);
      if (now.isBefore(startTime)) return 'Attendance starts at ${_formatTimeOfDay(_attendanceStartTime)}';
      
      if (showedUp) {
        if (_officeLat == null || _officeLng == null) return 'Office location not set by Admin.';
        bool inRange = await LocationService.isAtOffice(_officeLat!, _officeLng!);
        if (!inRange) return 'You must be at the office (within 50m) to mark someone present.';
      }
    } else {
      final startTime = DateTime(now.year, now.month, now.day, _remoteStartTime.hour, _remoteStartTime.minute);
      final endTime = DateTime(now.year, now.month, now.day, _remoteEndTime.hour, _remoteEndTime.minute);
      
      if (now.isBefore(startTime)) return 'Remote section starts at ${_formatTimeOfDay(_remoteStartTime)}';
      if (now.isAfter(endTime)) return 'Remote section has ended.';
    }

    await _supabase.from('reservations').update({'showed_up': showedUp}).eq('user_id', userId).eq('date', dateStr);
    
    if (!showedUp && !currentRes.showedUp) {
      final user = _allUsers.firstWhere((u) => u.id == userId);
      await _supabase.from('profiles').update({'fine_amount': user.fineAmount + _fineValue}).eq('id', userId);
    }
    return null;
  }
}
