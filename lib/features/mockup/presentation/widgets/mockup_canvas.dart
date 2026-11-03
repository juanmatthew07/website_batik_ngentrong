import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/mockup_template.dart';
import 'clothing_shape_painter.dart';

/// Kanvas mockup: pakaian + pattern batik yang di-clip ke bentuk pakaian.
class MockupCanvas extends StatelessWidget {
  const MockupCanvas({
    super.key,
    required this.template,
    required this.patternBytes,
    this.canvasKey,
  });

  final MockupTemplate template;
  final Uint8List? patternBytes;
  final GlobalKey? canvasKey;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: template.aspectRatio,
      child: RepaintBoundary(
        key: canvasKey,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: ClothingShapePainter(
              templateId: template.id,
              color: Colors.grey.shade100,
            ),
            child: ClipPath(
              clipper: _ClothingClipper(template.id),
              child: patternBytes == null
                  ? const SizedBox.expand()
                  : FutureBuilder<ui.Image>(
                      future: _decodeImage(patternBytes!),
                      builder: (context, snap) {
                        if (!snap.hasData) return const SizedBox.expand();
                        return RawImage(
                          image: snap.data,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

class _ClothingClipper extends CustomClipper<Path> {
  const _ClothingClipper(this.templateId);
  final String templateId;

  @override
  Path getClip(Size size) {
    final painter = ClothingShapePainter(
      templateId: templateId,
      color: Colors.black,
    );
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    // Paint into canvas then extract path
    final dummyPaint = _PathExtractor(templateId);
    return dummyPaint.getPath(size);
  }

  @override
  bool shouldReclip(covariant _ClothingClipper oldClipper) =>
      oldClipper.templateId != templateId;
}

class _PathExtractor {
  const _PathExtractor(this.templateId);
  final String templateId;

  Path getPath(Size size) {
    // Reuse the same path logic
    final w = size.width;
    final h = size.height;
    final path = Path();
    switch (templateId) {
      case 'kemeja-panjang':
        path.moveTo(w * 0.30, h * 0.05);
        path.lineTo(w * 0.70, h * 0.05);
        path.lineTo(w * 0.85, h * 0.10);
        path.lineTo(w * 0.98, h * 0.55);
        path.lineTo(w * 0.85, h * 0.58);
        path.lineTo(w * 0.78, h * 0.30);
        path.lineTo(w * 0.78, h * 0.95);
        path.lineTo(w * 0.22, h * 0.95);
        path.lineTo(w * 0.22, h * 0.30);
        path.lineTo(w * 0.15, h * 0.58);
        path.lineTo(w * 0.02, h * 0.55);
        path.lineTo(w * 0.15, h * 0.10);
        path.close();
        break;
      case 'kemeja-pendek':
        path.moveTo(w * 0.30, h * 0.05);
        path.lineTo(w * 0.70, h * 0.05);
        path.lineTo(w * 0.88, h * 0.10);
        path.lineTo(w * 0.98, h * 0.35);
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
        path.quadraticBezierTo(w * 0.50, h * 0.12, w * 0.65, h * 0.05);
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
        path.lineTo(w * 0.70, h * 0.45);
        path.lineTo(w * 0.90, h * 0.95);
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
        final handle = Path()
          ..moveTo(w * 0.35, h * 0.30)
          ..lineTo(w * 0.35, h * 0.15)
          ..quadraticBezierTo(w * 0.50, h * 0.02, w * 0.65, h * 0.15)
          ..lineTo(w * 0.65, h * 0.30);
        return Path.combine(PathOperation.union, path, handle);
    }
    return path;
  }
}