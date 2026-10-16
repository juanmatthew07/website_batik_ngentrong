import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_provider.dart';
import '../theme/batik_theme.dart';
import 'page_width.dart';

/// Header navigasi utama marketplace Batik Desa Ngentrong.
/// Bersih, tanpa logo Uniqlo, tanpa menu kategori Pria/Wanita, dan responsif di layar mobile maupun web desktop.
class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.onSearchChanged,
    this.searchController,
    this.showSearch = true,
  });

  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final bool showSearch;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartTotalCountProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: BatikColors.garis, width: 1)),
      ),
      child: PageWidth(
        child: SizedBox(
          height: 70,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;

              return Row(
                children: [
                  // Judul Elegan Teks Biasa (Menggantikan Logo Kotak Merah Uniqlo)
                  InkWell(
                    onTap: () => context.go('/'),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isWide ? 'Batik Desa Ngentrong' : 'Batik Ngentrong',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: BatikColors.sogaGelap,
                                  letterSpacing: 0.2,
                                  fontSize: isWide ? 20 : 17,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isWide) const SizedBox(width: 24) else const SizedBox(width: 8),

                  // Kolom Pencarian (jika aktif)
                  if (showSearch)
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: SizedBox(
                          height: 38,
                          child: TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            decoration: InputDecoration(
                              hintText: isWide ? 'Cari batik, motif cengkeh, atau UMKM...' : 'Cari batik...',
                              hintStyle: const TextStyle(fontSize: 12.5, color: Colors.black45),
                              prefixIcon: const Icon(Icons.search, size: 18, color: BatikColors.soga),
                              filled: true,
                              fillColor: BatikColors.kertas,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: BatikColors.garis),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: BatikColors.garis),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: BatikColors.marun, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  const SizedBox(width: 8),

                  // Ikon Keranjang dengan Badge Kuantitas
                  IconButton(
                    onPressed: () => context.go('/keranjang'),
                    tooltip: 'Keranjang Belanja',
                    icon: Badge(
                      isLabelVisible: cartCount > 0,
                      label: Text(
                        '$cartCount',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: BatikColors.marun,
                      child: const Icon(Icons.shopping_bag_outlined, color: BatikColors.sogaGelap, size: 24),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

