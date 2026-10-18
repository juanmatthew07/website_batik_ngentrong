import 'dart:math' as math;

import '../../../core/theme/batik_theme.dart';
import '../domain/product.dart';
import 'package:flutter/material.dart';

class ProductPageResult {
  const ProductPageResult({
    required this.items,
    required this.hasMore,
    required this.total,
  });

  final List<Product> items;
  final bool hasMore;
  final int total;
}

/// Repository produk batik UMKM Desa Ngentrong.
class ProductRepository {
  static const _colorSoga = BatikColorOption(name: 'Soga Coklat', color: BatikColors.soga);
  static const _colorNila = BatikColorOption(name: 'Nila Indigo', color: BatikColors.nila);
  static const _colorMarun = BatikColorOption(name: 'Marun Klasik', color: BatikColors.marun);
  static const _colorKrem = BatikColorOption(name: 'Krem Alami', color: Color(0xFFD4C3A3));
  static const _colorHijau = BatikColorOption(name: 'Hijau Lumut', color: BatikColors.hijau);
  static const _colorHitam = BatikColorOption(name: 'Hitam Arang', color: Color(0xFF222222));

  static final List<Product> _allProducts = [
    // --- Toko: Batik Sekar Jagad Trenggalek (umkm_01) ---
    const Product(
      id: 'btk-1',
      name: 'Batik Motif Turonggo Yakso',
      storeId: 'umkm_01',
      storeName: 'Batik Sekar Jagad Trenggalek',
      price: 85000,
      pricePerMeter: 85000,
      priceShirt: 220000,
      priceKilogram: 280000,
      technique: 'Batik Tulis Khas Trenggalek',
      motif: 'Turonggo Yakso',
      fabric: 'Katun Primissima Adem',
      isBestseller: true,
      imageUrl: 'assets/batik_images/umkm01_turonggo_yakso.jpg',
      description:
          'Batik dengan motif kebanggaan Trenggalek, Turonggo Yakso, menggambarkan semangat ksatria kesenian jaranan khas Trenggalek. Dibuat dengan pewarna ramah lingkungan dan jahitan rapi berfuring halus.',
      colors: [_colorMarun, _colorSoga, _colorHitam],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL', 'Paket Kiloan'],
    ),
    const Product(
      id: 'btk-2',
      name: 'Batik Motif Cengkehan',
      storeId: 'umkm_01',
      storeName: 'Batik Sekar Jagad Trenggalek',
      price: 75000,
      pricePerMeter: 75000,
      priceShirt: 195000,
      priceKilogram: null,
      technique: 'Batik Cap Kombinasi Tulis',
      motif: 'Cengkehan',
      fabric: 'Katun Mori Sen Pilihan',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm01_cengkehan.jpg',
      description:
          'Motif Cengkehan melambangkan kekayaan alam cengkeh Trenggalek yang subur dan harum. Bahan halus, adem, dan sangat anggun untuk pakaian pria maupun wanita.',
      colors: [_colorSoga, _colorNila, _colorKrem],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),
    const Product(
      id: 'btk-3',
      name: 'Batik Motif Gajah Nungguk',
      storeId: 'umkm_01',
      storeName: 'Batik Sekar Jagad Trenggalek',
      price: 110000,
      pricePerMeter: 110000,
      priceShirt: 280000,
      priceKilogram: 350000,
      technique: 'Batik Tulis Tradisional',
      motif: 'Gajah Nungguk',
      fabric: 'Katun Primissima Adem',
      isBestseller: true,
      imageUrl: 'assets/batik_images/umkm01_gajah_nungguk.jpg',
      description:
          'Motif klasik legendaris Gajah Nungguk Trenggalek yang melambangkan kekokohan, kebijaksanaan, dan kepemimpinan luhur masyarakat Trenggalek.',
      colors: [_colorNila, _colorMarun, _colorHijau],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL', 'Paket Kiloan'],
    ),

    // --- Toko: Batik Tulis Sekar Biru (umkm_02) ---
    const Product(
      id: 'btk-4',
      name: 'Batik Tulis Motif Pari Srono',
      storeId: 'umkm_02',
      storeName: 'Batik Tulis Sekar Biru',
      price: 120000,
      pricePerMeter: 120000,
      priceShirt: 310000,
      priceKilogram: null,
      technique: 'Batik Tulis Alusan',
      motif: 'Pari Srono',
      fabric: 'Katun Primissima Alus',
      isBestseller: true,
      imageUrl: 'assets/batik_images/umkm02_pari_srono.jpg',
      description:
          'Motif Pari Srono (bulir padi menguning) mencerminkan kemakmuran pangan dan kerendahan hati. Guratan canting teliti oleh perajin senior Desa Sumbergedong.',
      colors: [_colorSoga, _colorNila],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),
    const Product(
      id: 'btk-5',
      name: 'Batik Motif Manggis Trenggalek',
      storeId: 'umkm_02',
      storeName: 'Batik Tulis Sekar Biru',
      price: 95000,
      pricePerMeter: 95000,
      priceShirt: 240000,
      priceKilogram: 320000,
      technique: 'Batik Tulis Tangan Asli',
      motif: 'Manggis Trenggalek',
      fabric: 'Katun Primissima Lembut',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm02_manggis_trenggalek.jpg',
      description:
          'Mengangkat buah manggis Trenggalek dengan filosofi kejujuran dan kemurnian budi pekerti. Warna anggun nan memikat, awet tidak luntur.',
      colors: [_colorHitam, _colorSoga, _colorMarun],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL', 'Paket Kiloan'],
    ),

    // --- Toko: Sanggar Batik Mutiara Menak Sopal (umkm_03) ---
    const Product(
      id: 'btk-6',
      name: 'Batik Tulis Turonggo Yakso Halus',
      storeId: 'umkm_03',
      storeName: 'Sanggar Batik Mutiara Menak Sopal',
      price: 150000,
      pricePerMeter: 150000,
      priceShirt: 380000,
      priceKilogram: null,
      technique: 'Batik Tulis Canting Alus',
      motif: 'Turonggo Yakso Halus',
      fabric: 'Sutra Katun Super Primissima',
      isBestseller: true,
      imageUrl: 'assets/batik_images/umkm03_turonggo_yakso_halus.jpg',
      description:
          'Mahakarya Sanggar Menak Sopal dengan isen-isen super teliti pada setiap lekuk ornamen kesenian Turonggo Yakso. Sangat berwibawa dan bernilai seni tinggi.',
      colors: [_colorMarun, _colorKrem, _colorNila],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),
    const Product(
      id: 'btk-7',
      name: 'Batik Motif Batu Tumpuk',
      storeId: 'umkm_03',
      storeName: 'Sanggar Batik Mutiara Menak Sopal',
      price: 80000,
      pricePerMeter: 80000,
      priceShirt: null,
      priceKilogram: 260000,
      technique: 'Batik Cap Tradisional',
      motif: 'Batu Tumpuk',
      fabric: 'Katun Sanforized Awet',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm03_batu_tumpuk.jpg',
      description:
          'Motif geometris Batu Tumpuk terinspirasi dari pondasi kokoh bendungan peninggalan Menak Sopal. Kuat, rapi, dan serbaguna untuk busana maupun taplak kain.',
      colors: [_colorNila, _colorSoga, _colorHitam],
      sizes: ['Kain per Meter', 'Paket Kiloan'],
    ),
    const Product(
      id: 'btk-8',
      name: 'Batik Cengkehan Sederhana',
      storeId: 'umkm_03',
      storeName: 'Sanggar Batik Mutiara Menak Sopal',
      price: 65000,
      pricePerMeter: 65000,
      priceShirt: 175000,
      priceKilogram: 220000,
      technique: 'Batik Cap Semi Tulis',
      motif: 'Cengkehan Sederhana',
      fabric: 'Katun Primissima Adem',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm03_cengkehan_sederhana.jpg',
      description:
          'Pola motif cengkeh minimalis yang bersahaja dengan harga ramah kantong. Pilihan tepat untuk bahan seragam keluarga maupun komunitas.',
      colors: [_colorMarun, _colorHijau, _colorSoga],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL', 'Paket Kiloan'],
    ),
    const Product(
      id: 'btk-9',
      name: 'Batik Motif Kopi Trenggalek',
      storeId: 'umkm_03',
      storeName: 'Sanggar Batik Mutiara Menak Sopal',
      price: 90000,
      pricePerMeter: 90000,
      priceShirt: 230000,
      priceKilogram: null,
      technique: 'Batik Cap Tradisional',
      motif: 'Kopi Trenggalek',
      fabric: 'Katun Rayon Twill',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm03_kopi_trenggalek.jpg',
      description:
          'Terinspirasi dari perkebunan kopi robusta lereng pegunungan Trenggalek. Perpaduan motif biji kopi dan dedaunan yang unik, estetik, dan berkarakter.',
      colors: [_colorNila, _colorKrem, _colorHitam],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),

    // --- Toko: Batik Tulis Widodo Krajan (umkm_04) ---
    const Product(
      id: 'btk-10',
      name: 'Batik Tulis Bunga Cengkeh',
      storeId: 'umkm_04',
      storeName: 'Batik Tulis Widodo Krajan',
      price: 70000,
      pricePerMeter: 70000,
      priceShirt: 180000,
      priceKilogram: 240000,
      technique: 'Batik Tulis & Cap Kampak',
      motif: 'Bunga Cengkeh',
      fabric: 'Katun Toyobo Campur Mori',
      isBestseller: true,
      imageUrl: 'assets/batik_images/umkm04_bunga_cengkeh.jpg',
      description:
          'Bunga cengkeh khas perbukitan Kampak dengan warna alami yang sejuk. Sangat nyaman untuk busana kantor harian.',
      colors: [_colorHijau, _colorHitam, _colorSoga],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL', 'Paket Kiloan'],
    ),
    const Product(
      id: 'btk-11',
      name: 'Batik Gajah Nungguk Klasik',
      storeId: 'umkm_04',
      storeName: 'Batik Tulis Widodo Krajan',
      price: 130000,
      pricePerMeter: 130000,
      priceShirt: 330000,
      priceKilogram: null,
      technique: 'Batik Tulis Canting Tangan',
      motif: 'Gajah Nungguk Klasik',
      fabric: 'Katun Mori Sen Lembut',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm04_gajah_nungguk_klasik.jpg',
      description:
          'Motif pusaka Gajah Nungguk dengan sentuhan gaya klasik khas Kampak Trenggalek. Memiliki garis tegas dan filosofi keagungan.',
      colors: [_colorSoga, _colorNila],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),

    // --- Toko: Oemah Batik Ngalum (umkm_05) ---
    const Product(
      id: 'btk-12',
      name: 'Batik Turonggo Yakso Kombinasi',
      storeId: 'umkm_05',
      storeName: 'Oemah Batik Ngalum',
      price: 100000,
      pricePerMeter: 100000,
      priceShirt: 260000,
      priceKilogram: null,
      technique: 'Batik Cap Kombinasi Tulis',
      motif: 'Turonggo Yakso Kombinasi',
      fabric: 'Katun Blacu Halus Primissima',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm05_turonggo_yakso_kombinasi.jpg',
      description:
          'Eksplorasi kontemporer jaranan Turonggo Yakso oleh pengrajin muda Durenan. Tampil dinamis dan modis untuk berbagai kesempatan.',
      colors: [_colorMarun, _colorNila, _colorSoga],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),
    const Product(
      id: 'btk-13',
      name: 'Batik Pari Srono Mas',
      storeId: 'umkm_05',
      storeName: 'Oemah Batik Ngalum',
      price: 140000,
      pricePerMeter: 140000,
      priceShirt: 350000,
      priceKilogram: 450000,
      technique: 'Batik Tulis Alus Prada',
      motif: 'Pari Srono Mas',
      fabric: 'Katun Primissima Halus Lembut',
      isBestseller: true,
      imageUrl: 'assets/batik_images/umkm05_pari_srono_mas.jpg',
      description:
          'Simbol kemakmuran panen raya Trenggalek berhias aksen keemasan. Mewah dan anggun untuk acara resepsi dan perhelatan resmi.',
      colors: [_colorSoga, _colorNila],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL', 'Paket Kiloan'],
    ),
    const Product(
      id: 'btk-14',
      name: 'Batik Manggis Tiga Rasa',
      storeId: 'umkm_05',
      storeName: 'Oemah Batik Ngalum',
      price: 85000,
      pricePerMeter: 85000,
      priceShirt: 210000,
      priceKilogram: null,
      technique: 'Batik Cap Tradisional Durenan',
      motif: 'Manggis Tiga Rasa',
      fabric: 'Katun Mori Halus Pilihan',
      isBestseller: false,
      imageUrl: 'assets/batik_images/umkm05_manggis_tiga_rasa.jpg',
      description:
          'Motif buah manggis dengan komposisi tiga kelopak khas Durenan yang sarat makna kebersamaan, kejujuran, dan manisnya persaudaraan.',
      colors: [_colorSoga, _colorMarun],
      sizes: ['Kain per Meter', 'Kemeja Jadi S', 'Kemeja Jadi M', 'Kemeja Jadi L', 'Kemeja Jadi XL'],
    ),
  ];

