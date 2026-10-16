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
    // --- Toko: Batik Barokah Ngentrong (barokah) ---
    const Product(
      id: 'btk-1',
      name: 'Kemeja Batik Cengkeh Lengan Panjang',
      storeId: 'barokah',
      storeName: 'Batik Barokah Ngentrong',
      price: 285000,
      technique: 'Batik Tulis Kombinasi Cap',
      motif: 'Bunga Cengkeh Trenggalek',
      fabric: 'Katun Primissima Adem',
      isBestseller: true,
      description:
          'Kemeja batik pria dengan motif khas kuncup bunga cengkeh yang menjadi ikon kebanggaan Desa Ngentrong, Trenggalek. Dibuat dengan pewarna ramah lingkungan dan jahitan rapi berfuring halus.',
      colors: [_colorMarun, _colorSoga, _colorNila],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    ),
    const Product(
      id: 'btk-2',
      name: 'Kain Batik Tulis Motif Cengkeh Sekar Arum',
      storeId: 'barokah',
      storeName: 'Batik Barokah Ngentrong',
      price: 450000,
      technique: 'Batik Tulis Tangan Penuh',
      motif: 'Cengkeh Kombinasi Sekar Jagad',
      fabric: 'Katun Mori Sen Pilihan',
      isBestseller: false,
      description:
          'Kain lembaran 2.2 meter x 1.15 meter hasil cantingan halus pengrajin senior Desa Ngentrong. Cocok untuk bahan jarik manten, kemeja formal, maupun seragam pesta keluarga.',
      colors: [_colorSoga, _colorNila, _colorKrem],
      sizes: ['Panjang 2.2m x 1.15m'],
    ),
    const Product(
      id: 'btk-3',
      name: 'Blus Tunik Batik Cengkeh Modern',
      storeId: 'barokah',
      storeName: 'Batik Barokah Ngentrong',
      price: 235000,
      technique: 'Batik Cap Tradisional',
      motif: 'Cengkeh Pesisir',
      fabric: 'Katun Rayon Lembut',
      isBestseller: true,
      description:
          'Tunik wanita berpotongan longgar yang anggun dan nyaman dikenakan sepanjang hari. Motif cengkeh tersusun rapi dengan sentuhan garis kontemporer.',
      colors: [_colorNila, _colorMarun, _colorHijau],
      sizes: ['M', 'L', 'XL'],
    ),

    // --- Toko: Sanggar Sekar Jagad (sekar-jagad) ---
    const Product(
      id: 'btk-4',
      name: 'Kain Sutra Tulis Alusan Sekar Jagad',
      storeId: 'sekar-jagad',
      storeName: 'Sanggar Sekar Jagad',
      price: 850000,
      technique: 'Batik Tulis Canting Alus',
      motif: 'Sekar Jagad Trenggalekan',
      fabric: 'Sutra Dobi Premium',
      isBestseller: true,
      description:
          'Mahakarya batik tulis pesisir dengan motif keanekaragaman nusantara (Sekar Jagad). Proses pembuatan memakan waktu lebih dari 1 bulan dengan detail isen-isen super teliti.',
      colors: [_colorSoga, _colorNila],
      sizes: ['Panjang 2.5m x 1.15m'],
    ),
    const Product(
      id: 'btk-5',
      name: 'Kemeja Sutra Pria Motif Parang Trenggalek',
      storeId: 'sekar-jagad',
      storeName: 'Sanggar Sekar Jagad',
      price: 520000,
      technique: 'Batik Tulis Asli',
      motif: 'Parang Rusak Seling Cengkeh',
      fabric: 'Sutra Katun Mewah',
      isBestseller: false,
      description:
          'Kemeja eksklusif dengan lining furing katun sutra. Menggabungkan wibawa motif parang dengan kelembutan ornamen bunga cengkeh khas Ngentrong.',
      colors: [_colorHitam, _colorSoga, _colorMarun],
      sizes: ['M', 'L', 'XL', 'XXL'],
    ),
    const Product(
      id: 'btk-6',
      name: 'Selendang Batik Tulis Pesisir',
      storeId: 'sekar-jagad',
      storeName: 'Sanggar Sekar Jagad',
      price: 320000,
      technique: 'Batik Tulis Asli',
      motif: 'Sekar Pesisir',
      fabric: 'Sutra Dobi Mengkilap',
      isBestseller: false,
      description:
          'Selendang anggun pelengkap kebaya adat dan busana formal. Pewarnaan alami dengan pinggiran rumbai yang dipilin rapi dengan tangan.',
      colors: [_colorMarun, _colorKrem, _colorNila],
      sizes: ['Panjang 2.0m x 0.55m'],
    ),

    // --- Toko: Batik Melati Karangan (melati) ---
    const Product(
      id: 'btk-7',
      name: 'Kemeja Batik Slim Fit Motif Kawung Cengkeh',
      storeId: 'melati',
      storeName: 'Batik Melati Karangan',
      price: 195000,
      technique: 'Batik Cap Semi Tulis',
      motif: 'Kawung Padu Cengkeh',
      fabric: 'Katun Sanforized Awet',
      isBestseller: true,
      description:
          'Kemeja kerja pria dengan fitting modern slim-fit. Warna pekat tidak mudah luntur dan sangat mudah disetrika, pas untuk rutinitas harian di kantor.',
      colors: [_colorNila, _colorSoga, _colorHitam],
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    const Product(
      id: 'btk-8',
      name: 'Dress Batik A-Line Karangan',
      storeId: 'melati',
      storeName: 'Batik Melati Karangan',
      price: 245000,
      technique: 'Batik Cap Tradisional',
      motif: 'Melati Cengkeh Mekar',
      fabric: 'Katun Primissima Adem',
      isBestseller: false,
      description:
          'Gaun terusan batik siluet A-line yang anggun dan fleksibel untuk berbagai bentuk tubuh. Dilengkapi saku samping tersembunyi dan ritsleting belakang.',
      colors: [_colorMarun, _colorHijau, _colorSoga],
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    const Product(
      id: 'btk-9',
      name: 'Outer Kimono Batik Cap Santai',
      storeId: 'melati',
      storeName: 'Batik Melati Karangan',
      price: 175000,
      technique: 'Batik Cap Tradisional',
      motif: 'Geometris Pesisir Ngentrong',
      fabric: 'Katun Rayon Twill',
      isBestseller: false,
      description:
          'Outer santai model kimono yang dapat dipadupadankan dengan celana jeans atau rok polos. Cocok untuk acara kasual maupun semi-formal.',
      colors: [_colorNila, _colorKrem, _colorHitam],
      sizes: ['All Size (Fit to XL)'],
    ),

    // --- Toko: Omah Batik Ngentrong Asri (omah-asri) ---
    const Product(
      id: 'btk-10',
      name: 'Kemeja Kasual Batik Kerah Mandar',
      storeId: 'omah-asri',
      storeName: 'Omah Batik Ngentrong Asri',
      price: 215000,
      technique: 'Batik Cap Kontemporer',
      motif: 'Cengkeh Abstrak Minimalis',
      fabric: 'Katun Toyobo Campur Mori',
      isBestseller: true,
      description:
          'Kemeja berkerah Shanghai/Mandarin dengan desain motif batik cengkeh yang ditata bergaya urban minimalis. Pilihan favorit kawula muda Trenggalek.',
      colors: [_colorHijau, _colorHitam, _colorSoga],
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    const Product(
      id: 'btk-11',
      name: 'Vest Batik Bolak-Balik Ngentrong',
      storeId: 'omah-asri',
      storeName: 'Omah Batik Ngentrong Asri',
      price: 165000,
      technique: 'Batik Cap Kombinasi Polos',
      motif: 'Kawung Geometris Modern',
      fabric: 'Katun Kanvas Halus',
      isBestseller: false,
      description:
          'Rompi (vest) reversibel dengan satu sisi batik motif khas Desa Ngentrong dan satu sisi polos warna soga. Dua gaya dalam satu busana.',
      colors: [_colorSoga, _colorNila],
      sizes: ['M', 'L', 'XL'],
    ),
    const Product(
      id: 'btk-12',
      name: 'Tote Bag & Pouch Batik Cengkeh',
      storeId: 'omah-asri',
      storeName: 'Omah Batik Ngentrong Asri',
      price: 95000,
      technique: 'Batik Cap Perca Daur Ulang',
      motif: 'Kompilasi Motif Ngentrong',
      fabric: 'Kain Blacu Lapis Batik Primissima',
      isBestseller: false,
      description:
          'Set tas jinjing dan dompet pouch serbaguna ramah lingkungan. Dibuat dari perca batik sisa potongan bernilai seni tinggi.',
      colors: [_colorMarun, _colorNila, _colorSoga],
      sizes: ['Standar 38cm x 42cm'],
    ),

    // --- Toko: Batik Tulis Sekar Arum (sekar-arum) ---
    const Product(
      id: 'btk-13',
      name: 'Jarik Gendong Batik Tulis Halus',
      storeId: 'sekar-arum',
      storeName: 'Batik Tulis Sekar Arum',
      price: 380000,
      technique: 'Batik Tulis Alami Tradisional',
      motif: 'Sekar Arum Cengkeh Mataram',
      fabric: 'Katun Primissima Halus Lembut',
      isBestseller: false,
      description:
          'Kain jarik tradisional dengan serat benang rapat dan sangat lembut di kulit. Dapat digunakan untuk jarik selendang gendong bayi maupun busana lilit tradisional.',
      colors: [_colorSoga, _colorNila],
      sizes: ['Panjang 2.4m x 1.05m'],
    ),
    const Product(
      id: 'btk-14',
      name: 'Kain Panjang Batik Tulis Babon Angrem',
      storeId: 'sekar-arum',
      storeName: 'Batik Tulis Sekar Arum',
      price: 720000,
      technique: 'Batik Tulis Tangan Asli',
      motif: 'Babon Angrem Seling Cengkeh',
      fabric: 'Katun Berkolissima Asli Solo',
      isBestseller: true,
      description:
          'Kain batik tulis filosofis yang melambangkan kasih sayang ibu dan ketentraman keluarga. Pewarnaan soga klasik yang matang dan beraroma khas malam batik alami.',
      colors: [_colorSoga, _colorMarun],
      sizes: ['Panjang 2.5m x 1.15m'],
    ),
  ];

  Future<ProductPageResult> fetchPage({
    required int page,
    int pageSize = 8,
    String? storeId,
    String query = '',
  }) async {
    // Simulasi jeda network
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final q = query.trim().toLowerCase();
    final filtered = _allProducts.where((p) {
      final storeMatch = storeId == null || p.storeId == storeId;
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
    return _allProducts.where((p) => p.storeId == storeId).toList();
  }

  List<Product> get allProductsSync => _allProducts;
}

