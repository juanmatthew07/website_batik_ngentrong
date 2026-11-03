import 'package:flutter/material.dart';

/// Template pakaian untuk mockup batik.
class MockupTemplate {
  const MockupTemplate({
    required this.id,
    required this.name,
    required this.icon,
    required this.aspectRatio,
  });

  final String id;
  final String name;
  final IconData icon;
  final double aspectRatio;

  static const List<MockupTemplate> all = [
    MockupTemplate(
      id: 'kemeja-panjang',
      name: 'Kemeja Lengan Panjang',
      icon: Icons.checkroom,
      aspectRatio: 0.75,
    ),
    MockupTemplate(
      id: 'kemeja-pendek',
      name: 'Kemeja Lengan Pendek',
      icon: Icons.dry_cleaning,
      aspectRatio: 0.8,
    ),
    MockupTemplate(
      id: 'kaos',
      name: 'Kaos',
      icon: Icons.sports_soccer,
      aspectRatio: 0.85,
    ),
    MockupTemplate(
      id: 'dress',
      name: 'Dress Wanita',
      icon: Icons.woman,
      aspectRatio: 0.7,
    ),
    MockupTemplate(
      id: 'tote-bag',
      name: 'Tote Bag',
      icon: Icons.shopping_bag,
      aspectRatio: 1.0,
    ),
  ];
}