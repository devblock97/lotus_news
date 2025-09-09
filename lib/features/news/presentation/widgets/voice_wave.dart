import 'dart:math';
import 'package:flutter/material.dart';

class VoiceWavePainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  VoiceWavePainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final spacing = size.width / (amplitudes.length + 1);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * spacing;
      final amp = amplitudes[i] * size.height;
      canvas.drawLine(
        Offset(x, centerY - amp / 2),
        Offset(x, centerY + amp / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}

class VoiceWave extends StatefulWidget {
  VoiceWave({super.key, required this.controller});

  AnimationController controller;

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave> with TickerProviderStateMixin {

  late AnimationController _controller;

  List<double> _amplitudes = List.generate(20, (_) => Random().nextDouble() * 0.6);

  @override
  void initState() {
    super.initState();
    widget.controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500))
      ..addListener(() {
        updateWave();
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomPaint(
        painter: VoiceWavePainter(
            amplitudes: _amplitudes,
            color: Colors.blueAccent.shade700
        ),
      ),
    );
  }

  void updateWave() {
    setState(() {
      _amplitudes = List.generate(20, (_) => Random().nextDouble() * 0.8);
    });
  }
}
