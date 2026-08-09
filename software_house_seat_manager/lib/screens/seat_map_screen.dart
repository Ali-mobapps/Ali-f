import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/booking_provider.dart';
import '../models/seat_model.dart';

class SeatMapScreen extends StatefulWidget {
  const SeatMapScreen({super.key});

  @override
  State<SeatMapScreen> createState() => _SeatMapScreenState();
}

class _SeatMapScreenState extends State<SeatMapScreen> {
  String? _selectedSeatId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded, color: AppTheme.primaryColor),
          onPressed: () {},
        ),
        title: const Text('Kinetic Grid', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${provider.currentUser?.id ?? 'user'}'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildLegend(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: _buildSeatGrid(provider),
            ),
          ),
          _buildActionButton(provider),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Lab 402 - Main Grid', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              Text('Select an available seat to secure your reservation.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.red, size: 18),
                SizedBox(width: 6),
                Text('02:45:12', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF1F5FB), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legendItem('Available', Colors.white, Colors.grey.shade400),
          _legendItem('Occupied', const Color(0xFF1A237E), const Color(0xFF1A237E)),
          _legendItem('Selected', const Color(0xFF0F6DF3), const Color(0xFF0F6DF3)),
          _legendItem('Maintenance', const Color(0xFFE0E0E0), Colors.grey.shade400, isMaintenance: true),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, Color borderColor, {bool isMaintenance = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
          child: isMaintenance ? const Icon(Icons.close, size: 10, color: Colors.grey) : null,
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSeatGrid(BookingProvider provider) {
    final rows = ['A', 'B', 'C'];
    return Column(
      children: rows.map((row) => _buildRow(row, provider)).toList(),
    );
  }

  Widget _buildRow(String rowName, BookingProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20, child: Text(rowName, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          ...List.generate(8, (index) {
            final seatId = '$rowName${index + 1}';
            // Use mock statuses as per design for visuals
            SeatStatus status = provider.seats.any((s) => s.id == seatId && s.status == SeatStatus.occupied) 
                ? SeatStatus.occupied 
                : (provider.seats.any((s) => s.id == seatId && s.status == SeatStatus.maintenance) ? SeatStatus.maintenance : SeatStatus.available);
            
            if (seatId == _selectedSeatId) status = SeatStatus.selected;
            
            return Row(
              children: [
                _buildSeatItem(seatId, index + 1, status),
                if (index == 3) const SizedBox(width: 24), // Aisle
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSeatItem(String id, int number, SeatStatus status) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade400;
    Color textColor = Colors.black;
    Widget? icon;

    if (status == SeatStatus.occupied) {
      bgColor = const Color(0xFF1A237E);
      borderColor = bgColor;
      textColor = Colors.white;
    } else if (status == SeatStatus.selected) {
      bgColor = const Color(0xFF0F6DF3);
      borderColor = bgColor;
      textColor = Colors.white;
    } else if (status == SeatStatus.maintenance) {
      bgColor = const Color(0xFFF5F5F5);
      borderColor = Colors.grey.shade400;
      icon = const Icon(Icons.close, size: 16, color: Colors.grey);
    }

    return GestureDetector(
      onTap: status == SeatStatus.available ? () => setState(() => _selectedSeatId = id) : null,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: icon ?? Text('$number', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildActionButton(BookingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedSeatId == null ? null : () async {
            final success = await provider.reserveSeat(provider.currentUser?.id ?? 'user', _selectedSeatId!);
            if (success) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seat reserved successfully!')),
                );
                Navigator.pop(context);
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to reserve seat. Maybe past deadline?')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryContainer,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline),
              const SizedBox(width: 8),
              Text('Confirm Booking ${_selectedSeatId != null ? '($_selectedSeatId)' : ''}', 
                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0F6DF3),
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Admin'),
      ],
    );
  }
}
