import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final response = await http
          .get(Uri.parse('https://fakestoreapi.com/products'))
          .timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Product> products =
            data.map((json) => Product.fromJson(json)).toList();
        emit(ProductLoaded(products));
      } else {
        emit(const ProductLoaded(dummyProducts));
      }
    } catch (e) {
      emit(const ProductLoaded(dummyProducts));
    }
  }
}
