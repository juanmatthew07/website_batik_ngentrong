import 'package:flutter/material.dart';

/// Opsi warna solid bernuansa batik.
class BatikColorOption {
  const BatikColorOption({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;
}

/// Model entitas Produk Batik dari UMKM Desa Ngentrong.
/// Hanya menampilkan harga asli (tanpa harga coret/diskon palsu).
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.storeId,
    required this.storeName,
    required this.price,
    required this.description,
    required this.technique,
    required this.motif,
    required this.fabric,
    required this.colors,
    required this.sizes,
    this.isBestseller = false,
  });

  final String id;
  final String name;
  final String storeId;
  final String storeName;

  /// Harga asli dalam rupiah.
  final int price;

  final String description;
  final String technique;
  final String motif;
  final String fabric;
  final List<BatikColorOption> colors;
  final List<String> sizes;
  final bool isBestseller;
}

