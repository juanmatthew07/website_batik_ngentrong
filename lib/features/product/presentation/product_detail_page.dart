import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/batik_theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/whatsapp.dart';
import '../../../core/widgets/batik_product_image.dart';
import '../../../core/widgets/chatbot_fab.dart';
import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/page_width.dart';
import '../../../core/widgets/site_footer.dart';
import '../../cart/presentation/providers/cart_provider.dart';
import '../data/product_repository_provider.dart';
import '../domain/product.dart';

/// Halaman Detail Produk Batik (/batik/:id).
/// Menampilkan placeholder besar, nama batik, nama toko asal (bisa diklik ke /toko/:id),
/// harga asli, pilihan warna/ukuran, dan tombol Tambah ke Keranjang.
class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _selectedColorIndex = 0;
  String? _selectedSize;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      appBar: const MainAppBar(showSearch: false),
      floatingActionButton: const ChatbotFab(),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Produk batik tidak ditemukan.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Kembali ke Beranda'),
                  ),
                ],
              ),
            );
          }

          // Inisialisasi ukuran default jika belum dipilih
          if (_selectedSize == null && product.sizes.isNotEmpty) {
            _selectedSize = product.sizes.first;
          }

          final currentColor = product.colors[_selectedColorIndex];

          return SingleChildScrollView(
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
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.arrow_back, size: 18, color: BatikColors.sogaGelap),
                          label: const Text(
                            'Beranda',
                            style: TextStyle(color: BatikColors.sogaGelap, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        // Klik nama toko untuk langsung ke halaman toko
                        InkWell(
                          onTap: () => context.go('/toko/${product.storeId}'),
                          child: Text(
                            product.storeName,
                            style: const TextStyle(
                              color: BatikColors.marun,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1, color: BatikColors.garis),

                // Area Utama Detail Produk
                PageWidth(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 840;

                      // Gambar Produk Asli dengan Fallback Placeholder
                      final visual = Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BatikColors.garis),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: BatikProductImage(
                            imageUrl: product.imageUrl,
                            badgeText: product.technique,
                            accentColor: currentColor.color,
                            iconSize: 72,
                          ),
                        ),
                      );

                      final info = _buildProductInfo(context, product, currentColor);

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: visual),
                            const SizedBox(width: 48),
                            Expanded(flex: 6, child: info),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          visual,
                          const SizedBox(height: 28),
                          info,
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
                const SiteFooter(),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: BatikColors.marun),
        ),
        error: (_, __) => const Center(child: Text('Gagal memuat produk.')),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, Product p, BatikColorOption currentColor) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kartu Toko Asal yang bisa diklik (Wajib sesuai requirement)
        InkWell(
          onTap: () => context.go('/toko/${p.storeId}'),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: BatikColors.krem,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BatikColors.garis),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront, color: BatikColors.marun, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dibuat & Dijual Oleh Pengrajin:',
                      style: TextStyle(fontSize: 11, color: BatikColors.sogaMuda),
                    ),
                    Text(
                      p.storeName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: BatikColors.marun,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_ios, size: 13, color: BatikColors.marun),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Nama Produk Batik
        Text(
          p.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: BatikColors.sogaGelap,
          ),
        ),

        const SizedBox(height: 12),

        // Harga Asli Saja (Mulai Dari)
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              formatRupiah(p.price),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: BatikColors.sogaGelap,
              ),
            ),
            if (p.pricePerMeter != null) ...[
              const SizedBox(width: 8),
              Text(
                '/ meter',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),

        // Pilihan Harga dari Data UMKM (Meteran, Kemeja Jadi, Kiloan)
        if (p.pricePerMeter != null || p.priceShirt != null || p.priceKilogram != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (p.pricePerMeter != null)
                _priceOptionChip('Kain Meteran', p.pricePerMeter!),
              if (p.priceShirt != null)
                _priceOptionChip('Kemeja Jadi', p.priceShirt!),
              if (p.priceKilogram != null)
                _priceOptionChip('Kiloan', p.priceKilogram!),
            ],
          ),
        ],

        const SizedBox(height: 18),
        const Divider(color: BatikColors.garis),
        const SizedBox(height: 16),

        // Spesifikasi Singkat
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children: [
            _specBadge(Icons.auto_awesome_outlined, 'Motif: ${p.motif}'),
            _specBadge(Icons.brush_outlined, 'Teknik: ${p.technique}'),
            _specBadge(Icons.layers_outlined, 'Bahan: ${p.fabric}'),
          ],
        ),

        const SizedBox(height: 24),

        // Pilihan Warna Solid
        Text(
          'Pilihan Warna: ${currentColor.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < p.colors.length; i++)
              GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColorIndex == i ? BatikColors.marun : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.colors[i].color,
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Pilihan Ukuran
        if (p.sizes.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Pilihan Ukuran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final size in p.sizes)
                ChoiceChip(
                  label: Text(size),
                  selected: _selectedSize == size,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSize = size);
                  },
                  selectedColor: BatikColors.marun,
                  labelStyle: TextStyle(
                    color: _selectedSize == size ? Colors.white : BatikColors.sogaGelap,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],

        const SizedBox(height: 24),

        // Pilihan Jumlah (Quantity)
        Row(
          children: [
            const Text(
              'Jumlah:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 14),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: BatikColors.garis),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Tombol Tambah ke Keranjang
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: BatikColors.marun,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ref.read(cartNotifierProvider.notifier).addItem(
                        product: p,
                        color: currentColor.name,
                        size: _selectedSize ?? (p.sizes.isNotEmpty ? p.sizes.first : 'Standar'),
                        quantity: _quantity,
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil menambahkan "${p.name}" ke keranjang!'),
                      backgroundColor: BatikColors.sogaGelap,
                      action: SnackBarAction(
                        label: 'Lihat Keranjang',
                        textColor: BatikColors.emas,
                        onPressed: () => context.go('/keranjang'),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: const Text('Tambah ke Keranjang'),
              ),
            ),
            const SizedBox(width: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF25D366)),
                foregroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              ),
              onPressed: () {
                final msg =
                    'Halo ${p.storeName}, saya tertarik memesan ${p.name} warna ${currentColor.name}${_selectedSize != null ? " ukuran $_selectedSize" : ""} sejumlah $_quantity pcs.';
                openWhatsApp(message: msg);
              },
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Tanya Toko'),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Deskripsi Produk
        const Text(
          'Tentang Batik Ini',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          p.description,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _specBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: BatikColors.marun),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _priceOptionChip(String label, int price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: BatikColors.garis),
      ),
      child: Text(
        '$label: ${formatRupiah(price)}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: BatikColors.sogaGelap,
        ),
      ),
    );
  }
}

