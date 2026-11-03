import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/batik_theme.dart';
import '../../../store/data/store_repository.dart';
import '../../../store/domain/store.dart';

/// Daftar Toko UMKM Desa Ngentrong berbentuk bulatan (Circular Avatar)
/// yang dapat di-scroll secara horizontal.
class StoreAvatarList extends ConsumerWidget {
  const StoreAvatarList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(allStoresProvider);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Toko UMKM Desa Ngentrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih toko untuk menjelajahi karya khas masing-masing pengrajin',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 22),
            storesAsync.when(
              data: (stores) {
                final displayStores = stores.take(5).toList();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < displayStores.length; i++) ...[
                        if (i > 0) const SizedBox(width: 20),
                        _StoreAvatarItem(
                          store: displayStores[i],
                          displayName: 'Toko ${i + 1}',
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 135,
                child: Center(
                  child: CircularProgressIndicator(color: BatikColors.marun),
                ),
              ),
              error: (_, __) => const Text('Gagal memuat daftar toko.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreAvatarItem extends StatefulWidget {
  const _StoreAvatarItem({
    required this.store,
    required this.displayName,
  });

  final Store store;
  final String displayName;

  @override
  State<_StoreAvatarItem> createState() => _StoreAvatarItemState();
}

class _StoreAvatarItemState extends State<_StoreAvatarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go('/toko/${store.id}'),
        child: SizedBox(
          width: 104,
          child: Column(
            children: [
              // Bulatan Avatar Toko dengan Icon Placeholder (Ukuran lebih lega dan elegan)
              AnimatedScale(
                scale: _isHovered ? 1.06 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 86,
                  height: 86,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isHovered ? BatikColors.marun : BatikColors.garis,
                      width: _isHovered ? 2.5 : 2.0,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: store.brandColor.withValues(alpha: 0.12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.storefront_rounded,
                      color: _isHovered ? BatikColors.marun : store.brandColor,
                      size: 38,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Nama Toko (Toko 1, Toko 2, ...)
              Text(
                widget.displayName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _isHovered ? FontWeight.bold : FontWeight.w600,
                  color: _isHovered ? BatikColors.marun : BatikColors.sogaGelap,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

