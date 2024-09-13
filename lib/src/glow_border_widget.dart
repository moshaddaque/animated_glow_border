import 'package:flutter/material.dart';

class AnimatedGlowBorder extends StatefulWidget {
  final Widget? child;
  final double borderWidth;
  final double borderRadius;
  final double blurRadius;
  final double glowOpacity;
  final double spreadRadius;
  final Duration animationDuration;
  final Color startColor;
  final Color endColor;

  const AnimatedGlowBorder({
    super.key,
    required this.child,
    this.borderWidth = 5.0,
    this.borderRadius = 10,
    this.blurRadius = 10,
    this.glowOpacity = 0.3,
    this.spreadRadius = 1,
    this.animationDuration = const Duration(milliseconds: 500),
    this.startColor = Colors.blue,
    this.endColor = Colors.purple,
  });

  @override
  _AnimatedGlowBorderState createState() => _AnimatedGlowBorderState();
}

class _AnimatedGlowBorderState extends State<AnimatedGlowBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _tlAlignAnim;
  late Animation<Alignment> _brAlignAnim;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _tlAlignAnim = TweenSequence<Alignment>(
      [
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _brAlignAnim = TweenSequence<Alignment>(
      [
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            widget.child != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: widget.child,
                  )
                : const SizedBox.shrink(),
            ClipPath(
              clipper: _CenterCutPath(
                  radius: widget.borderRadius, thickness: widget.borderWidth),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          boxShadow: [
                            BoxShadow(
                              color: widget.startColor,
                              blurRadius: widget.blurRadius,
                              spreadRadius: widget.spreadRadius,
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: _brAlignAnim.value,
                        child: Container(
                          width: constraints.maxWidth * 0.95,
                          height: constraints.maxHeight * 0.95,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: widget.endColor,
                                offset: const Offset(0, 0),
                                blurRadius: widget.blurRadius,
                                spreadRadius: widget.spreadRadius,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          gradient: LinearGradient(
                            colors: [
                              widget.startColor,
                              widget.endColor,
                            ],
                            begin: _tlAlignAnim.value,
                            end: _brAlignAnim.value,
                          ),
                        ),
                        child: widget.child,
                      ),
                    ],
                  );
                },
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;

  _CenterCutPath({
    this.radius = 0,
    this.thickness = 1,
  });

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(
      -size.width,
      -size.width,
      size.width * 2,
      size.width * 2,
    );
    final double width = size.width - thickness * 2;
    final double height = size.height - thickness * 2;

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(thickness, thickness, width, height),
          Radius.circular(radius - thickness),
        ),
      )
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant _CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}
