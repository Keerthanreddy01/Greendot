import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedLogo extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  
  const AnimatedLogo({
    Key? key,
    this.size = 120,
    this.primaryColor = const Color(0xFF4CAF50),
    this.secondaryColor = const Color(0xFF81C784),
  }) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _glowController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _rotationAnimation,
        _glowAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size * 0.2),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(_glowAnimation.value),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.size * 0.2),
                gradient: RadialGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.95),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating background
                  Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: widget.size * 0.75,
                      height: widget.size * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.size * 0.375),
                        gradient: LinearGradient(
                          colors: [
                            widget.primaryColor,
                            widget.secondaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  
                  // Main eco icon
                  Icon(
                    Icons.eco,
                    size: widget.size * 0.5,
                    color: Colors.white,
                  ),
                  
                  // Decorative elements
                  Positioned(
                    top: widget.size * 0.15,
                    right: widget.size * 0.15,
                    child: Container(
                      width: widget.size * 0.1,
                      height: widget.size * 0.1,
                      decoration: BoxDecoration(
                        color: widget.secondaryColor,
                        borderRadius: BorderRadius.circular(widget.size * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: widget.secondaryColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: widget.size * 0.2,
                    left: widget.size * 0.2,
                    child: Container(
                      width: widget.size * 0.08,
                      height: widget.size * 0.08,
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(widget.size * 0.04),
                        boxShadow: [
                          BoxShadow(
                            color: widget.primaryColor.withOpacity(0.4),
                            blurRadius: 3,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}