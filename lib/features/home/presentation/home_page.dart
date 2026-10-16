import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/batik_theme.dart';
import '../../../core/widgets/chatbot_fab.dart';
import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/page_width.dart';
import '../../../core/widgets/site_footer.dart';
import '../../product/data/product_repository_provider.dart';
import '../../product/domain/product.dart';
import '../../product/presentation/widgets/product_card.dart';
import 'widgets/hero_banner.dart';
import 'widgets/store_avatar_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Product> _items = [];
  int _page = 0;
  int _total = 0;
  bool _isLoading = true;
  bool _hasMore = true;
  String? _error;
  String _searchQuery = '';
  Timer? _debounce;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _error != null) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 600) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (!reset && (_isLoading || !_hasMore)) return;

    final reqId = ++_requestId;
    final pageToLoad = reset ? 0 : _page;

    setState(() {
      if (reset) {
        _items = [];
        _hasMore = true;
        _total = 0;
      }
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(productRepositoryProvider);
      final result = await repo.fetchPage(
        page: pageToLoad,
        pageSize: 8,
        query: _searchQuery,
      );

      if (!mounted || reqId != _requestId) return;

      setState(() {
        _items = reset ? result.items : [..._items, ...result.items];
        _page = pageToLoad + 1;
        _hasMore = result.hasMore;
        _total = result.total;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || reqId != _requestId) return;
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat produk. Coba lagi.';
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _searchQuery = value;
      _load(reset: true);
    });
  }

  void _scrollToCollection() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      450,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: MainAppBar(
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
      ),
      floatingActionButton: const ChatbotFab(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Hero Banner
          SliverToBoxAdapter(
            child: HeroBanner(onExploreTap: _scrollToCollection),
          ),

          // 2. Section Toko UMKM (Bulatan / Circular Avatar List - Centered Island)
          const SliverToBoxAdapter(
            child: PageWidth(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: StoreAvatarList(),
            ),
          ),

          // 3. Section "Semua Batik"
          SliverToBoxAdapter(
            child: PageWidth(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semua Batik Desa Ngentrong',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Koleksi lengkap dari seluruh pengrajin dan sanggar batik Ngentrong',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: BatikColors.sogaGelap.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_total > 0)
                    Text(
                      'Menampilkan $_total produk',
                      style: const TextStyle(fontSize: 13, color: BatikColors.sogaMuda, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
          ),

          // 4. Grid Kartu Produk (Lazy Loading dengan SliverGrid)
          _buildProductGrid(),

          // 5. Indikator Status (Loading / End of list)
          _buildStatus(theme),

          // 6. Footer
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final side = sidePaddingFor(width);
        final inner = width - side * 2;
        // Hitung kolom secara responsif (2 sampai 4 kolom)
        final columns = (inner / 250).floor().clamp(2, 4).toInt();
        const gap = 20.0;
        final itemWidth = (inner - (columns - 1) * gap) / columns;
        // Tinggi kartu produk proporsional: gambar (1.05:1) + informasi teks
        final itemHeight = itemWidth * 1.05 + 175;

        if (_items.isEmpty && !_isLoading && _error == null) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Tidak ada batik yang cocok dengan pencarian Anda.',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final showSkeleton = _items.isEmpty && _isLoading;

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: side),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              mainAxisExtent: itemHeight,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (showSkeleton) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: BatikColors.garis),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.05,
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.04),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 120,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final product = _items[index];
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                );
              },
              childCount: showSkeleton ? columns * 2 : _items.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatus(ThemeData theme) {
    Widget content;
    if (_error != null) {
      content = Column(
        children: [
          Text(_error!, style: const TextStyle(color: BatikColors.marun)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _load(reset: _items.isEmpty),
            child: const Text('Coba Lagi'),
          ),
        ],
      );
    } else if (_isLoading && _items.isNotEmpty) {
      content = const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 3, color: BatikColors.marun),
      );
    } else if (!_hasMore && _items.isNotEmpty) {
      content = Text(
        'Semua koleksi batik telah ditampilkan',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      );
    } else {
      content = const SizedBox.shrink();
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Center(child: content),
      ),
    );
  }
}

