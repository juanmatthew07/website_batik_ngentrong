import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/batik_theme.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/widgets/product_placeholder.dart';
import '../../domain/product.dart';

/// Kartu Produk Batik UMKM.
/// Bersih, tanpa harga diskon/coret merah, dan memakai placeholder gambar abu-abu minimalis.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final theme = Theme.of(context);
    final currentColor = p.colors[_selectedColorIndex];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go('/batik/${p.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered ? BatikColors.marun : BatikColors.garis,
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: BatikColors.sogaGelap.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Placeholder Kotak Abu-abu Minimalis
              AspectRatio(
                aspectRatio: 1.05,
                child: ProductPlaceholder(
                  badgeText: p.technique,
                  accentColor: currentColor.color,
                  iconSize: 42,
                ),
              ),

              // Detail Informasi Produk
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Toko Asal (Bisa diklik menuju halaman toko)
                      InkWell(
                        onTap: () => context.go('/toko/${p.storeId}'),
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 14,
                              color: BatikColors.marun,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                p.storeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: BatikColors.marun,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Nama Produk
                      Text(
                        p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: BatikColors.sogaGelap,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Motif Khas
                      Text(
                        p.motif,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const Spacer(),

                      // Bulatan Pilihan Warna Solid (Accessible hit target & diameter lega)
                      Row(
                        children: [
                          for (var i = 0; i < p.colors.length; i++)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() => _selectedColorIndex = i),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedColorIndex == i
                                          ? BatikColors.sogaGelap
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: p.colors[i].color,
                                      border: Border.all(color: Colors.black12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Harga Asli Saja (Tanpa Diskon / Harga Coret Merah)
                      Text(
                        formatRupiah(p.price),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: BatikColors.sogaGelap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

