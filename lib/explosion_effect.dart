


import 'dart:math';

import 'package:flutter/material.dart';

class ExplosionEffect extends StatefulWidget {
  const ExplosionEffect({super.key});

  @override
  _ExplosionEffectState createState() => _ExplosionEffectState();
}

class _ExplosionEffectState extends State<ExplosionEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _particles = List.generate(
      50, // Réduit le nombre de particules
      (index) => Particle(
        dx: Random().nextDouble() * 2 - 1,
        dy: Random().nextDouble() * 2 - 1,
        radius: Random().nextDouble() * 4 + 3,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ExplosionPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: const SizedBox(
            width: 200,
            height: 200,
          ),
        );
      },
    );
  }
}

class Particle {
  double dx;
  double dy;
  double radius;
  Color color;

  Particle({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.color,
  });
}

class ExplosionPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ExplosionPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var particle in particles) {
      final paint = Paint()..color = particle.color.withOpacity(1 - progress);
      final offset = Offset(
        center.dx + particle.dx * progress * 150,
        center.dy + particle.dy * progress * 150,
      );
      canvas.drawCircle(offset, particle.radius * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
