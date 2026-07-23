import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/cache_helper.dart';
import 'favorites_state.dart';
import 'product_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  static const String _keyFavorites = 'favorites_list';

  FavoritesCubit() : super(const FavoritesLoaded([])) {
    loadFavorites();
  }

  void loadFavorites() {
    final list = CacheHelper.getStringList(_keyFavorites);
    if (list != null) {
      try {
        final favorites = list.map((item) => Product.fromJson(jsonDecode(item))).toList();
        emit(FavoritesLoaded(favorites));
      } catch (_) {
        emit(const FavoritesLoaded([]));
      }
    }
  }

  void _saveFavorites(List<Product> favorites) {
    final list = favorites.map((item) => jsonEncode(item.toJson())).toList();
    CacheHelper.setStringList(_keyFavorites, list);
  }

  void toggleFavorite(Product product) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final List<Product> updatedFavorites = List.from(currentState.favorites);
      
      final index = updatedFavorites.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        updatedFavorites.removeAt(index);
      } else {
        updatedFavorites.add(product);
      }
      
      emit(FavoritesLoaded(updatedFavorites));
      _saveFavorites(updatedFavorites);
    }
  }

  bool isProductFavorite(Product product) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.favorites.any((p) => p.id == product.id);
    }
    return false;
  }
}
