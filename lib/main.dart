import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/home/logic/cart_cubit.dart';
import 'features/home/logic/product_cubit.dart';
import 'features/auth/ui/login_screen.dart';

void main() {
  runApp(const ClothesStore());
}

class ClothesStore extends StatelessWidget {
  const ClothesStore({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => ProductCubit()..fetchProducts()),
      ],
      child: MaterialApp(
        title: 'Clothes Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
