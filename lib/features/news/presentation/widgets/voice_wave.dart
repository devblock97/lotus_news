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
