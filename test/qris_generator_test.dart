import 'package:batik_ngentrong/core/utils/qris_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QrisGenerator Unit Tests', () {
    test('calculateCrc16 produces expected 4 character hex', () {
      final crc = QrisGenerator.calculateCrc16('0002010102126304');
      expect(crc.length, 4);
      expect(RegExp(r'^[0-9A-F]{4}$').hasMatch(crc), isTrue);
    });

    test('generatePayload includes all standard tags', () {
      final payload = QrisGenerator.generatePayload(
        amount: 150000,
        merchantName: 'BATIK UMKM NGENTRONG',
        nmid: 'ID1020349812903',
        invoiceId: 'TRX-12345',
      );

      // Pastikan diawali dengan 000201
      expect(payload.startsWith('000201'), isTrue);

      // Berisi data merchant
      expect(payload.contains('BATIK UMKM NGENTRONG'), isTrue);
      expect(payload.contains('ID1020349812903'), isTrue);
      expect(payload.contains('5303360'), isTrue); // IDR currency
      expect(payload.contains('5406150000'), isTrue); // Amount 150000
      expect(payload.contains('TRX-12345'), isTrue); // Reference invoice

      // Berisi CRC di akhir
      expect(payload.contains('6304'), isTrue);
      final lastTagIndex = payload.lastIndexOf('6304');
      final crc = payload.substring(lastTagIndex + 4);
      expect(crc.length, 4);

      // Verifikasi ulang bahwa kalkulasi CRC atas payloadBeforeCrc cocok
      final payloadBeforeCrc = payload.substring(0, lastTagIndex + 4);
      expect(QrisGenerator.calculateCrc16(payloadBeforeCrc), equals(crc));
    });
  });
}

