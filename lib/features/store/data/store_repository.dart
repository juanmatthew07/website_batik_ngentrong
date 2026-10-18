import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/batik_theme.dart';
import '../domain/store.dart';

/// Repository penyedia data Toko UMKM Desa Ngentrong.
/// Menggunakan data dummy yang siap dialihkan ke API / Firestore di kemudian hari.
class StoreRepository {
  static const List<Store> _stores = [
    Store(
      id: 'umkm_01',
      name: 'Batik Sekar Jagad Trenggalek',
      owner: 'Ibu Hj. Siti Aminah',
      description:
          'Pusat kerajinan batik khas Trenggalek dengan motif unggulan Turonggo Yakso, Cengkehan, dan Gajah Nungguk. Menyediakan bahan per meter, kemeja jadi, hingga pembelian kiloan.',
      address: 'Jl. Raya Suruh-Trenggalek No. 45, Kec. Suruh, Kabupaten Trenggalek',
      phone: '6281230000001',
      brandColor: BatikColors.marun,
      initials: 'SJ',
      craftType: 'Batik Turonggo Yakso & Cengkehan',
      rating: 4.9,
      yearEstablished: 2012,
    ),
    Store(
      id: 'umkm_02',
      name: 'Batik Tulis Sekar Biru',
      owner: 'Ibu Sulastri',
      description:
          'Spesialis batik tulis halus motif Pari Srono dan Manggis Trenggalek. Dibuat dengan pewarna berkualitas tinggi oleh pengrajin berpengalaman.',
      address: 'Desa Sumbergedong RT 03/RW 01, Kec. Trenggalek, Kabupaten Trenggalek',
      phone: '6285790000002',
      brandColor: BatikColors.nila,
      initials: 'SB',
      craftType: 'Batik Tulis Pari Srono & Manggis',
      rating: 4.8,
      yearEstablished: 2015,
    ),
    Store(
      id: 'umkm_03',
      name: 'Sanggar Batik Mutiara Menak Sopal',
      owner: 'Bapak Menak Sopal',
      description:
          'Sanggar batik ternama Trenggalek penghasil motif Turonggo Yakso Halus, Batu Tumpuk, Cengkehan Sederhana, dan Kopi Trenggalek.',
      address: 'Jl. Soekarno-Hatta No. 12, Kel. Kelutan, Kec. Trenggalek, Kabupaten Trenggalek',
      phone: '6282130000003',
      brandColor: BatikColors.soga,
      initials: 'MS',
      craftType: 'Batik Tulis Halus & Menak Sopal',
      rating: 5.0,
      yearEstablished: 2010,
    ),
    Store(
      id: 'umkm_04',
      name: 'Batik Tulis Widodo Krajan',
      owner: 'Pak Widodo',
      description:
          'Pusat kerajinan batik khas Kampak Trenggalek dengan motif Bunga Cengkeh dan Gajah Nungguk Klasik berkualitas prima.',
      address: 'RT 12/RW 04, Desa Kampak, Kec. Kampak, Kabupaten Trenggalek',
      phone: '6281400000004',
      brandColor: BatikColors.hijau,
      initials: 'WK',
      craftType: 'Batik Tulis Bunga Cengkeh & Gajah Nungguk',
      rating: 4.7,
      yearEstablished: 2017,
    ),
    Store(
      id: 'umkm_05',
      name: 'Oemah Batik Ngalum',
      owner: 'Mas Dimas Pratama',
      description:
          'Sentra batik Durenan dengan kreasi motif Turonggo Yakso Kombinasi, Pari Srono Mas, dan Manggis Tiga Rasa yang khas dan modern.',
      address: 'Jl. Yos Sudarso No. 88, Kec. Durenan, Kabupaten Trenggalek',
      phone: '6287710000005',
      brandColor: BatikColors.sogaGelap,
      initials: 'ON',
      craftType: 'Batik Kombinasi & Manggis Tiga Rasa',
      rating: 4.9,
      yearEstablished: 2019,
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
      return _stores.firstWhere(
        (s) =>
            s.id == id ||
            (id == 'barokah' && s.id == 'umkm_01') ||
            (id == 'sekar-jagad' && s.id == 'umkm_01') ||
            (id == 'melati' && s.id == 'umkm_02') ||
            (id == 'omah-asri' && s.id == 'umkm_03') ||
            (id == 'sekar-arum' && s.id == 'umkm_04'),
      );
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

