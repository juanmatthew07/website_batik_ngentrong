import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/batik_theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/batik_product_image.dart';
import '../../../core/widgets/chatbot_fab.dart';
import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/page_width.dart';
import '../../../core/widgets/site_footer.dart';
import '../domain/cart_item.dart';
import 'providers/cart_provider.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/presentation/widgets/google_auth_dialog.dart';

/// Halaman Keranjang Belanja (/keranjang).
/// Sangat Penting: Mengelompokkan item belanja berdasarkan Toko UMKM asalnya.
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(cartGroupedByStoreProvider);
    final totalCount = ref.watch(cartTotalCountProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);

    return Scaffold(
      appBar: const MainAppBar(showSearch: false),
      floatingActionButton: const ChatbotFab(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Baris Breadcrumb
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
                        'Lanjut Belanja',
                        style: TextStyle(color: BatikColors.sogaGelap, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text(
                      'Keranjang Belanja',
                      style: TextStyle(color: BatikColors.marun, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: BatikColors.garis),

            PageWidth(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: totalCount == 0
                  ? _buildEmptyCart(context)
                  : _buildCartContent(context, ref, groups, totalCount, totalPrice),
            ),

            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.shopping_bag_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Keranjang Belanja Anda Kosong',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: BatikColors.sogaGelap),
          ),
          const SizedBox(height: 8),
          Text(
            'Dukung pengrajin lokal Desa Ngentrong dengan memilih karya batik terbaik.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: BatikColors.marun,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.storefront, size: 18),
            label: const Text('Jelajahi Koleksi Batik'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    WidgetRef ref,
    List<StoreCartGroup> groups,
    int totalCount,
    int totalPrice,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 860;

        final itemsList = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Banner Pengelompokan UMKM
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BatikColors.krem,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BatikColors.garis),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: BatikColors.soga, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'PENTING: Barang dikelompokkan berdasarkan Toko UMKM pengrajin asal. Setiap toko akan menyiapkan pengiriman pesanan Anda secara mandiri dari workshop Desa Ngentrong.',
                      style: TextStyle(fontSize: 12.5, color: BatikColors.sogaGelap, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Daftar Kelompok Toko
            for (final group in groups) ...[
              _buildStoreGroupCard(context, ref, group),
              const SizedBox(height: 24),
            ],
          ],
        );

        final summaryCard = _buildOrderSummary(context, ref, groups.length, totalCount, totalPrice);

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: itemsList),
              const SizedBox(width: 32),
              Expanded(flex: 4, child: summaryCard),
            ],
          );
        }

        return Column(
          children: [
            itemsList,
            const SizedBox(height: 24),
            summaryCard,
          ],
        );
      },
    );
  }

  Widget _buildStoreGroupCard(BuildContext context, WidgetRef ref, StoreCartGroup group) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BatikColors.garis),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Toko
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: BatikColors.kertas,
            child: Row(
              children: [
                const Icon(Icons.storefront, color: BatikColors.marun, size: 20),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => context.go('/toko/${group.storeId}'),
                  child: Text(
                    group.storeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: BatikColors.marun,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 16, color: BatikColors.marun),
                const Spacer(),
                Text(
                  '${group.totalQuantity} barang',
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: BatikColors.garis),

          // Daftar Item dalam Toko ini
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: BatikColors.garis),
            itemBuilder: (context, index) {
              final item = group.items[index];
              return _buildCartItemTile(context, ref, item);
            },
          ),

          const Divider(height: 1, color: BatikColors.garis),

          // Subtotal Toko
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal Toko (${group.storeName}):',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  formatRupiah(group.subtotal),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: BatikColors.sogaGelap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemTile(BuildContext context, WidgetRef ref, CartItem item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Thumbnail Abu-abu Minimalis
          GestureDetector(
            onTap: () => context.go('/batik/${item.product.id}'),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: BatikColors.garis),
              ),
              clipBehavior: Clip.antiAlias,
              child: BatikProductImage(
                imageUrl: item.product.imageUrl,
                iconSize: 24,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.go('/batik/${item.product.id}'),
                  child: Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: BatikColors.sogaGelap,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Warna: ${item.selectedColor} • Ukuran: ${item.selectedSize}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                ),
                const SizedBox(height: 8),
                Text(
                  formatRupiah(item.product.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: BatikColors.marun,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Pengatur Kuantitas & Tombol Hapus
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                tooltip: 'Hapus dari keranjang',
                onPressed: () {
                  ref.read(cartNotifierProvider.notifier).removeItem(item.id);
                },
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: BatikColors.garis),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        ref
                            .read(cartNotifierProvider.notifier)
                            .updateQuantity(item.id, item.quantity - 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Icon(Icons.remove, size: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ref
                            .read(cartNotifierProvider.notifier)
                            .updateQuantity(item.id, item.quantity + 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Icon(Icons.add, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    WidgetRef ref,
    int storeCount,
    int totalCount,
    int totalPrice,
  ) {
    final authState = ref.watch(authNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BatikColors.garis),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: BatikColors.sogaGelap),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Kuantitas Batik:', style: TextStyle(color: Colors.black54)),
              Text('$totalCount pcs', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Jumlah Toko UMKM:', style: TextStyle(color: Colors.black54)),
              Text('$storeCount Toko', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: BatikColors.garis),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                formatRupiah(totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: BatikColors.marun,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info Status Login Google
          if (authState.isAuthenticated && authState.currentUser != null)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD2E3FC)),
              ),
              child: Row(
                children: [
                  const GoogleLogo(size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Masuk: ${authState.currentUser!.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF174EA6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.check_circle, size: 16, color: Color(0xFF1E8E3E)),
                ],
              ),
            ),

          // Tombol Payment Utama sesuai alur instruksi
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: BatikColors.marun,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _handlePaymentClick(context, ref),
              icon: const Icon(Icons.payment, size: 18),
              label: Text(
                authState.isAuthenticated ? 'Lanjut ke Pembayaran QRIS' : 'Pembayaran (Login Google)',
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              authState.isAuthenticated
                  ? 'Akun Google siap untuk verifikasi QRIS'
                  : 'Sebelum payment, Anda akan diminta login Google',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => context.go('/'),
            child: const Center(child: Text('Tambah Batik Lainnya')),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePaymentClick(BuildContext context, WidgetRef ref) async {
    final authState = ref.read(authNotifierProvider);

    // Alur: Jika belum login Google, tampilkan UI Google Auth terlebih dahulu
    if (!authState.isAuthenticated) {
      final success = await showGoogleAuthDialog(context);
      if (success == true && context.mounted) {
        // Setelah login Google auth sukses, lanjut ke UI Payment QRIS
        context.go('/checkout');
      }
    } else {
      // Jika sudah login Google, langsung buka UI Payment QRIS
      context.go('/checkout');
    }
  }
}

