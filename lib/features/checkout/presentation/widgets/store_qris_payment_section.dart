import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/batik_theme.dart';
import '../../../../core/utils/format.dart';
import '../../../../core/utils/qris_generator.dart';

/// Komponen UI Pembayaran QRIS Asli (Quick Response Code Indonesian Standard).
/// Menggunakan standar format EMVCo Bank Indonesia dan generator QR asli (scannable).
class StoreQrisPaymentSection extends StatefulWidget {
  final int totalAmount;
  final VoidCallback onPaymentSuccess;

  const StoreQrisPaymentSection({
    super.key,
    required this.totalAmount,
    required this.onPaymentSuccess,
  });

  @override
  State<StoreQrisPaymentSection> createState() =>
      _StoreQrisPaymentSectionState();
}

class _StoreQrisPaymentSectionState extends State<StoreQrisPaymentSection> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isVerifying = false;

  late String _invoiceId;
  late String _qrisPayload;

  @override
  void initState() {
    super.initState();
    _initInvoiceAndPayload();
    // Countdown 15 menit
    _remainingSeconds = 15 * 60;
    _startTimer();
  }

  void _initInvoiceAndPayload() {
    _invoiceId =
        'QRIS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    _qrisPayload = QrisGenerator.generatePayload(
      amount: widget.totalAmount,
      merchantName: 'BATIK UMKM NGENTRONG',
      nmid: 'ID1020349812903',
      invoiceId: _invoiceId,
    );
  }

  @override
  void didUpdateWidget(covariant StoreQrisPaymentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalAmount != widget.totalAmount) {
      setState(() {
        _initInvoiceAndPayload();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleConfirmPayment() async {
    setState(() {
      _isVerifying = true;
    });

    // Simulasi verifikasi gateway payment selama 1.2 detik
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    // Tampilkan modal dialog sukses pembayaran
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pembayaran QRIS Berhasil!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: BatikColors.sogaGelap,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Dana sebesar ${formatRupiah(widget.totalAmount)} telah terverifikasi. Pesanan Anda segera diproses & dikirim oleh pengrajin Desa Ngentrong.',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade700, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: BatikColors.kertas,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BatikColors.garis),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ID Transaksi:',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  Text(
                    _invoiceId,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: BatikColors.marun,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                widget.onPaymentSuccess();
              },
              child: const Text('Selesai & Kembali ke Beranda'),
            ),
          ),
        ],
      ),
    );
  }

  void _showPayloadDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.qr_code_2, color: BatikColors.marun),
            SizedBox(width: 8),
            Text('Data Standar QRIS EMVCo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPayloadRow('Merchant', 'BATIK UMKM NGENTRONG'),
              _buildPayloadRow('NMID', 'ID1020349812903'),
              _buildPayloadRow('Kota', 'Trenggalek (Kodepos 66361)'),
              _buildPayloadRow('Kriteria', 'Usaha Mikro Indonesia (UMI)'),
              _buildPayloadRow('Mata Uang', 'IDR / Rupiah (360)'),
              _buildPayloadRow('Nominal', formatRupiah(widget.totalAmount)),
              _buildPayloadRow('Ref Invoice', _invoiceId),
              const SizedBox(height: 12),
              const Text(
                'String Payload QRIS (Scannable):',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: BatikColors.sogaGelap),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  _qrisPayload,
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 10.5, height: 1.3),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _qrisPayload));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('String payload QRIS EMVCo disalin ke clipboard!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Salin Payload QRIS'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: BatikColors.sogaGelap),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BatikColors.garis),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Merah QRIS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: BatikColors.marun,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_2, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Pembayaran QRIS Nasional',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        _formattedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Kartu Standar QRIS Indonesia
                Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Logo QRIS & GPN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQrisBrandBadge(),
                          _buildGpnBadge(),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Nama Merchant & NMID
                      const Text(
                        'BATIK UMKM NGENTRONG',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 0.5,
                          color: BatikColors.sogaGelap,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'NMID: ID1020349812903',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // QR Code Asli (Scannable dengan QrImageView)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: QrImageView(
                          data: _qrisPayload,
                          version: QrVersions.auto,
                          size: 200,
                          gapless: true,
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Indikator Scannable
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFC8E6C9)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                size: 12, color: Colors.green),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'QR Asli • Scannable',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        'Dicetak oleh: Bank Indonesia / ASPI QRIS',
                        style: TextStyle(fontSize: 9.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Tombol Lihat Detail Data EMVCo QRIS
                TextButton.icon(
                  onPressed: _showPayloadDialog,
                  icon:
                      const Icon(Icons.code, size: 15, color: BatikColors.soga),
                  label: const Text(
                    'Lihat Data Payload EMVCo QRIS',
                    style: TextStyle(
                        fontSize: 12,
                        color: BatikColors.soga,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 8),

                // Jumlah Tagihan yang Harus Dibayar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: BatikColors.kertas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: BatikColors.garis),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pembayaran QRIS',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatRupiah(widget.totalAmount),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: BatikColors.marun,
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          side: const BorderSide(color: BatikColors.marun),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: widget.totalAmount.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Nominal ${formatRupiah(widget.totalAmount)} disalin!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 14),
                        label:
                            const Text('Salin', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Aksi Verifikasi Pembayaran
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isVerifying ? null : _handleConfirmPayment,
                    icon: _isVerifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_circle_outline, size: 20),
                    label: Text(
                      _isVerifying
                          ? 'Memverifikasi Pembayaran...'
                          : 'Saya Sudah Membayar (Simulasi)',
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Panduan / Petunjuk Pembayaran
                Material(
                  color: Colors.transparent,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Row(
                        children: [
                          Icon(Icons.help_outline,
                              size: 18, color: BatikColors.soga),
                          SizedBox(width: 8),
                          Text(
                            'Cara Bayar dengan QRIS',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: BatikColors.sogaGelap,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStepItem('1',
                                  'Buka aplikasi e-Wallet (GoPay, OVO, Dana, ShopeePay) atau m-Banking (BCA, BRI, Mandiri, BNI).'),
                              _buildStepItem(
                                  '2', 'Pilih menu "Bayar" atau "Scan QR".'),
                              _buildStepItem(
                                  '3', 'Arahkan kamera ke kode QRIS di atas.'),
                              _buildStepItem('4',
                                  'Pastikan nama penerima adalah "BATIK UMKM NGENTRONG" dan nominal tepat ${formatRupiah(widget.totalAmount)}.'),
                              _buildStepItem('5',
                                  'Masukkan PIN Anda dan tekan tombol "Saya Sudah Membayar" untuk menyelesaikan.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: BatikColors.krem,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: BatikColors.soga),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12.5, color: Colors.grey.shade700, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrisBrandBadge() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFC62828),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'QRIS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'Nasional',
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildGpnBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        'GPN',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
