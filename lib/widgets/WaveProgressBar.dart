import 'dart:math';
import 'package:flutter/material.dart';

/// A custom StatefulWidget that creates an animated wave progress bar.
///
/// The [WaveProgressBar] takes a progress value and an optional gradient to
/// display an animated wave indicating the current progress.
class WaveProgressBar extends StatefulWidget {
  /// The current progress value. Expected to be between 0.0 and 1.0.
  final double progress;

  /// An optional gradient to color the wave. Defaults to null, which uses a solid blue color.
  final Gradient? gradient;

  /// Creates an instance of [WaveProgressBar].
  ///
  /// Requires a [progress] value and optionally takes a [gradient].
  const WaveProgressBar({Key? key, required this.progress, this.gradient})
      : super(key: key);

  @override
  _WaveProgressBarState createState() => _WaveProgressBarState();
}

/// The state class for [WaveProgressBar] which manages the animation controller.
class _WaveProgressBarState extends State<WaveProgressBar>
    with SingleTickerProviderStateMixin {
  /// The animation controller for the wave animation.
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() => setState(() {}))
          ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      painter: WavePainter(
          progress: widget.progress,
          animationValue: _controller!.value,
          gradient: widget.gradient),
      child: Container(),
    );
  }
}

/// A custom painter class to draw the wave based on the progress and animation values.
class WavePainter extends CustomPainter {
  /// The current progress value.
  final double progress;

  /// The current value of the animation, used to animate the wave.
  final double animationValue;

  /// An optional gradient used to color the wave.
  final Gradient? gradient;

  /// Creates an instance of [WavePainter] with the given [progress], [animationValue], and [gradient].
  WavePainter(
      {required this.progress, required this.animationValue, this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    if (gradient != null) {
      Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = Colors.blue;
    }

    final path = Path();
    for (double i = 0.0; i < size.width; i++) {
      double waveHeight =
          sin((i / size.width * 2 * pi) + (2 * pi * animationValue)) * 20;
      double y = (1 - progress) * size.height + waveHeight;
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
