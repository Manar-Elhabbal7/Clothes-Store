import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/app_endpoints.dart';
import 'product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final response = await DioHelper.getData(url: AppEndpoints.products);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
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
