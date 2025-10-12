import 'dart:math';

import 'package:flutter/material.dart';

class SummarizeAnimatedButton extends StatefulWidget {
  const SummarizeAnimatedButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<SummarizeAnimatedButton> createState() =>
      _SummarizeAnimatedButtonState();
}

class _SummarizeAnimatedButtonState extends State<SummarizeAnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: gradient,
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: TextButton(
              onPressed: widget.onPressed,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.blue, Colors.purple, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(_controller.value * 2 * pi),
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: Text('Summarize'),
              ),
            ),
          ),
        );
      },
    );
  }
}
