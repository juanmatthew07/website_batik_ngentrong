import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/widgets/google_auth_dialog.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../theme/batik_theme.dart';
import 'page_width.dart';

/// Header navigasi utama marketplace Batik Desa Ngentrong.
/// Bersih, tanpa logo Uniqlo, tanpa menu kategori Pria/Wanita, dan responsif di layar mobile maupun web desktop.
class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.onSearchChanged,
    this.searchController,
    this.showSearch = true,
  });

  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final bool showSearch;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartTotalCountProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: BatikColors.garis, width: 1)),
      ),
      child: PageWidth(
        child: SizedBox(
          height: 70,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;

              return Row(
                children: [
                  // Judul Elegan Teks Biasa (Menggantikan Logo Kotak Merah Uniqlo)
                  InkWell(
                    onTap: () => context.go('/'),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isWide ? 'Batik Desa Ngentrong' : 'Batik Ngentrong',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: BatikColors.sogaGelap,
                                  letterSpacing: 0.2,
                                  fontSize: isWide ? 20 : 17,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isWide) const SizedBox(width: 24) else const SizedBox(width: 8),

                  // Kolom Pencarian (jika aktif)
                  if (showSearch)
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: SizedBox(
                          height: 38,
                          child: TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            decoration: InputDecoration(
                              hintText: isWide ? 'Cari batik, motif cengkeh, atau UMKM...' : 'Cari batik...',
                              hintStyle: const TextStyle(fontSize: 12.5, color: Colors.black45),
                              prefixIcon: const Icon(Icons.search, size: 18, color: BatikColors.soga),
                              filled: true,
                              fillColor: BatikColors.kertas,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: BatikColors.garis),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: BatikColors.garis),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: BatikColors.marun, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  const SizedBox(width: 8),

                  // Ikon Keranjang dengan Badge Kuantitas
                  IconButton(
                    onPressed: () => context.go('/keranjang'),
                    tooltip: 'Keranjang Belanja',
                    icon: Badge(
                      isLabelVisible: cartCount > 0,
                      label: Text(
                        '$cartCount',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: BatikColors.marun,
                      child: const Icon(Icons.shopping_bag_outlined, color: BatikColors.sogaGelap, size: 24),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Profil / Login Google
                  _buildGoogleAuthButton(context, ref, isWide),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleAuthButton(BuildContext context, WidgetRef ref, bool isWide) {
    final authState = ref.watch(authNotifierProvider);

    if (authState.isAuthenticated && authState.currentUser != null) {
      final user = authState.currentUser!;
      return PopupMenuButton<String>(
        tooltip: 'Akun Google',
        offset: const Offset(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: BatikColors.kertas,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BatikColors.garis),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: BatikColors.marun,
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : 'U',
                  style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (isWide) ...[
                const SizedBox(width: 6),
                Text(
                  user.name.split(' ').first,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: BatikColors.sogaGelap),
                ),
              ],
            ],
          ),
        ),
        onSelected: (val) {
          if (val == 'logout') {
            ref.read(authNotifierProvider.notifier).signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Anda telah keluar dari akun Google.')),
            );
          } else if (val == 'switch') {
            showGoogleAuthDialog(context);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: BatikColors.sogaGelap),
                ),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'switch',
            child: Row(
              children: [
                Icon(Icons.switch_account_outlined, size: 18),
                SizedBox(width: 8),
                Text('Ganti Akun Google', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Keluar Akun', style: TextStyle(fontSize: 13, color: Colors.red)),
              ],
            ),
          ),
        ],
      );
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
      ),
      onPressed: () => showGoogleAuthDialog(context),
      icon: const GoogleLogo(size: 18),
      label: Text(
        isWide ? 'Masuk Google' : 'Masuk',
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: BatikColors.sogaGelap),
      ),
    );
  }
}

