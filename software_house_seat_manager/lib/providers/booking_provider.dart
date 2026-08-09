import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/seat_model.dart';
import '../models/reservation_model.dart';

class BookingProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  UserModel? _currentUser;
  List<UserModel> _users = [];
  List<SeatModel> _seats = [];
  List<ReservationModel> _reservations = [];
  
  TimeOfDay _reservationDeadline = const TimeOfDay(hour: 10, minute: 0);
  int _totalCapacity = 150;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get students => _users.where((u) => u.role == UserRole.student).toList();
  List<UserModel> get pendingApprovals => _users.where((u) => !u.isApproved && u.role == UserRole.student).toList();
  List<SeatModel> get seats => _seats;
  List<SeatModel> get availableSeats => _seats.where((s) => s.status == SeatStatus.available).toList();
  List<SeatModel> get occupiedSeats => _seats.where((s) => s.status == SeatStatus.occupied).toList();
  TimeOfDay get reservationDeadline => _reservationDeadline;
  int get totalCapacity => _totalCapacity;

  BookingProvider() {
    _init();
  }

  Future<void> _init() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await _fetchCurrentUser(session.user.id);
      await refreshData();
    } else {
      // For demo/setup purposes, ensure seats exist in DB if empty
      // In a real app, this would be a migrations step
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      _fetchUsers(),
      _fetchSeats(),
      _fetchReservations(),
    ]);
    notifyListeners();
  }

  Future<void> _fetchCurrentUser(String userId) async {
    final data = await _supabase.from('profiles').select().eq('id', userId).single();
    _currentUser = UserModel.fromJson(data);
    notifyListeners();
  }

  Future<void> _fetchUsers() async {
    final data = await _supabase.from('profiles').select();
    _users = (data as List).map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> _fetchSeats() async {
    final data = await _supabase.from('seats').select();
    _seats = (data as List).map((json) => SeatModel.fromJson(json)).toList();
    if (_seats.isEmpty) {
      await _initializeSeats();
    }
  }

  Future<void> _initializeSeats() async {
    final rows = ['A', 'B', 'C'];
    List<Map<String, dynamic>> initialSeats = [];
    for (var row in rows) {
      for (var i = 1; i <= 8; i++) {
        initialSeats.add({
          'id': '$row$i',
          'row': row,
          'number': i,
          'status': 'available',
        });
      }
    }
    await _supabase.from('seats').insert(initialSeats);
    await _fetchSeats();
  }

  Future<void> _fetchReservations() async {
    final data = await _supabase.from('reservations').select();
    _reservations = (data as List).map((json) => ReservationModel.fromJson(json)).toList();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await _fetchCurrentUser(response.user!.id);
        await refreshData();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> registerUser(UserModel user, String password) async {
    final response = await _supabase.auth.signUp(
      email: user.email,
      password: password,
      data: {
        'full_name': user.fullName,
        'university_id': user.universityId,
        'department': user.department,
        'role': user.role == UserRole.admin ? 'admin' : 'student',
        'is_approved': user.role == UserRole.admin, // Admins auto-approved in this demo
      },
    );

    if (response.user != null) {
      // Supabase trigger usually handles profile creation, but if not:
      await _supabase.from('profiles').insert({
        'id': response.user!.id,
        'full_name': user.fullName,
        'email': user.email,
        'university_id': user.universityId,
        'department': user.department,
        'role': user.role == UserRole.admin ? 'admin' : 'student',
        'is_approved': user.role == UserRole.admin,
      });
    }
  }

  Future<void> approveStudent(String userId) async {
    await _supabase.from('profiles').update({'is_approved': true}).eq('id', userId);
    await refreshData();
  }

  Future<void> rejectStudent(String userId) async {
    // In a real app, maybe delete or mark as rejected
    await _supabase.from('profiles').delete().eq('id', userId);
    await refreshData();
  }

  Future<bool> reserveSeat(String studentId, String seatId) async {
    final now = DateTime.now();
    final deadline = DateTime(now.year, now.month, now.day, _reservationDeadline.hour, _reservationDeadline.minute);
    
    if (now.isAfter(deadline)) return false;

    try {
      await _supabase.from('reservations').insert({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'student_id': studentId,
        'seat_id': seatId,
        'reservation_time': DateTime(now.year, now.month, now.day, 9, 0).toIso8601String(),
      });

      await _supabase.from('seats').update({'status': 'occupied'}).eq('id', seatId);
      await refreshData();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setReservationDeadline(TimeOfDay time) {
    _reservationDeadline = time;
    notifyListeners();
  }

  void setTotalCapacity(int capacity) {
    _totalCapacity = capacity;
    notifyListeners();
  }

  Future<void> processNoShows() async {
    // This would typically be a cron job on the server, but implementing locally for demo
    for (var res in _reservations) {
      if (res.isNoShow) {
        // Apply fine to user profile
        final user = _users.firstWhere((u) => u.id == res.studentId);
        await _supabase.from('profiles').update({
          'outstanding_fines': user.outstandingFines + 50.0
        }).eq('id', user.id);
      }
    }
    await refreshData();
  }
}
