import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../providers/booking_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.grid_view_rounded, color: AppTheme.primaryColor),
        title: const Text('Kinetic Grid', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.primaryColor),
            onPressed: () => provider.logout(),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(DateFormat('EEE, MMM d').format(DateTime.now()), style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard('TOTAL STUDENTS', '142', '+12 this week', Icons.group, const Color(0xFF1A237E))),
              ],
            ),
            const SizedBox(height: 12),
            _buildOccupiedCard(86, 150),
            const SizedBox(height: 12),
            _buildStatCard('AVAILABLE SEATS', '64', 'Optimal Status', Icons.check_circle, const Color(0xFF2E7D32)),
            
            const SizedBox(height: 24),
            _buildDailyOperations(context, provider),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Student Approval Queue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: Color(0xFF0F6DF3))),
                ),
              ],
            ),
            _buildApprovalQueue(provider),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: color.withAlpha(150), fontWeight: FontWeight.w500)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withAlpha(20), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupiedCard(int occupied, int total) {
    double progress = occupied / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('OCCUPIED SEATS', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Text('$occupied', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade100,
                  color: const Color(0xFF0F6DF3),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Text('${(progress * 100).toInt()}% Capacity', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF0F6DF3).withAlpha(20), shape: BoxShape.circle),
            child: const Icon(Icons.event_seat, color: Color(0xFF0F6DF3), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyOperations(BuildContext context, BookingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFCFE6F2).withAlpha(100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text('Daily Operations', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ],
          ),
          const SizedBox(height: 20),
          _operationItem('Seat Capacity', '${provider.totalCapacity}', 'Limit max daily occupants'),
          const Divider(height: 24),
          _operationItem('Reservation Cutoff', provider.reservationDeadline.format(context), 'Auto-release unused seats', onTap: () async {
            final time = await showTimePicker(context: context, initialTime: provider.reservationDeadline);
            if (time != null) provider.setReservationDeadline(time);
          }),
          const Divider(height: 24),
          _operationItem('Daily Report', 'Process', 'Apply no-show fines', onTap: () async {
            await provider.processNoShows();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily fines processed successfully.')));
            }
          }),
        ],
      ),
    );
  }

  Widget _operationItem(String title, String value, String subtitle, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalQueue(BookingProvider provider) {
    if (provider.pendingApprovals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No pending approvals', style: TextStyle(color: Colors.grey))),
      );
    }
    return Column(
      children: provider.pendingApprovals.map((user) => _approvalItem(user, provider)).toList(),
    );
  }

  Widget _approvalItem(dynamic user, BookingProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFCFE6F2),
                child: Text(user.fullName.substring(0, 1), style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('ID: ${user.universityId} • ${user.department}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFCFE6F2), borderRadius: BorderRadius.circular(8)),
                child: const Text('2h ago', style: TextStyle(fontSize: 10, color: AppTheme.primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.approveStudent(user.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Approve', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await provider.rejectStudent(user.id);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: BorderSide(color: Colors.grey.shade200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reject', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0F6DF3),
      unselectedItemColor: Colors.grey,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.event_seat_outlined), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Admin'),
      ],
    );
  }
}
