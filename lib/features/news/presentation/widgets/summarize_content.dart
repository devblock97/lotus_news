import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  final String text;
  final bool isStreaming;

  const AnimatedGradientBorder({
    super.key,
    required this.text,
    required this.isStreaming,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final gradient = LinearGradient(
          colors: [Colors.blue, Colors.purple, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(_controller.value * 2 * pi),
        );

        return Container(
          padding: const EdgeInsets.all(2), // border width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: gradient,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: theme.cardTheme.color,
            ),
            child: SelectableText(
              widget.text,
              style: theme.textTheme.labelSmall,
            ),
          ),
        );
      },
    );
  }
}

class MovableWidget extends StatefulWidget {
  final Widget child;
  const MovableWidget({super.key, required this.child});

  @override
  State<MovableWidget> createState() => _MovableWidgetState();
}

class _MovableWidgetState extends State<MovableWidget> {
  Offset position = const Offset(30, 30); // Initial position

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: widget.child,
      ),
    );
  }
}
