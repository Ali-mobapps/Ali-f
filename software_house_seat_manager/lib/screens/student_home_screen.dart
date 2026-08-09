import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/booking_provider.dart';
import 'seat_map_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    final user = provider.currentUser;

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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${user?.id ?? 'user'}'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning, ${user?.fullName.split(' ')[0] ?? 'Alex'}.', 
                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Here is your lab reservation status for today.', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            const SizedBox(height: 24),
            
            _buildActiveReservationCard(),
            const SizedBox(height: 20),
            
            _buildNoShowWarning(),
            const SizedBox(height: 24),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard('24', 'COMPLETED SESSIONS', Icons.calendar_today_outlined),
                _buildStatCard('48h', 'HOURS LOGGED', Icons.access_time),
                _buildStatCard(
                  user?.outstandingFines.toStringAsFixed(2) ?? '0.00',
                  'OUTSTANDING FINES', 
                  Icons.money_off_csred_outlined,
                  isError: true,
                ),
                _buildStatCard('3', 'UPCOMING BOOKINGS', Icons.bookmark_outline, isSecondary: true),
              ],
            ),
            
            const SizedBox(height: 32),
            const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildActivityList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildActiveReservationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                child: const Text('ACTIVE RESERVATION', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.computer, color: Color(0xFF0F6DF3)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Lab B, Seat 14B', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('09:00 AM - 12:00 PM', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner, size: 20),
                  label: const Text('Check-in Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F6DF3),
                    side: const BorderSide(color: Color(0xFF0F6DF3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Release Seat'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoShowWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.report_problem_outlined, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No-Show Warning', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                SizedBox(height: 4),
                Text(
                  'Failure to check-in within 15 minutes of your reserved time will result in an automatic 50.00 CR penalty.',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text('VIEW PENALTY POLICY →', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, {bool isError = false, bool isSecondary = false}) {
    Color valColor = Colors.black;
    if (isError) valColor = Colors.red;
    if (isSecondary) valColor = const Color(0xFF0F6DF3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valColor)),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        _activityItem('Checkout: Lab A, Seat 04', 'Yesterday, 14:00', 'COMPLETED', Colors.green),
        _activityItem('Cancelled: Lab C, Seat 22', 'Oct 12, 09:30', 'VOID', Colors.grey),
        _activityItem('Checkout: Lab B, Seat 14B', 'Oct 10, 16:00', 'COMPLETED', Colors.green),
      ],
    );
  }

  Widget _activityItem(String title, String time, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0F6DF3),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SeatMapScreen()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Admin'),
      ],
    );
  }
}
