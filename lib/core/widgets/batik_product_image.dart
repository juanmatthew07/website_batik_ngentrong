import 'package:flutter/material.dart';

import '../theme/batik_theme.dart';
import 'product_placeholder.dart';

/// Widget untuk menampilkan gambar produk dari asset/network,
/// atau fallback ke [ProductPlaceholder] bila gambar belum ada atau gagal dimuat.
///
/// Mendukung pengecekan fallback otomatis antara:
/// 1. Path yang diberikan (misal 'assets/batik_images/batik1.jpg')
/// 2. Alternatif path jika file disimpan di 'assets/images/batik1.jpg'
class BatikProductImage extends StatelessWidget {
  const BatikProductImage({
    super.key,
    required this.imageUrl,
    this.badgeText,
    this.accentColor = BatikColors.soga,
    this.iconSize = 36,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? imageUrl;
  final String? badgeText;
  final Color accentColor;
  final double iconSize;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final imagePath = imageUrl?.trim();

    Widget fallback() {
      return ProductPlaceholder(
        badgeText: badgeText,
        accentColor: accentColor,
        iconSize: iconSize,
      );
    }

    if (imagePath == null || imagePath.isEmpty) {
      return fallback();
    }

    // Jika berupa URL http/https (untuk fleksibilitas masa depan jika pakai CDN/cloud)
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          imagePath,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => fallback(),
        ),
      );
    }

    // Asset image: coba load imagePath, bila gagal coba fallback path alternatif atau placeholder
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        imagePath,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // Jika path awal memakai assets/batik_images/, coba cek assets/images/ atau sebaliknya
          String? altPath;
          if (imagePath.contains('assets/batik_images/')) {
            altPath = imagePath.replaceFirst('assets/batik_images/', 'assets/images/');
          } else if (imagePath.contains('assets/images/')) {
            altPath = imagePath.replaceFirst('assets/images/', 'assets/batik_images/');
          }

          if (altPath != null) {
            return Image.asset(
              altPath,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => fallback(),
            );
          }

          return fallback();
        },
      ),
    );
  }
}

