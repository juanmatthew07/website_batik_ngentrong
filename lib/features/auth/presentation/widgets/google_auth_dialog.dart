import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/batik_theme.dart';
import '../../domain/user_profile.dart';
import '../providers/auth_provider.dart';

/// Menampilkan Dialog Mockup Google Authentication.
/// Mengembalikan `true` jika proses login berhasil.
Future<bool?> showGoogleAuthDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const GoogleAuthDialog(),
  );
}

class GoogleAuthDialog extends ConsumerStatefulWidget {
  const GoogleAuthDialog({super.key});

  @override
  ConsumerState<GoogleAuthDialog> createState() => _GoogleAuthDialogState();
}

class _GoogleAuthDialogState extends ConsumerState<GoogleAuthDialog> {
  UserProfile? _selectedUser;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedUser = AuthNotifier.availableMockUsers.first;
  }

  Future<void> _handleSignIn(UserProfile user) async {
    setState(() {
      _selectedUser = user;
      _isSubmitting = true;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle(user);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Google
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const GoogleLogo(size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login dengan Google',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: BatikColors.sogaGelap,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pilih akun untuk melanjutkan ke pembayaran',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, color: BatikColors.garis),
              const SizedBox(height: 16),

              // Daftar Akun Mock Google
              const Text(
                'Pilih Akun Tersedia:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: BatikColors.soga,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),

              for (final user in AuthNotifier.availableMockUsers) ...[
                _buildAccountTile(user),
                const SizedBox(height: 8),
              ],

              const SizedBox(height: 8),

              // Opsi Tambah Akun Lain
              InkWell(
                onTap: _isSubmitting
                    ? null
                    : () {
                        // Simulasi custom account
                        final customUser = UserProfile(
                          id: 'usr_google_new',
                          name: 'Pengguna Google Baru',
                          email: 'batik.pembeli@gmail.com',
                          phoneNumber: '0813-0000-8888',
                          defaultAddress:
                              'Jl. Karangan Indah No. 10, Trenggalek, Jawa Timur',
                        );
                        _handleSignIn(customUser);
                      },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_outlined,
                          size: 20,
                          color: BatikColors.sogaGelap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Gunakan akun Google lainnya',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: BatikColors.sogaGelap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Banner Informasi Mock Auth
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BatikColors.kertas,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: BatikColors.garis),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: BatikColors.marun,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Simulasi Google Auth (Tanpa API Backend). Data akun digunakan untuk identitas pemesan & konfirmasi QRIS.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade700,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Indikator Loading atau Tombol Aksi
              if (_isSubmitting)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: BatikColors.marun,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Menghubungkan akun Google...',
                          style: TextStyle(
                            fontSize: 13,
                            color: BatikColors.sogaGelap,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: BatikColors.marun,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _selectedUser != null
                          ? () => _handleSignIn(_selectedUser!)
                          : null,
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Lanjut Pembayaran'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTile(UserProfile user) {
    final isSelected = _selectedUser?.id == user.id;

    return InkWell(
      onTap: _isSubmitting
          ? null
          : () {
              setState(() {
                _selectedUser = user;
              });
            },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? BatikColors.marun : BatikColors.garis,
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected ? BatikColors.krem.withValues(alpha: 0.5) : Colors.white,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: isSelected ? BatikColors.marun : BatikColors.soga,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: BatikColors.sogaGelap,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: BatikColors.marun,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Logo Google 4-Warna Resmi (Rendering Visual Mandiri tanpa asset eksternal)
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'G',
        style: TextStyle(
          fontSize: size * 0.72,
          fontWeight: FontWeight.w900,
          fontFamily: 'Roboto',
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [
                Color(0xFF4285F4), // Blue
                Color(0xFFEA4335), // Red
                Color(0xFFFBBC05), // Yellow
                Color(0xFF34A853), // Green
              ],
              stops: [0.25, 0.5, 0.75, 1.0],
            ).createShader(Rect.fromLTWH(0, 0, size, size)),
        ),
      ),
    );
  }
}

