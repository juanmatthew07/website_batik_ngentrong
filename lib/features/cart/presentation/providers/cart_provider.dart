import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:batik_ngentrong/features/product/data/product_repository.dart';
import 'package:batik_ngentrong/features/product/data/product_repository_provider.dart';
import 'package:batik_ngentrong/features/product/domain/product.dart';
import 'package:batik_ngentrong/features/cart/domain/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier(ProductRepository productRepo) : super(_initialCart(productRepo));

  // _productRepo removed: only needed during construction, passed to _initialCart

  static List<CartItem> _initialCart(ProductRepository repo) {
    // Memberi 2 contoh item dari toko berbeda agar pengelompokan UMKM langsung terlihat
    final all = repo.allProductsSync;
    if (all.length >= 4) {
      final p1 = all[0]; // Toko: barokah
      final p2 = all[3]; // Toko: sekar-jagad
      return [
        CartItem(
          id: '${p1.id}_${p1.colors.first.name}_${p1.sizes[1]}',
          product: p1,
          selectedColor: p1.colors.first.name,
          selectedSize: p1.sizes[1], // M
          quantity: 1,
        ),
        CartItem(
          id: '${p2.id}_${p2.colors.first.name}_${p2.sizes.first}',
          product: p2,
          selectedColor: p2.colors.first.name,
          selectedSize: p2.sizes.first,
          quantity: 1,
        ),
      ];
    }
    return [];
  }

  void addItem({
    required Product product,
    required String color,
    required String size,
    int quantity = 1,
  }) {
    final itemId = '${product.id}_${color}_$size';
    final existingIndex = state.indexWhere((item) => item.id == itemId);

    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      final updated = existing.copyWith(quantity: existing.quantity + quantity);
      final newList = List<CartItem>.from(state);
      newList[existingIndex] = updated;
      state = newList;
    } else {
      final newItem = CartItem(
        id: itemId,
        product: product,
        selectedColor: color,
        selectedSize: size,
        quantity: quantity,
      );
      state = [...state, newItem];
    }
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return CartNotifier(repo);
});

/// Mengelompokkan item belanja berdasarkan Toko UMKM asalnya.
final cartGroupedByStoreProvider = Provider<List<StoreCartGroup>>((ref) {
  final items = ref.watch(cartNotifierProvider);
  final map = <String, List<CartItem>>{};
  final nameMap = <String, String>{};

  for (final item in items) {
    map.putIfAbsent(item.storeId, () => []).add(item);
    nameMap[item.storeId] = item.storeName;
  }

  return map.entries.map((entry) {
    return StoreCartGroup(
      storeId: entry.key,
      storeName: nameMap[entry.key] ?? 'Toko UMKM',
      items: entry.value,
    );
  }).toList();
});

/// Total kuantitas barang dalam keranjang (untuk badge navigasi).
final cartTotalCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartNotifierProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});

/// Total harga seluruh keranjang belanja.
final cartTotalPriceProvider = Provider<int>((ref) {
  final items = ref.watch(cartNotifierProvider);
  return items.fold(0, (sum, item) => sum + item.subtotal);
});

