# Katalog Batik Ngentrong (Flutter Web)

Katalog web UMKM batik Desa Ngentrong, Kec. Karangan, Kab. Trenggalek.
Tampilan grid produk mengacu ke Uniqlo, dengan nuansa batik (palet soga, nila, marun, emas,
pola kawung dan cengkeh yang digambar lewat kode, serta pita tumpal).

Data produk di `lib/data/product_repository.dart` masih **data contoh**. Teks, harga, dan nomor
WhatsApp di `lib/config.dart` juga perlu diganti dengan data UMKM yang asli.

## Menjalankan

Syarat: Flutter SDK terpasang (`flutter doctor` tidak ada masalah untuk Chrome).

Folder ini hanya berisi `pubspec.yaml`, `lib/`, `test/`, dan `assets/`. Folder platform web
(`web/`) dibuat oleh Flutter, jadi lakukan sekali saja:

```bash
flutter create --platforms=web --project-name batik_ngentrong temp_proyek
```

Lalu salin hasilnya:

1. Salin folder `web/` dari `temp_proyek/` ke folder proyek ini.
2. Hapus `temp_proyek/` dan hapus `test/widget_test.dart` bawaan jika ada (memanggil `MyApp` yang tidak ada di sini).
3. Jalankan:

```bash
flutter pub get
flutter run -d chrome
```

Build untuk di-hosting:

```bash
flutter build web --release
```

Hasilnya ada di `build/web/` (bisa diunggah ke Firebase Hosting, Netlify, atau GitHub Pages).

## Struktur

```
lib/
  main.dart                 titik masuk aplikasi
  config.dart               nama toko, alamat, nomor WhatsApp
  theme/batik_theme.dart    warna dan tema
  models/product.dart       model Product dan Colorway
  data/product_repository.dart   sumber data (contoh), paging dan filter
  utils/                    format rupiah, buka WhatsApp
  widgets/                  header, kartu produk, pola batik, dll
  pages/                    halaman katalog dan detail produk
```

## Cara kerja lazy load

1. **Data per halaman.** `ProductRepository.fetchPage` mengembalikan 12 produk per panggilan.
   Halaman berikutnya diminta saat pengguna hampir sampai di dasar daftar.
2. **Grid builder.** `SliverGrid` dengan `SliverChildBuilderDelegate` hanya membangun kartu yang
   terlihat (plus `cacheExtent` 500 px), jadi ratusan produk tidak membuat berat.
3. **Foto.** Foto baru diunduh saat kartunya dibangun, didekode kecil (`cacheWidth`), dan muncul
   dengan fade-in di atas pola batik. Selama foto belum datang (atau gagal), pola batik tetap tampil.

## Memasang produk asli

- Ganti isi `fetchPage` agar memanggil API, Firebase, atau Google Sheets. Selama hasilnya
  `ProductPage`, halaman katalog tidak perlu diubah.
- Isi `imageUrl` pada tiap `Product`. Saran foto: format WebP, lebar sekitar 800 px, rasio 3:4.
- Di web, server foto harus mengizinkan CORS, kalau tidak foto tidak akan tampil. Firebase
  Storage atau hosting yang sama dengan aplikasi biasanya aman.

## Kerja kelompok

- Buat satu repo di GitHub, lalu `git init`, commit, dan push dari folder proyek ini.
- Satu orang satu cabang (branch), gabungkan lewat pull request.
- Pembagian yang masuk akal: satu orang mengurus data dan API (`data/`, `models/`), satu orang
  mengurus tampilan (`widgets/`, `pages/`, `theme/`).
