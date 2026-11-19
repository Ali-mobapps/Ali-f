import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DeliveryMapScreen extends StatelessWidget {
  final String orderNumber;
  final String deliveryAddress;

  const DeliveryMapScreen({
    super.key,
    required this.orderNumber,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    // Default coordinates (Lahore centre as demo delivery point)
    final LatLng deliveryLatLng = const LatLng(31.5204, 74.3587);

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Map: Order #$orderNumber'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: deliveryLatLng,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.electronics_store_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: deliveryLatLng,
                    width: 80,
                    height: 80,
                    child: const Column(
                      children: [
                        Icon(Icons.location_pin, size: 40, color: Colors.red),
                        Text(
                          'Destination',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_shipping, color: Color(0xFF2563EB)),
                        SizedBox(width: 8),
                        Text('Destination Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(deliveryAddress, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
