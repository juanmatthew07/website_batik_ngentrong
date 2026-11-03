import 'package:flutter/material.dart';

import '../../../../core/theme/batik_theme.dart';
import '../../../../core/widgets/page_width.dart';

/// Hero Banner beranda yang bersih dan elegan (tanpa CustomPaint AI-motif yang membuat lag).
class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, required this.onExploreTap});

  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BatikColors.nila,
            BatikColors.sogaGelap,
          ],
        ),
      ),
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Keindahan Batik Tradisional Langsung dari Pengrajin',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Eksplorasi motif cengkeh khas Trenggalek dan aneka batik tulis serta cap pilihan dari gabungan UMKM pengrajin Desa Ngentrong.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: BatikColors.marun,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                ),
                onPressed: onExploreTap,
                icon: const Icon(Icons.arrow_downward, size: 18),
                label: const Text('Jelajahi Semua Batik'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

