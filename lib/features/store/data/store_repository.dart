import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/batik_theme.dart';
import '../domain/store.dart';

/// Repository penyedia data Toko UMKM Desa Ngentrong.
/// Menggunakan data dummy yang siap dialihkan ke API / Firestore di kemudian hari.
class StoreRepository {
  static const List<Store> _stores = [
    Store(
      id: 'barokah',
      name: 'Batik Barokah Ngentrong',
      owner: 'Ibu Hj. Siti Aminah',
      description:
          'Pelopor motif batik cengkeh khas Trenggalek di Desa Ngentrong. Menghadirkan batik cap dan tulis dengan pewarna alami soga dan nila yang ramah lingkungan.',
      address: 'RT 04 RW 02, Dusun Krajan, Desa Ngentrong, Kec. Karangan, Trenggalek',
      phone: '6281234567801',
      brandColor: BatikColors.marun,
      initials: 'BB',
      craftType: 'Batik Tulis & Cap Motif Cengkeh',
      rating: 4.9,
      yearEstablished: 2012,
    ),
    Store(
      id: 'sekar-jagad',
      name: 'Sanggar Sekar Jagad',
      owner: 'Pak Joko Widodo',
      description:
          'Spesialis kain panjang batik tulis halus khas pesisir. Dikerjakan manual dengan canting tembaga oleh ibu-ibu pengrajin Desa Ngentrong.',
      address: 'RT 07 RW 03, Desa Ngentrong, Kec. Karangan, Trenggalek',
      phone: '6281234567802',
      brandColor: BatikColors.nila,
      initials: 'SJ',
      craftType: 'Batik Tulis Alus & Sutra',
      rating: 4.8,
      yearEstablished: 2015,
    ),
    Store(
      id: 'melati',
      name: 'Batik Melati Karangan',
      owner: 'Ibu Sri Rahayu',
      description:
          'Menyediakan busana batik modern siap pakai: kemeja kantor, blus, dan outer santai dengan paduan motif geometris parang dan cengkeh.',
      address: 'Jl. Balai Desa Ngentrong No. 12, Trenggalek',
      phone: '6281234567803',
      brandColor: BatikColors.soga,
      initials: 'BM',
      craftType: 'Busana Batik Modern Siap Pakai',
      rating: 4.7,
      yearEstablished: 2018,
    ),
    Store(
      id: 'omah-asri',
      name: 'Omah Batik Ngentrong Asri',
      owner: 'Mas Dimas Pratama',
      description:
          'Inovasi generasi muda Ngentrong yang memadukan motif tradisional Trenggalek dengan gaya kasual kekinian. Cocok untuk anak muda.',
      address: 'RT 02 RW 01, Dusun Ngentrong Tengah, Karangan, Trenggalek',
      phone: '6281234567804',
      brandColor: BatikColors.hijau,
      initials: 'OA',
      craftType: 'Batik Kasual & Kontemporer',
      rating: 4.9,
      yearEstablished: 2021,
    ),
    Store(
      id: 'sekar-arum',
      name: 'Batik Tulis Sekar Arum',
      owner: 'Ibu Endang Sulastri',
      description:
          'Pusat batik tulis motif klasik Trenggalek dengan bahan primissima dan sutra dobi. Menjaga pakem motif leluhur secara turun-temurun.',
      address: 'RT 09 RW 04, Desa Ngentrong, Kec. Karangan, Trenggalek',
      phone: '6281234567805',
      brandColor: BatikColors.sogaGelap,
      initials: 'SA',
      craftType: 'Kain Batik Tulis Primissima',
      rating: 5.0,
      yearEstablished: 2008,
    ),
  ];

  Future<List<Store>> getAllStores() async {
    // Simulasi jeda network singkat
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _stores;
  }

  Future<Store?> getStoreById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return _stores.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Store> get storesSync => _stores;
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository();
});

final allStoresProvider = FutureProvider<List<Store>>((ref) async {
  final repo = ref.watch(storeRepositoryProvider);
  return repo.getAllStores();
});

final storeByIdProvider = FutureProvider.family<Store?, String>((ref, id) async {
  final repo = ref.watch(storeRepositoryProvider);
  return repo.getStoreById(id);
});

