import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

/// Membuka obrolan WhatsApp dengan nomor dan pesan yang disesuaikan.
Future<void> openWhatsApp({
  String? phone,
  String message = 'Halo, saya tertarik dengan produk Batik Desa Ngentrong.',
}) async {
  final targetPhone = phone ?? kWhatsAppNumber;
  final uri = Uri.parse(
    'https://wa.me/$targetPhone?text=${Uri.encodeComponent(message)}',
  );
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

