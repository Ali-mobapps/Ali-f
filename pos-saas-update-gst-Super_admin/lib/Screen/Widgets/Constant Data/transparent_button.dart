import 'dart:ui';

import 'package:flutter/material.dart';

import 'constant.dart';

// Custom dotted border
class CustomDottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;

  const CustomDottedBorder({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: kNutral300, // Set the background color here
              borderRadius: BorderRadius.circular(4)),
        ),
        CustomPaint(
          painter: DottedBorderPainter(color: color),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: child,
          ),
        ),
      ],
    );
  }
}

// For custom dotted widget
class DottedBorderPainter extends CustomPainter {
  final Color color;

  DottedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const double dashWidth = 4, dashSpace = 4;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ));

    final PathMetrics metrics = path.computeMetrics();
    for (PathMetric metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlobalTransparentButton extends StatelessWidget {
  const GlobalTransparentButton({super.key, required this.buttonText, required this.onpressed});

  final String buttonText;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kMainColor600)),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
        child: Row(
          children: [
            Container(
                alignment: Alignment.center,
                height: 20,
                width: 20,
                // padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: kMainColor600),
                ),
                child: const Icon(
                  Icons.add,
                  color: kMainColor,
                  size: 18,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kMainColor600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

///--------------------wihtout icon transparent button----------------------

class GlobalTransparentWithoutIconButton extends StatelessWidget {
  const GlobalTransparentWithoutIconButton({super.key, required this.buttonText, required this.onpressed});

  final String buttonText;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kErrorColor)),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kErrorColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
