import 'package:flutter/material.dart';

import '../theme/batik_theme.dart';

/// Placeholder gambar produk minimalis: kotak abu-abu bersih
/// dengan aksen warna solid bernuansa batik (tanpa CustomPaint/Canvas yang berat).
class ProductPlaceholder extends StatelessWidget {
  const ProductPlaceholder({
    super.key,
    this.badgeText,
    this.accentColor = BatikColors.soga,
    this.iconSize = 36,
  });

  final String? badgeText;
  final Color accentColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Latar abu-abu minimalis dengan ikon foto produk
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: iconSize,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 6),
                Text(
                  'Foto Produk',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          // Garis aksen halus di bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 3,
              color: accentColor.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}

