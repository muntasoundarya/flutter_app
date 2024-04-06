import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimated;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimation({
    super.key,
    required this.child,
    required this.isAnimated,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  });
  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: widget.duration.inMilliseconds ~/
              2), //this divides the millisec by 2 and converts to int
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget

    if (widget.isAnimated != oldWidget.isAnimated) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimated || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
