
import 'package:flutter/material.dart';

class StaticProfileImage extends StatelessWidget {
  final double size;

  const StaticProfileImage({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient outer ring
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                startAngle: 0,
                endAngle: 6.2832,
                colors: [
                  Colors.cyanAccent,
                  Colors.purpleAccent,
                  Colors.blueAccent,
                  Colors.greenAccent,
                  Colors.cyanAccent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.35),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Inner background circle
          Container(
            width: size - 8,
            height: size - 8,
            decoration: const BoxDecoration(
              color: Color(0xFF020617),
              shape: BoxShape.circle,
            ),
          ),

          // Profile image
          ClipOval(
            child: Image.asset(
              'assets/images/profile.jpg',
              width: size - 14,
              height: size - 14,
              fit: BoxFit.cover,

              // Prevent crash if image fails
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size - 14,
                  height: size - 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white54,
                    size: 60,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

