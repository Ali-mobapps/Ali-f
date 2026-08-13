import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'data_service.dart';
import 'models.dart';
import 'notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home_work_rounded, size: 48, color: AppColors.secondary),
              ),
              const SizedBox(height: 32),
              Text(
                'Tech House',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Professional Workspace Management',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildTextField(_emailController, 'Corporate Email', icon: Icons.alternate_email_rounded),
              const SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password', obscure: true, icon: Icons.lock_outline_rounded),
              const SizedBox(height: 32),
              
              // Two separate login buttons
              Row(
                children: [
                  Expanded(
                    child: _buildPortalButton(
                      label: 'Admin',
                      icon: Icons.admin_panel_settings_rounded,
                      onPressed: () => _handleLogin(context, dataService, isAdmin: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPortalButton(
                      label: 'Member',
                      icon: Icons.person_rounded,
                      onPressed: () => _handleLogin(context, dataService, isAdmin: false),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New here?", style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.hankenGrotesk(color: AppColors.secondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortalButton({required String label, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, DataService dataService, {required bool isAdmin}) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (isAdmin) {
      if (email.toLowerCase() != 'admin11@gmail.com' || password != '12121212') {
        AppNotifier.showError('Unauthorized: These credentials are not registered as Administrator.');
        return;
      }
    }

    final error = await dataService.login(email, password);
    if (error != null) {
      AppNotifier.showError(error);
    } else {
      if (!mounted) return;
      
      final navigator = Navigator.of(context);
      final user = dataService.currentUser;
      if (user != null) {
        if (user.role == UserRole.admin) {
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
            (route) => false,
          );
        } else {
          if (isAdmin) {
             // This is a safety check: even if login succeeded, if the role isn't admin
             // we shouldn't allow entry to the admin portal
             AppNotifier.showError('Access Denied: This account does not have Admin privileges.');
             dataService.logout();
             return;
          }
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const StudentDashboard()),
            (route) => false,
          );
        }
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false, IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: AppColors.onSurfaceVariant, size: 20) : null,
          labelText: label,
          labelStyle: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.student;

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tech House', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: AppColors.primary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Join the Workspace',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your professional profile to start booking.',
              style: GoogleFonts.hankenGrotesk(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 40),
            _buildTextField(_nameController, 'Full Name', icon: Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Corporate Email', icon: Icons.alternate_email_rounded),
            const SizedBox(height: 16),
            _buildTextField(_passwordController, 'Create Password', obscure: true, icon: Icons.lock_outline_rounded),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(border: InputBorder.none, labelText: 'Select Role'),
                  items: const [
                    DropdownMenuItem(value: UserRole.student, child: Text('Team Member')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: dataService.isLoading
                  ? null
                  : () async {
                      final error = await dataService.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _selectedRole,
                      );
                      if (error == null) {
                        if (!mounted) return;
                        final navigator = Navigator.of(context);
                        AppNotifier.showSuccess('Success! Please sign in.');
                        navigator.pop();
                      } else {
                        AppNotifier.showError(error);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: dataService.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary))
                  : const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false, IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: AppColors.onSurfaceVariant, size: 20) : null,
          labelText: label,
          labelStyle: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    final pendingUsers = dataService.users.where((u) => !u.isApproved).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tech House', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () {
            dataService.logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
            onPressed: () {
              dataService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin We Tech', style: GoogleFonts.hankenGrotesk(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: -0.5)),
                    Text('Real-time Occupancy & Records', style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.monitor_heart_rounded, color: AppColors.secondary),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildStatGrid(context, dataService),
            const SizedBox(height: 40),
            _buildBookingLog(context, dataService),
            const SizedBox(height: 40),
            _buildApprovalQueue(context, dataService, pendingUsers),
            const SizedBox(height: 40),
            _buildOperationsCard(context, dataService),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingLog(BuildContext context, DataService dataService) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayBookings = dataService.reservations
        .where((r) => DateFormat('yyyy-MM-dd').format(r.date) == today)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Booking Records', style: GoogleFonts.hankenGrotesk(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 16),
        if (todayBookings.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
            ),
            child: Center(
              child: Text('No seats booked yet today.', style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant)),
            ),
          )
        else
          ...todayBookings.map((booking) {
            final user = dataService.users.firstWhere((u) => u.id == booking.userId, orElse: () => UserAccount(id: '', name: 'Unknown User', email: '', role: UserRole.student, isApproved: false, fineAmount: 0));
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: booking.category == 'remote' ? Colors.purple.withOpacity(0.1) : AppColors.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      booking.category == 'remote' ? Icons.vibration_rounded : Icons.desk_rounded,
                      color: booking.category == 'remote' ? Colors.purple : AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('${booking.category.toUpperCase()} • DESK ${booking.userId.substring(0, 2).toUpperCase()}', style: GoogleFonts.hankenGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.onSurfaceVariant, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(booking.date),
                    style: GoogleFonts.hankenGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                  ),
                  if (!booking.isApproved)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                          tooltip: 'Set Seat & Approve',
                          onPressed: () => _showBookingApprovalDialog(context, dataService, user, booking),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_rounded, color: AppColors.error, size: 28),
                          tooltip: 'Cancel Request',
                          onPressed: () {
                            dataService.cancelReservation(user.id, booking.date);
                            AppNotifier.showError('Booking cancelled for ${user.name}');
                          },
                        ),
                      ],
                    )
                  else if (!booking.showedUp)
                    IconButton(
                      icon: const Icon(Icons.money_off_csred_rounded, color: AppColors.error, size: 28),
                      tooltip: 'Send Fine (No-Show)',
                      onPressed: () {
                        dataService.updateFineAmount(user.id, user.fineAmount + dataService.fineValue);
                        AppNotifier.showError('Fine of Rs. ${dataService.fineValue} issued to ${user.name}');
                      },
                    )
                  else
                    const Icon(Icons.verified_rounded, color: AppColors.success, size: 24),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildStatGrid(BuildContext context, DataService dataService) {
    int occupied = dataService.reservations.where((r) => r.category == 'office' && DateFormat('yyyy-MM-dd').format(r.date) == DateFormat('yyyy-MM-dd').format(DateTime.now())).length;
    int available = dataService.totalSeats - occupied;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Capacity', dataService.totalSeats.toString(), Icons.analytics_rounded, AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ApprovedMembersScreen()));
                },
                child: _buildStatCard('Booked Today', occupied.toString(), Icons.event_seat_rounded, AppColors.secondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Available Now', available.toString(), Icons.check_circle_rounded, AppColors.success)),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const AllMembersScreen()));
                },
                child: _buildStatCard('Total Members', dataService.users.length.toString(), Icons.people_alt_rounded, AppColors.warning),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showBookingApprovalDialog(BuildContext context, DataService dataService, UserAccount user, BookingEntry booking) {
    final seatController = TextEditingController();
    TimeOfDay selectedTime = dataService.attendanceStartTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Approve Workspace', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: AppColors.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assigning for: ${user.name}', style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              TextField(
                controller: seatController,
                decoration: InputDecoration(
                  labelText: 'Seat / Desk Number',
                  hintText: 'e.g. Desk 43',
                  prefixIcon: const Icon(Icons.desk_rounded, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Required Arrival Time', style: GoogleFonts.hankenGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: selectedTime);
                  if (time != null) setState(() => selectedTime = time);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Icon(Icons.access_time_filled_rounded, color: AppColors.secondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                dataService.cancelReservation(user.id, booking.date);
                Navigator.pop(context);
                AppNotifier.showError('Seat Request Cancelled');
              },
              child: const Text('Cancel Request', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (seatController.text.isEmpty) {
                  AppNotifier.showError('Please assign a desk number');
                  return;
                }
                dataService.approveReservationWithDetails(
                  user.id,
                  booking.date,
                  seatController.text,
                  selectedTime,
                );
                Navigator.pop(context);
                AppNotifier.showSuccess('Confirmed: ${user.name} at ${seatController.text}');
              },
              child: const Text('Confirm & Approve'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.hankenGrotesk(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)),
          Text(title, style: GoogleFonts.hankenGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildApprovalQueue(BuildContext context, DataService dataService, List<UserAccount> pendingUsers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Approval Queue', style: GoogleFonts.hankenGrotesk(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(width: 12),
            if (pendingUsers.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${pendingUsers.length} PENDING', style: GoogleFonts.hankenGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.error)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (pendingUsers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 40),
                const SizedBox(height: 12),
                Text('All caught up!', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('No pending profile approvals.', style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppColors.onSurfaceVariant)),
              ],
            ),
          )
        else
          ...pendingUsers.map((user) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(user.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w800, color: AppColors.primary)),
                          Text(user.email, style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
                      onPressed: () {
                        dataService.approveStudent(user.id);
                        AppNotifier.showSuccess('Profile approved for ${user.name}!');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_rounded, color: AppColors.error),
                      onPressed: () {
                        AppNotifier.showError('Profile rejected for ${user.name}');
                      },
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildOperationsCard(BuildContext context, DataService dataService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Management', style: GoogleFonts.hankenGrotesk(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              // Seat Capacity Control
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), shape: BoxShape.circle),
                  child: const Icon(Icons.chair_alt_rounded, color: AppColors.primary, size: 20),
                ),
                title: Text('Seat Capacity', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: Text('Current limit: ${dataService.totalSeats} seats', style: const TextStyle(fontSize: 12)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      onPressed: () => dataService.setTotalSeats(dataService.totalSeats - 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      onPressed: () => dataService.setTotalSeats(dataService.totalSeats + 1),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              // Time Limit Control
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.timer_rounded, color: AppColors.warning, size: 20),
                ),
                title: Text('Booking Deadline', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: Text('Current: ${dataService.reservationDeadline.format(context)}', style: const TextStyle(fontSize: 12)),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: dataService.reservationDeadline,
                    );
                    if (time != null) {
                      dataService.setReservationDeadline(time);
                      AppNotifier.showSuccess('Deadline updated!');
                    }
                  },
                  child: const Text('Change', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              const Divider(height: 32),
              // Fine Control
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.money_off_rounded, color: AppColors.error, size: 20),
                ),
                title: Text('Penalty Amount', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: Text('Current fine: Rs. ${dataService.fineValue}', style: const TextStyle(fontSize: 12)),
                trailing: TextButton(
                  onPressed: () async {
                    final controller = TextEditingController(text: dataService.fineValue.toString());
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Fine Amount'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              final val = int.tryParse(controller.text);
                              if (val != null) {
                                dataService.setFineValue(val);
                                Navigator.pop(context);
                                AppNotifier.showSuccess('Fine updated!');
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Change', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              const Divider(height: 32),
              // GPS Control
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.my_location_rounded, color: AppColors.secondary, size: 20),
                ),
                title: Text('Office Geo-Fence', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: Text(dataService.isLocationSet ? 'Coordinate Locked' : 'Not Configured', style: const TextStyle(fontSize: 12)),
                trailing: TextButton(
                  onPressed: () async {
                    AppNotifier.showSuccess('Syncing GPS...');
                    final err = await dataService.setOfficeLocation();
                    if (err != null) {
                      AppNotifier.showError(err);
                    } else {
                      AppNotifier.showSuccess('Location established!');
                    }
                  },
                  child: Text(dataService.isLocationSet ? 'Reset' : 'Set Now', style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    final user = dataService.currentUser;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final myBooking = dataService.reservations.firstWhere(
      (r) => r.userId == user?.id && DateFormat('yyyy-MM-dd').format(r.date) == today,
      orElse: () => BookingEntry(userId: '', date: DateTime.now(), category: 'none', isApproved: false, showedUp: false, isFinalized: false),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tech House', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () {
            dataService.logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () {
              dataService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Welcome,', style: GoogleFonts.hankenGrotesk(fontSize: 16, color: AppColors.onSurfaceVariant)),
          Text(user?.name ?? 'Team Member', style: GoogleFonts.hankenGrotesk(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 32),
          _buildStatusCard(context, dataService, myBooking),
          const SizedBox(height: 32),
          _buildFineCard(user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Bookings'),
        ],
        onTap: (index) {
          if (index == 1) {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const SeatMapScreen()));
          }
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, DataService dataService, BookingEntry booking) {
    bool hasBooking = booking.category != 'none';

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  hasBooking ? 'RESERVED' : 'AVAILABLE',
                  style: GoogleFonts.hankenGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.secondary, letterSpacing: 1),
                ),
              ),
              const Icon(Icons.wifi_tethering_rounded, color: AppColors.secondary, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            hasBooking ? 'Your Workspace' : 'Ready to work?',
            style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
          ),
          Text(
            hasBooking ? 'Seat: ${booking.category.toUpperCase()}' : 'No active booking',
            style: GoogleFonts.hankenGrotesk(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          if (hasBooking) ...[
            if (booking.isApproved)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your seat is CONFIRMED!\nPlease arrive by ${booking.arrivalDeadline ?? '11:00 AM'}.\nSeat: ${booking.assignedSeat ?? 'Assigned by Admin'}',
                        style: GoogleFonts.hankenGrotesk(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            else if (booking.category == 'none' && booking.isFinalized)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your booking was CANCELLED by Admin.\nPlease contact management for details.',
                        style: GoogleFonts.hankenGrotesk(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
          ],
          const SizedBox(height: 32),
          if (!hasBooking)
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SeatMapScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.w900)),
            )
          else ...[
            if (!booking.isApproved)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_empty_rounded, color: Colors.white70),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Waiting for Admin to confirm your seat...', style: GoogleFonts.hankenGrotesk(color: Colors.white))),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: booking.showedUp ? null : () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final err = await dataService.markAttendance(booking.userId, booking.date, true);
                  if (err != null) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(err), backgroundColor: AppColors.error));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(booking.showedUp ? 'Checked In' : 'Check-in Now', style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
          ]
        ],
      ),
    );
  }

  Widget _buildFineCard(UserAccount? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Outstanding Fines', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                Text('Rs. ${user?.fineAmount ?? 0}', style: GoogleFonts.hankenGrotesk(fontSize: 24, color: AppColors.error, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(DataService dataService) {
    return const SizedBox(); // Add actual stats here
  }
}

class SeatMapScreen extends StatelessWidget {
  const SeatMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Workspace Map', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Environment', style: GoogleFonts.hankenGrotesk(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)),
            Text('Choose where you want to work today.', style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 40),
            _buildEnvironmentCard(
              context,
              'On-Site Desk',
              'Physical seat in the office with full amenities.',
              Icons.desk_rounded,
              () async {
                final navigator = Navigator.of(context);
                final err = await dataService.reserveSeat(isRemote: false);
                if (err != null) AppNotifier.showError(err);
                else {
                  AppNotifier.showSuccess('Desk secured successfully!');
                  navigator.pop();
                }
              },
            ),
            const SizedBox(height: 16),
            _buildEnvironmentCard(
              context,
              'Remote Node',
              'Work from your own location with system access.',
              Icons.vibration_rounded,
              () async {
                final navigator = Navigator.of(context);
                final err = await dataService.reserveSeat(isRemote: true);
                if (err != null) AppNotifier.showError(err);
                else {
                  AppNotifier.showSuccess('Remote session established!');
                  navigator.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard(BuildContext context, String title, String desc, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.hankenGrotesk(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(desc, style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }
}

class AllMembersScreen extends StatelessWidget {
  const AllMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    final users = dataService.users;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Team Directory', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: users.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline_rounded, size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  Text('No members registered yet.', style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16)),
                            Text(user.email, style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.isApproved ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.isApproved ? 'APPROVED' : 'PENDING',
                          style: GoogleFonts.hankenGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: user.isApproved ? AppColors.success : AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class ApprovedMembersScreen extends StatelessWidget {
  const ApprovedMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final approvedBookings = dataService.reservations
        .where((r) => DateFormat('yyyy-MM-dd').format(r.date) == today && r.isApproved)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Approved Bookings', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: approvedBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_seat_rounded, size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  Text('No approved seats for today.', style: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: approvedBookings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = approvedBookings[index];
                final user = dataService.users.firstWhere((u) => u.id == booking.userId, orElse: () => UserAccount(id: '', name: 'Unknown', email: '', role: UserRole.student, isApproved: false, fineAmount: 0));
                
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.secondary.withOpacity(0.1),
                        child: Icon(Icons.person_rounded, color: AppColors.secondary, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16)),
                            Text('Seat: ${booking.assignedSeat ?? "N/A"} • Time: ${booking.arrivalDeadline ?? "N/A"}', style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified_rounded, color: AppColors.success, size: 24),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
