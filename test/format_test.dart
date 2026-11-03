import 'package:batik_ngentrong/core/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatRupiah memakai titik sebagai pemisah ribuan', () {
    expect(formatRupiah(999), 'Rp 999');
    expect(formatRupiah(129000), 'Rp 129.000');
    expect(formatRupiah(1500000), 'Rp 1.500.000');
  });
}
