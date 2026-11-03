import 'package:flutter/material.dart';

/// Entitas data Toko UMKM di Desa Ngentrong.
class Store {
  const Store({
    required this.id,
    required this.name,
    required this.owner,
    required this.description,
    required this.address,
    required this.phone,
    required this.brandColor,
    required this.initials,
    required this.craftType,
    required this.rating,
    required this.yearEstablished,
  });

  final String id;
  final String name;
  final String owner;
  final String description;
  final String address;
  final String phone;
  final Color brandColor;
  final String initials;
  final String craftType;
  final double rating;
  final int yearEstablished;
}

