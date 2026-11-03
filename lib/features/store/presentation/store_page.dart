import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/batik_theme.dart';
import '../../../core/utils/whatsapp.dart';
import '../../../core/widgets/chatbot_fab.dart';
import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/page_width.dart';
import '../../../core/widgets/site_footer.dart';
import '../../product/data/product_repository_provider.dart';
import '../../product/presentation/widgets/product_card.dart';
import '../data/store_repository.dart';

/// Halaman Katalog Toko UMKM (/toko/:id).
/// Menampilkan profil UMKM pengrajin dan grid produk khusus dari toko tersebut saja.
class StorePage extends ConsumerWidget {
  const StorePage({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(storeByIdProvider(storeId));
    final productsAsync = ref.watch(productsByStoreProvider(storeId));

    return Scaffold(
      appBar: const MainAppBar(showSearch: false),
      floatingActionButton: const ChatbotFab(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Baris Tombol Kembali & Breadcrumb
            Container(
              color: Colors.white,
              child: PageWidth(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back, size: 18, color: BatikColors.sogaGelap),
                      label: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(color: BatikColors.sogaGelap, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    storeAsync.maybeWhen(
                      data: (store) => Text(
                        store?.name ?? 'Toko UMKM',
                        style: const TextStyle(color: BatikColors.marun, fontWeight: FontWeight.bold),
                      ),
                      orElse: () => const Text('Toko UMKM'),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: BatikColors.garis),

            // Header Profil Toko UMKM
            storeAsync.when(
              data: (store) {
                if (store == null) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('Toko UMKM tidak ditemukan.')),
                  );
                }

                return Container(
                  color: Colors.white,
                  child: PageWidth(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 720;

                        final avatar = Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: store.brandColor,
                            boxShadow: [
                              BoxShadow(
                                color: store.brandColor.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            store.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        );

                        final details = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: BatikColors.sogaGelap,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 16, color: BatikColors.marun),
                                const SizedBox(width: 6),
                                Text(
                                  'Pengrajin: ${store.owner}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.star, size: 16, color: BatikColors.emas),
                                const SizedBox(width: 4),
                                Text(
                                  '${store.rating} / 5.0',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    store.address,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              store.description,
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 13.5, height: 1.5),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              ),
                              onPressed: () => openWhatsApp(
                                phone: store.phone,
                                message: 'Halo ${store.name}, saya ingin menanyakan koleksi batik Anda.',
                              ),
                              icon: const Icon(Icons.chat, size: 18),
                              label: Text('Chat Langsung dengan ${store.name}'),
                            ),
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              avatar,
                              const SizedBox(width: 28),
                              Expanded(child: details),
                            ],
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            avatar,
                            const SizedBox(height: 16),
                            details,
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator(color: BatikColors.marun)),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: Text('Gagal memuat profil toko.')),
              ),
            ),

            const Divider(height: 1, color: BatikColors.garis),

            // Daftar Koleksi Khusus Toko
            PageWidth(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  storeAsync.maybeWhen(
                    data: (store) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Koleksi Batik dari ${store?.name ?? "Toko Ini"}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Produk di bawah ini dibuat langsung oleh pengrajin toko ini di Desa Ngentrong',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  productsAsync.when(
                    data: (products) {
                      if (products.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(48),
                          alignment: Alignment.center,
                          child: const Text('Toko ini belum menambahkan produk.'),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = (width / 250).floor().clamp(2, 4).toInt();
                          const gap = 20.0;
                          final itemWidth = (width - (columns - 1) * gap) / columns;
                          final itemHeight = itemWidth * 1.05 + 175;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              mainAxisSpacing: gap,
                              crossAxisSpacing: gap,
                              mainAxisExtent: itemHeight,
                            ),
                            itemBuilder: (context, index) {
                              return ProductCard(product: products[index]);
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: BatikColors.marun),
                    ),
                    error: (_, __) => const Text('Gagal memuat produk toko.'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

