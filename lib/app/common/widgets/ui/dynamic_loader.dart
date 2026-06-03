import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicLoading extends StatelessWidget {
  const DynamicLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: LoadingAnimationWidget.discreteCircle(
            color: AppColors.main,
            secondRingColor: AppColors.main2,
            thirdRingColor: AppColors.accent,
            size: 40,
          ),
        ),
      ],
    );
  }
}

class LoadingWiigold extends StatefulWidget {
  final double size;
  final int triangleCount;
  final String imagePath;
  final double triangleScale;
  final Duration cycleDuration;

  const LoadingWiigold({
    Key? key,
    this.size = 80.0,
    this.triangleCount = 6,
    this.imagePath = 'assets/triangle.png',
    this.triangleScale = 0.3,
    this.cycleDuration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  _LoadingWiigold createState() => _LoadingWiigold();
}

class _LoadingWiigold extends State<LoadingWiigold>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.cycleDuration,
    )..repeat(reverse: true);

    _fadeAnimations = List.generate(widget.triangleCount, (index) {
      final intervalStart = (1.0 / widget.triangleCount) * index;
      final intervalEnd = intervalStart + (1.0 / widget.triangleCount);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(widget.triangleCount, (index) {
            final angle = (2 * math.pi / widget.triangleCount) * index;

            final radius = widget.size / 2.9;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(radius * math.cos(angle), radius * math.sin(angle))
                ..rotateZ(angle + math.pi / 2),
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: Image.asset(
                  widget.imagePath,
                  width: widget.size * widget.triangleScale,
                  height: widget.size * widget.triangleScale,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DynamicLoader extends StatelessWidget {
  final String? loadingText;
  final Color backgroundColor;
  final double loaderSize;
  final bool showLoader;

  const DynamicLoader({
    super.key,
    this.loadingText,
    this.backgroundColor = AppColors.main,
    this.loaderSize = 100.0,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: FocusScope(
        node: FocusScopeNode(),
        child: Container(
          color: backgroundColor.withAlpha(250),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingWiigold(size: loaderSize),
                if (loadingText != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    loadingText!,
                    style: const TextStyle(
                      color: AppColors.light,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
