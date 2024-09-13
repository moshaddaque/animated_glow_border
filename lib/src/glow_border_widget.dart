import 'package:flutter/material.dart';

class AnimatedGlowBorder extends StatefulWidget {
  final Widget? child;
  final double borderWidth;
  final double borderRadius;
  final Duration animationDuration;
  final Color startColor;
  final Color endColor;

  const AnimatedGlowBorder({
    super.key,
    required this.child,
    this.borderWidth = 5.0,
    this.borderRadius = 0,
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
  late Animation<Alignment> _tlAlignAnim;
  late Animation<Alignment> _brAlignAnim;

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
    _controller.repeat();

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
                  radius: widget.borderRadius, thikness: widget.borderWidth),
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
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: _colorAnimation1.value!.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 1,
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
                                color: widget.endColor.withOpacity(0.3),
                                offset: const Offset(0, 0),
                                blurRadius: 20,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // borderRadius: widget.borderRadius,
                          border: Border.all(
                            width: widget.borderWidth,
                            color: Colors.transparent,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              _colorAnimation1.value!,
                              _colorAnimation2.value!,
                            ],
                            begin: _tlAlignAnim.value,
                            end: _brAlignAnim.value,
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
  final double thikness;

  _CenterCutPath({
    this.radius = 0,
    this.thikness = 1,
  });

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(
      -size.width,
      -size.width,
      size.width * 2,
      size.width * 2,
    );
    final double width = size.width - thikness * 2;
    final double height = size.height - thikness * 2;

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(thikness, thikness, width, height),
          Radius.circular(radius - thikness),
        ),
      )
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant _CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thikness != thikness;
  }
}
