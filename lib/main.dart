import 'package:clothes_store/features/splash/splash_screen.dart';
import 'package:clothes_store/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/home/logic/cart_cubit.dart';
import 'features/home/logic/favorites_cubit.dart';
import 'features/home/logic/product_cubit.dart';
import 'features/auth/ui/login_screen.dart';
import 'core/network/dio_helper.dart';
import 'features/home/ui/home_screen.dart';
import 'core/cache/cache_helper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DioHelper.init();
  await CacheHelper.init();
  
  final currentUser = FirebaseAuth.instance.currentUser;
  final bool isLoggedIn = currentUser != null;
  
  if (isLoggedIn) {
    final name = currentUser.displayName ?? currentUser.email?.split('@').first ?? 'User';
    await CacheHelper.saveUser(name: name);
  } else {
    await CacheHelper.clearUser();
  }
  
  runApp(ClothesStore(isLoggedIn: isLoggedIn));
}

class ClothesStore extends StatelessWidget {
  final bool isLoggedIn;
  const ClothesStore({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => FavoritesCubit()),
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
        home: isLoggedIn ? const HomeScreen() : const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
