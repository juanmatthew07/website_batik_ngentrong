import 'package:flutter/material.dart';

import '../../domain/mockup_template.dart';

/// Custom painter yang menggambar siluet pakaian sesuai template.
class ClothingShapePainter extends CustomPainter {
  const ClothingShapePainter({required this.templateId, required this.color});

  final String templateId;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = _buildPath(templateId, size);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  Path _buildPath(String id, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    switch (id) {
      case 'kemeja-panjang':
        // Kemeja lengan panjang
        path.moveTo(w * 0.30, h * 0.05);
        path.lineTo(w * 0.70, h * 0.05); // bahu
        path.lineTo(w * 0.85, h * 0.10); // bahu kanan
        path.lineTo(w * 0.98, h * 0.55); // lengan kanan bawah
        path.lineTo(w * 0.85, h * 0.58);
        path.lineTo(w * 0.78, h * 0.30); // ketiak kanan
        path.lineTo(w * 0.78, h * 0.95); // badan kanan
        path.lineTo(w * 0.22, h * 0.95); // badan bawah
        path.lineTo(w * 0.22, h * 0.30); // ketiak kiri
        path.lineTo(w * 0.15, h * 0.58);
        path.lineTo(w * 0.02, h * 0.55);
        path.lineTo(w * 0.15, h * 0.10); // bahu kiri
        path.close();
        break;

      case 'kemeja-pendek':
        path.moveTo(w * 0.30, h * 0.05);
        path.lineTo(w * 0.70, h * 0.05);
        path.lineTo(w * 0.88, h * 0.10);
        path.lineTo(w * 0.98, h * 0.35); // lengan pendek
        path.lineTo(w * 0.82, h * 0.38);
        path.lineTo(w * 0.78, h * 0.25);
        path.lineTo(w * 0.78, h * 0.95);
        path.lineTo(w * 0.22, h * 0.95);
        path.lineTo(w * 0.22, h * 0.25);
        path.lineTo(w * 0.18, h * 0.38);
        path.lineTo(w * 0.02, h * 0.35);
        path.lineTo(w * 0.12, h * 0.10);
        path.close();
        break;

      case 'kaos':
        path.moveTo(w * 0.35, h * 0.05);
        path.quadraticBezierTo(w * 0.50, h * 0.12, w * 0.65, h * 0.05); // leher
        path.lineTo(w * 0.85, h * 0.12);
        path.lineTo(w * 0.98, h * 0.32);
        path.lineTo(w * 0.82, h * 0.35);
        path.lineTo(w * 0.78, h * 0.22);
        path.lineTo(w * 0.78, h * 0.95);
        path.lineTo(w * 0.22, h * 0.95);
        path.lineTo(w * 0.22, h * 0.22);
        path.lineTo(w * 0.18, h * 0.35);
        path.lineTo(w * 0.02, h * 0.32);
        path.lineTo(w * 0.15, h * 0.12);
        path.close();
        break;

      case 'dress':
        path.moveTo(w * 0.35, h * 0.05);
        path.lineTo(w * 0.65, h * 0.05);
        path.lineTo(w * 0.72, h * 0.15);
        path.lineTo(w * 0.70, h * 0.45); // pinggang
        path.lineTo(w * 0.90, h * 0.95); // rok melebar
        path.lineTo(w * 0.10, h * 0.95);
        path.lineTo(w * 0.30, h * 0.45);
        path.lineTo(w * 0.28, h * 0.15);
        path.close();
        break;

      case 'tote-bag':
      default:
        path.moveTo(w * 0.20, h * 0.30);
        path.lineTo(w * 0.80, h * 0.30);
        path.lineTo(w * 0.85, h * 0.95);
        path.lineTo(w * 0.15, h * 0.95);
        path.close();
        // Handle
        final handle = Path()
          ..moveTo(w * 0.35, h * 0.30)
          ..lineTo(w * 0.35, h * 0.15)
          ..quadraticBezierTo(w * 0.50, h * 0.02, w * 0.65, h * 0.15)
          ..lineTo(w * 0.65, h * 0.30);
        return Path.combine(PathOperation.union, path, handle);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant ClothingShapePainter oldDelegate) {
    return oldDelegate.templateId != templateId || oldDelegate.color != color;
  }
}