  String _mapStoreId(String? id) {
    if (id == null) return '';
    if (id == 'barokah') return 'umkm_01';
    if (id == 'sekar-jagad') return 'umkm_01';
    if (id == 'melati') return 'umkm_02';
    if (id == 'omah-asri') return 'umkm_03';
    if (id == 'sekar-arum') return 'umkm_04';
    return id;
  }

  Future<ProductPageResult> fetchPage({
    required int page,
    int pageSize = 8,
    String? storeId,
    String query = '',
  }) async {
    // Simulasi jeda network
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final effectiveStoreId = storeId != null ? _mapStoreId(storeId) : null;
    final q = query.trim().toLowerCase();
    final filtered = _allProducts.where((p) {
      final storeMatch = effectiveStoreId == null || p.storeId == effectiveStoreId;
      final queryMatch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.motif.toLowerCase().contains(q) ||
          p.storeName.toLowerCase().contains(q);
      return storeMatch && queryMatch;
    }).toList();

    final start = page * pageSize;
    if (start >= filtered.length) {
      return ProductPageResult(items: const [], hasMore: false, total: filtered.length);
    }
    final end = math.min(start + pageSize, filtered.length);
    return ProductPageResult(
      items: filtered.sublist(start, end),
      hasMore: end < filtered.length,
      total: filtered.length,
    );
  }

  Future<Product?> getProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Product>> getProductsByStore(String storeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final effectiveStoreId = _mapStoreId(storeId);
    return _allProducts.where((p) => p.storeId == effectiveStoreId).toList();
  }

  List<Product> get allProductsSync => _allProducts;
}

