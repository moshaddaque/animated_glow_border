import 'package:flutter/material.dart';

class AnimatedGlowBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Duration animationDuration;
  final Color startColor;
  final Color endColor;

  const AnimatedGlowBorder({
    super.key,
    required this.child,
    this.borderWidth = 5.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.animationDuration = const Duration(seconds: 3),
    this.startColor = Colors.blue,
    this.endColor = Colors.purple,
  });

  @override
  _AnimatedGlowBorderState createState() => _AnimatedGlowBorderState();
}

class _AnimatedGlowBorderState extends State<AnimatedGlowBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);

    // Define color tween animations
    _colorAnimation1 = ColorTween(
      begin: widget.startColor,
      end: widget.endColor,
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: widget.endColor,
      end: widget.startColor,
    ).animate(_controller);
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
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            border: Border.all(
              width: widget.borderWidth,
              color: Colors.transparent,
            ),
            gradient: LinearGradient(
              colors: [
                _colorAnimation1.value!,
                _colorAnimation2.value!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _colorAnimation1.value!.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: _colorAnimation2.value!.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
