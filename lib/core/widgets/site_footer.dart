import 'package:flutter/material.dart';

import '../config.dart';
import '../theme/batik_theme.dart';
import 'page_width.dart';

/// Footer minimalis dan responsif untuk marketplace Batik Desa Ngentrong.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BatikColors.sogaGelap,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: PageWidth(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 640;

            final infoSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kShopName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: BatikColors.krem,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  kShopTagline,
                  style: TextStyle(
                    color: BatikColors.krem.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  kShopAddress,
                  style: TextStyle(
                    color: BatikColors.krem.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            );

            final helpSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pusat Bantuan UMKM',
                  style: TextStyle(
                    color: BatikColors.emas,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Dikelola bersama komunitas pengrajin batik untuk pelestarian budaya dan pemberdayaan ekonomi lokal.',
                  style: TextStyle(
                    color: BatikColors.krem.withValues(alpha: 0.7),
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: infoSection),
                      const SizedBox(width: 32),
                      Expanded(flex: 2, child: helpSection),
                    ],
                  )
                else ...[
                  infoSection,
                  const SizedBox(height: 24),
                  helpSection,
                ],
                const SizedBox(height: 32),
                const Divider(color: Colors.white12),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '© 2026 Komunitas UMKM Batik Desa Ngentrong, Karangan, Trenggalek. Hak Cipta Dilindungi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BatikColors.krem.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

