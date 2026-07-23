import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_state.dart';
import 'product_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesLoaded([]));

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
