import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  final String text;
  final bool isStreaming;

  const AnimatedGradientBorder({super.key, required this.text, required this.isStreaming});

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // repeat indefinitely for animated border
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
              color: theme.cardTheme.color
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
