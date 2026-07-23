import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/cache_helper.dart';
import 'cart_state.dart';
import 'product_model.dart';

class CartCubit extends Cubit<CartState> {
  static const String _keyCartItems = 'cart_items_list';

  CartCubit() : super(const CartUpdated([])) {
    loadCart();
  }

  void loadCart() {
    final list = CacheHelper.getStringList(_keyCartItems);
    if (list != null) {
      try {
        final items = list.map((item) => CartItem.fromJson(jsonDecode(item))).toList();
        emit(CartUpdated(items));
      } catch (_) {
        emit(const CartUpdated([]));
      }
    }
  }

  void _saveCart(List<CartItem> items) {
    final list = items.map((item) => jsonEncode(item.toJson())).toList();
    CacheHelper.setStringList(_keyCartItems, list);
  }

  void addItem(Product product, String size, int color) {
    final currentState = state;
    if (currentState is CartUpdated) {
      final List<CartItem> updatedItems = List.from(currentState.items);
      
      // Check if product with same size and color is already in cart
      final existingIndex = updatedItems.indexWhere(
        (item) => item.product.id == product.id && 
                  item.selectedSize == size && 
                  item.selectedColor == color
      );

      if (existingIndex != -1) {
        // Increment quantity of existing item
        final existingItem = updatedItems[existingIndex];
        updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
      } else {
        // Add new item
        updatedItems.add(CartItem(
          product: product,
          selectedSize: size,
          selectedColor: color,
        ));
      }

      emit(CartUpdated(updatedItems));
      _saveCart(updatedItems);
    }
  }

  void removeItem(CartItem item) {
    final currentState = state;
    if (currentState is CartUpdated) {
      final List<CartItem> updatedItems = List.from(currentState.items);
      updatedItems.removeWhere(
        (i) => i.product.id == item.product.id && 
               i.selectedSize == item.selectedSize && 
               i.selectedColor == item.selectedColor
      );
      emit(CartUpdated(updatedItems));
      _saveCart(updatedItems);
    }
  }

  void incrementItem(CartItem item) {
    final currentState = state;
    if (currentState is CartUpdated) {
      final List<CartItem> updatedItems = List.from(currentState.items);
      final index = updatedItems.indexOf(item);
      if (index != -1) {
        updatedItems[index] = item.copyWith(quantity: item.quantity + 1);
        emit(CartUpdated(updatedItems));
        _saveCart(updatedItems);
      }
    }
  }

  void decrementItem(CartItem item) {
    final currentState = state;
    if (currentState is CartUpdated) {
      if (item.quantity <= 1) {
        removeItem(item);
      } else {
        final List<CartItem> updatedItems = List.from(currentState.items);
        final index = updatedItems.indexOf(item);
        if (index != -1) {
          updatedItems[index] = item.copyWith(quantity: item.quantity - 1);
          emit(CartUpdated(updatedItems));
          _saveCart(updatedItems);
        }
      }
    }
  }

  void clearCart() {
    emit(const CartUpdated([]));
    _saveCart([]);
  }
}
