import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/batik_theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/chatbot_fab.dart';
import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/page_width.dart';
import '../../../core/widgets/product_placeholder.dart';
import '../../../core/widgets/site_footer.dart';
import '../../cart/domain/cart_item.dart';
import '../../cart/presentation/providers/cart_provider.dart';

/// Halaman Mockup Checkout (/checkout).
/// Menyajikan rincian pesanan per toko dan tombol "Lanjut Pembayaran / Login Google".
class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(cartGroupedByStoreProvider);
    final totalCount = ref.watch(cartTotalCountProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);

    // Estimasi ongkos kirim standar per toko UMKM Ngentrong
    final shippingPerStore = 15000;
    final totalShipping = groups.length * shippingPerStore;
    final grandTotal = totalPrice + totalShipping;

    return Scaffold(
      appBar: const MainAppBar(showSearch: false),
      floatingActionButton: const ChatbotFab(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Breadcrumb Navigasi
            Container(
              color: Colors.white,
              child: PageWidth(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => context.go('/keranjang'),
                      icon: const Icon(Icons.arrow_back, size: 18, color: BatikColors.sogaGelap),
                      label: const Text(
                        'Kembali ke Keranjang',
                        style: TextStyle(color: BatikColors.sogaGelap, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text(
                      'Checkout Pesanan',
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
                  ? _buildEmpty(context)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 860;

                        final details = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Mockup Alamat Pengiriman
                            _buildAddressCard(),

                            const SizedBox(height: 24),

                            // 2. Rincian Barang per Toko UMKM
                            const Text(
                              'Rincian Pesanan per UMKM',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BatikColors.sogaGelap),
                            ),
                            const SizedBox(height: 12),

                            for (final group in groups) ...[
                              _buildStoreReviewCard(group, shippingPerStore),
                              const SizedBox(height: 16),
                            ],
                          ],
                        );

                        final paymentSummary = _buildPaymentSummaryCard(
                          context,
                          ref,
                          totalPrice,
                          totalShipping,
                          grandTotal,
                          groups.length,
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 7, child: details),
                              const SizedBox(width: 32),
                              Expanded(flex: 5, child: paymentSummary),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            details,
                            const SizedBox(height: 24),
                            paymentSummary,
                          ],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Text('Tidak ada item yang dapat di-checkout.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Mulai Belanja Batik'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BatikColors.garis),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: BatikColors.marun, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Alamat Pengiriman (Mockup)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: BatikColors.krem,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Utama',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: BatikColors.soga),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Budi Santoso • 0812-3456-7890',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Jl. Pemuda No. 45, RT 03 RW 01, Kelurahan Ngantru, Kec. Trenggalek, Kab. Trenggalek, Jawa Timur 66311',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreReviewCard(StoreCartGroup group, int shippingFee) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: BatikColors.kertas,
            child: Row(
              children: [
                const Icon(Icons.storefront, color: BatikColors.marun, size: 18),
                const SizedBox(width: 8),
                Text(
                  group.storeName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BatikColors.marun),
                ),
                const Spacer(),
                const Text(
                  'Kirim dari Desa Ngentrong',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: BatikColors.garis),

          // Item produk
          for (final item in group.items)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: BatikColors.garis),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: const ProductPlaceholder(iconSize: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.selectedColor} • ${item.selectedSize} (x${item.quantity})',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatRupiah(item.subtotal),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ],
              ),
            ),

          const Divider(height: 1, color: BatikColors.garis),

          // Pilihan Ekspedisi Toko
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 18, color: BatikColors.soga),
                    const SizedBox(width: 8),
                    const Text(
                      'Ekspedisi Reguler (J&T / Pos Indonesia):',
                      style: TextStyle(fontSize: 12.5),
                    ),
                  ],
                ),
                Text(
                  formatRupiah(shippingFee),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(
    BuildContext context,
    WidgetRef ref,
    int totalPrice,
    int totalShipping,
    int grandTotal,
    int storeCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BatikColors.garis),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Tagihan',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: BatikColors.sogaGelap),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal Produk Batik:', style: TextStyle(color: Colors.black54)),
              Text(formatRupiah(totalPrice), style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Ongkir ($storeCount Toko UMKM):', style: const TextStyle(color: Colors.black54)),
              Text(formatRupiah(totalShipping), style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Biaya Layanan UMKM Desa:', style: TextStyle(color: Colors.black54)),
              Text('GRATIS (Didukung Pemkab)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                formatRupiah(grandTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: BatikColors.marun,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Wajib Sesuai Instruksi: "Lanjut Pembayaran / Login Google"
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: BatikColors.marun,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _showPrototypeAuthDialog(context, ref),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon Google Sederhana
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Lanjut Pembayaran / Login Google',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'UI Prototipe Marketplace • Transaksi aman & terpercaya',
              style: TextStyle(fontSize: 11.5, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrototypeAuthDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: BatikColors.marun),
            SizedBox(width: 10),
            Text('Simulasi Checkout & Auth'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ini adalah prototipe antarmuka (UI Mockup).',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Pada implementasi sistem penuh, tombol ini akan menghubungkan Google Sign-In untuk otentikasi pembeli, kemudian membuka Payment Gateway (QRIS/Transfer Bank) yang langsung menyalurkan dana ke masing-masing rekening UMKM Desa Ngentrong.',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: BatikColors.marun),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(cartNotifierProvider.notifier).clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulasi Berhasil: Pesanan telah dibuat untuk pengrajin Ngentrong!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/');
            },
            child: const Text('Simulasi Pesanan Selesai'),
          ),
        ],
      ),
    );
  }
}

