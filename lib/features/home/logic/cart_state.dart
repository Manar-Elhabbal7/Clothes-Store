import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final String selectedSize;
  final int selectedColor;

  const CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    int? selectedColor,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  List<Object?> get props => [product, quantity, selectedSize, selectedColor];
}

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;

  const CartUpdated(this.items);

  double get totalPrice => items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [items];
}
