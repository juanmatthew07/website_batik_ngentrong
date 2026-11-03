import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/batik_theme.dart';
import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/page_width.dart';
import '../../product/data/product_repository.dart'; // StoreInfo
import '../../product/data/product_repository_provider.dart';
import '../domain/mockup_template.dart';
import 'widgets/mockup_canvas.dart';
import 'widgets/pattern_drop_zone.dart';
import 'widgets/pattern_source_tile.dart';

class MockupPage extends ConsumerStatefulWidget {
  const MockupPage({super.key});

  @override
  ConsumerState<MockupPage> createState() => _MockupPageState();
}

class _MockupPageState extends ConsumerState<MockupPage> {
  MockupTemplate _selectedTemplate = MockupTemplate.all.first;
  Uint8List? _activePatternBytes;
  String? _activePatternLabel;

  final Map<String, Uint8List> _loadedPatterns = {};
  bool _loadingPatterns = true;

  final GlobalKey _canvasKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _preloadPatterns());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _preloadPatterns() async {
    final repo = ref.read(productRepositoryProvider);
    for (final store in repo.stores) {
      try {
        final data = await rootBundle.load(store.imageAsset);
        _loadedPatterns[store.imageAsset] = data.buffer.asUint8List();
      } catch (e) {
        debugPrint('Gagal memuat ${store.imageAsset}: $e');
      }
    }
    if (mounted) setState(() => _loadingPatterns = false);
  }

  /// Cari nama toko dari bytes motif (instance yang sama dengan yang di-drag).
  String _labelFor(Uint8List bytes) {
    final repo = ref.read(productRepositoryProvider);
    for (final store in repo.stores) {
      if (identical(_loadedPatterns[store.imageAsset], bytes)) {
        return store.name;
      }
    }
    return 'Custom';
  }

  void _applyPattern(Uint8List bytes, {String? label}) {
    setState(() {
      _activePatternBytes = bytes;
      _activePatternLabel = label ?? _labelFor(bytes);
    });
  }

  void _reset() {
    setState(() {
      _activePatternBytes = null;
      _activePatternLabel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(productRepositoryProvider);

    return Scaffold(
      appBar: MainAppBar(
        searchController: _searchController,
        onSearchChanged: (_) {},
        showSearch: false,
      ),
      body: SingleChildScrollView(
        child: PageWidth(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Studio Mockup Batik',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pilih pakaian, lalu ketuk atau seret motif batik untuk melihat hasilnya secara langsung.',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final canvasSection = _buildCanvasSection();
                  final controlsSection = _buildControlsSection(repo.stores);

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: canvasSection),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: controlsSection),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      canvasSection,
                      const SizedBox(height: 24),
                      controlsSection,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bagian kiri: pemilih template + kanvas
  // ---------------------------------------------------------------------------

  Widget _buildCanvasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pemilih template: Wrap supaya semua pilihan selalu terlihat
        // (tanpa scroll horizontal yang tidak bisa di-drag di web/desktop).
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MockupTemplate.all.map((t) {
            final selected = t.id == _selectedTemplate.id;
            return ChoiceChip(
              label: Text(t.name),
              avatar: Icon(t.icon, size: 18),
              selected: selected,
              onSelected: (_) => setState(() => _selectedTemplate = t),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Kanvas + drop zone
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 520),
          child: PatternDropZone(
            onPatternDropped: (bytes) => _applyPattern(bytes),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: MockupCanvas(
                  key: ValueKey(_selectedTemplate.id),
                  template: _selectedTemplate,
                  patternBytes: _activePatternBytes,
                  canvasKey: _canvasKey,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        _buildStatusBar(),
      ],
    );
  }

  Widget _buildStatusBar() {
    final hasPattern = _activePatternBytes != null;
    return Row(
      children: [
        if (hasPattern) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.memory(
              _activePatternBytes!,
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            hasPattern
                ? 'Motif aktif: ${_activePatternLabel ?? "Custom"}'
                : 'Belum ada motif. Ketuk atau seret motif dari daftar motif.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        if (hasPattern)
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset'),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Bagian kanan: daftar motif
  // ---------------------------------------------------------------------------

  Widget _buildControlsSection(List<StoreInfo> stores) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatikColors.krem.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatikColors.garis),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Motif Batik Tersedia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ketuk motif untuk menerapkan, atau seret ke area mockup.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          _buildPatternList(stores),
          const SizedBox(height: 16),
          _buildTipsBox(),
        ],
      ),
    );
  }

  Widget _buildPatternList(List<StoreInfo> stores) {
    if (_loadingPatterns) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loadedPatterns.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(Icons.image_not_supported_outlined,
                size: 32, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            Text(
              'Gambar motif tidak ditemukan.\nPeriksa folder assets/images/.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                setState(() => _loadingPatterns = true);
                _preloadPatterns();
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: stores.map((store) {
        final bytes = _loadedPatterns[store.imageAsset];
        if (bytes == null) return const SizedBox.shrink();

        final isActive = identical(bytes, _activePatternBytes);
        return MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isActive ? Colors.teal : Colors.transparent,
                width: 2,
              ),
            ),
            child: PatternSourceTile(
              label: store.name,
              assetPath: store.imageAsset,
              bytes: bytes,
              onTap: () => _applyPattern(bytes, label: store.name),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipsBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tips: ketuk motif untuk menerapkan, atau seret langsung ke pakaian. '
              'Motif tetap dipakai saat Anda berganti jenis pakaian.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}