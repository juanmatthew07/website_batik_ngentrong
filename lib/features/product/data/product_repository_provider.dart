import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_repository.dart';
import '../domain/product.dart';

/// Singleton instance of [ProductRepository] shared across the app.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Fetches a single product by its ID. Returns null if not found.
final productByIdProvider = FutureProvider.family<Product?, String>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductById(id);
});

/// Fetches all products belonging to a specific store.
final productsByStoreProvider =
    FutureProvider.family<List<Product>, String>((ref, storeId) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductsByStore(storeId);
});
