import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundPattern extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  
  const BackgroundPattern({
    Key? key,
    this.primaryColor = const Color(0xFF4CAF50),
    this.secondaryColor = const Color(0xFF81C784),
  }) : super(key: key);

  @override
  State<BackgroundPattern> createState() => _BackgroundPatternState();
}

class _BackgroundPatternState extends State<BackgroundPattern>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: PatternPainter(
            widget.primaryColor,
            widget.secondaryColor,
            _animation.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double animationValue;

  PatternPainter(this.primaryColor, this.secondaryColor, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Create subtle geometric pattern
    final patternSize = 80.0;
    final offsetX = (animationValue * patternSize) % patternSize;
    final offsetY = (animationValue * patternSize * 0.7) % patternSize;

    for (double x = -patternSize + offsetX; x < size.width + patternSize; x += patternSize) {
      for (double y = -patternSize + offsetY; y < size.height + patternSize; y += patternSize) {
        // Draw subtle hexagonal patterns
        paint.color = primaryColor.withOpacity(0.03);
        _drawHexagon(canvas, Offset(x, y), patternSize * 0.3, paint);
        
        paint.color = secondaryColor.withOpacity(0.02);
        _drawHexagon(canvas, Offset(x + patternSize * 0.5, y + patternSize * 0.5), patternSize * 0.2, paint);
      }
    }

    // Add some floating geometric shapes
    final shapeCount = 8;
    for (int i = 0; i < shapeCount; i++) {
      final angle = (animationValue * 2 * math.pi) + (i * 2 * math.pi / shapeCount);
      final radius = size.width * 0.4;
      final centerX = size.width * 0.5 + math.cos(angle) * radius * 0.3;
      final centerY = size.height * 0.5 + math.sin(angle) * radius * 0.2;
      
      paint.color = primaryColor.withOpacity(0.05);
      canvas.drawCircle(
        Offset(centerX, centerY),
        20 + math.sin(animationValue * 4 * math.pi + i) * 5,
        paint,
      );
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}