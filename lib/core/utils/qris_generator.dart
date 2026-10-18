/// Helper utilitas untuk membuat Payload QRIS (Quick Response Code Indonesian Standard)
/// sesuai spesifikasi standar EMVCo Merchant-Presented Mode dan Bank Indonesia (ASPI).
class QrisGenerator {
  QrisGenerator._();

  /// Menghitung CRC16-CCITT (polynomial 0x1021, init 0xFFFF) sesuai spesifikasi EMVCo
  static String calculateCrc16(String data) {
    int crc = 0xFFFF;
    final bytes = data.codeUnits;
    for (final byte in bytes) {
      crc ^= (byte << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = ((crc << 1) ^ 0x1021) & 0xFFFF;
        } else {
          crc = (crc << 1) & 0xFFFF;
        }
      }
    }
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  /// Membuat elemen TLV (Tag-Length-Value) 2 digit
  static String formatTlv(String tag, String value) {
    final length = value.length.toString().padLeft(2, '0');
    return '$tag$length$value';
  }

  /// Menghasilkan string payload QRIS Dinamis standar EMVCo
  static String generatePayload({
    required int amount,
    String merchantName = 'BATIK UMKM NGENTRONG',
    String nmid = 'ID1020349812903',
    String city = 'TRENGGALEK',
    String postalCode = '66361',
    String? invoiceId,
  }) {
    final buffer = StringBuffer();

    // 00: Payload Format Indicator (01)
    buffer.write(formatTlv('00', '01'));

    // 01: Point of Initiation Method: '12' = Dynamic (ada nominal), '11' = Static
    buffer.write(formatTlv('01', amount > 0 ? '12' : '11'));

    // 26: Merchant Account Information (QRIS Nasional / ASPI)
    final subGuid = formatTlv('00', 'ID.CO.QRIS.WWW');
    final subNmid = formatTlv('01', nmid);
    final subCriteria = formatTlv('02', 'UMI'); // Usaha Mikro Indonesia
    final tag26Value = '$subGuid$subNmid$subCriteria';
    buffer.write(formatTlv('26', tag26Value));

    // 51: Domestic Central Repository (Bank Indonesia)
    final tag51Value = formatTlv('00', 'ID.CO.QRIS.WWW') + formatTlv('02', '00000000');
    buffer.write(formatTlv('51', tag51Value));

    // 52: Merchant Category Code (5691: Toko Pakaian & Batik)
    buffer.write(formatTlv('52', '5691'));

    // 53: Transaction Currency (360 = Rupiah Indonesia / IDR)
    buffer.write(formatTlv('53', '360'));

    // 54: Transaction Amount (hanya disertakan jika ada nominal)
    if (amount > 0) {
      buffer.write(formatTlv('54', amount.toString()));
    }

    // 58: Country Code (ID)
    buffer.write(formatTlv('58', 'ID'));

    // 59: Merchant Name
    final cleanMerchant = merchantName.length > 25 ? merchantName.substring(0, 25) : merchantName;
    buffer.write(formatTlv('59', cleanMerchant.toUpperCase()));

    // 60: Merchant City
    buffer.write(formatTlv('60', city.toUpperCase()));

    // 61: Postal Code
    buffer.write(formatTlv('61', postalCode));

    // 62: Additional Data Field (Invoice / Reference ID)
    if (invoiceId != null && invoiceId.isNotEmpty) {
      final subRef = formatTlv('01', invoiceId);
      buffer.write(formatTlv('62', subRef));
    }

    // 63: CRC16 Checksum
    final payloadBeforeCrc = '${buffer.toString()}6304';
    final crc = calculateCrc16(payloadBeforeCrc);

    return '$payloadBeforeCrc$crc';
  }
}

