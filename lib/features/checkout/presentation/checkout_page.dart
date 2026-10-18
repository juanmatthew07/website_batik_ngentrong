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
import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/presentation/widgets/google_auth_dialog.dart';
import '../../cart/domain/cart_item.dart';
import '../../cart/presentation/providers/cart_provider.dart';
import 'widgets/store_qris_payment_section.dart';

/// Halaman Checkout & Pembayaran QRIS (/checkout).
/// Menyajikan rincian pesanan per toko, data akun Google pemesan, dan modul pembayaran QRIS.
class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(cartGroupedByStoreProvider);
    final totalCount = ref.watch(cartTotalCountProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);
    final authState = ref.watch(authNotifierProvider);

    // Estimasi ongkos kirim standar per toko UMKM Ngentrong
    const shippingPerStore = 15000;
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
                      'Pembayaran QRIS',
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
                        final isWide = constraints.maxWidth >= 900;

                        final details = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Akun Google Pemesan
                            _buildGoogleUserCard(context, ref, authState),

                            const SizedBox(height: 20),

                            // 2. Alamat Pengiriman
                            _buildAddressCard(authState),

                            const SizedBox(height: 24),

                            // 3. Rincian Barang per Toko UMKM
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

                        final paymentSide = Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Ringkasan Tagihan
                            _buildBillSummaryCard(
                              totalPrice: totalPrice,
                              totalShipping: totalShipping,
                              grandTotal: grandTotal,
                              storeCount: groups.length,
                            ),

                            const SizedBox(height: 24),

                            // Komponen UI Pembayaran QRIS
                            StoreQrisPaymentSection(
                              totalAmount: grandTotal,
                              onPaymentSuccess: () {
                                ref.read(cartNotifierProvider.notifier).clearCart();
                                context.go('/');
                              },
                            ),
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: details),
                              const SizedBox(width: 32),
                              Expanded(flex: 5, child: paymentSide),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            details,
                            const SizedBox(height: 28),
                            paymentSide,
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
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada item yang sedang diproses.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keranjang belanja Anda kosong atau pembayaran telah diselesaikan.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.storefront, size: 18),
              label: const Text('Mulai Belanja Batik'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleUserCard(BuildContext context, WidgetRef ref, AuthState authState) {
    final user = authState.currentUser;
    final isLoggedIn = authState.isAuthenticated && user != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BatikColors.garis),
      ),
      child: Row(
        children: [
          if (isLoggedIn)
            CircleAvatar(
              radius: 22,
              backgroundColor: BatikColors.marun,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : 'U',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          else
            const GoogleLogo(size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isLoggedIn ? user.name : 'Belum Login Google',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    const SizedBox(width: 6),
                    if (isLoggedIn)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GoogleLogo(size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Google Auth',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF174EA6),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  isLoggedIn ? user.email : 'Login Google diperlukan untuk verifikasi identitas pesanan.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
            ),
            onPressed: () => showGoogleAuthDialog(context),
            child: Text(
              isLoggedIn ? 'Ganti Akun' : 'Login Google',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AuthState authState) {
    final user = authState.currentUser;
    final name = user?.name ?? 'Budi Santoso';
    final phone = user?.phoneNumber ?? '0812-3456-7890';
    final address = user?.defaultAddress ??
        'Jl. Pemuda No. 45, RT 03 RW 01, Kelurahan Ngantru, Kec. Trenggalek, Kab. Trenggalek, Jawa Timur 66311';

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
                'Alamat Pengiriman',
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
          Text(
            '$name • $phone',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            address,
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
                    child: BatikProductImage(
                      imageUrl: item.product.imageUrl,
                      iconSize: 18,
                    ),
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
                const Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, size: 18, color: BatikColors.soga),
                    SizedBox(width: 8),
                    Text(
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

  Widget _buildBillSummaryCard({
    required int totalPrice,
    required int totalShipping,
    required int grandTotal,
    required int storeCount,
  }) {
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
            'Ringkasan Tagihan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BatikColors.sogaGelap),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal Produk Batik:', style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text(formatRupiah(totalPrice), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ongkos Kirim ($storeCount Toko):', style: const TextStyle(color: Colors.black54, fontSize: 13)),
              Text(formatRupiah(totalShipping), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Biaya Layanan UMKM:', style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text('GRATIS (Pemkab Trenggalek)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: BatikColors.garis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Tagihan:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                formatRupiah(grandTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  color: BatikColors.marun,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
