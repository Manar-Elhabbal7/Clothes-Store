import 'package:equatable/equatable.dart';
import 'product_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Product> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
