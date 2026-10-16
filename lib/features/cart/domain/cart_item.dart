import '../../product/domain/product.dart';

/// Item di dalam keranjang belanja.
class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
  });

  final String id;
  final Product product;
  final String selectedColor;
  final String selectedSize;
  final int quantity;

  String get storeId => product.storeId;
  String get storeName => product.storeName;
  int get subtotal => product.price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    String? selectedColor,
    String? selectedSize,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Kelompok item keranjang berdasarkan Toko UMKM asalnya.
class StoreCartGroup {
  const StoreCartGroup({
    required this.storeId,
    required this.storeName,
    required this.items,
  });

  final String storeId;
  final String storeName;
  final List<CartItem> items;

  int get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}

