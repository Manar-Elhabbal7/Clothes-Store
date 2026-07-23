import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/discount_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar.dart';
import 'widgets/product_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../logic/product_cubit.dart';
import '../logic/product_state.dart';
import '../logic/product_model.dart';
import 'all_products_screen.dart';
import 'product_details_screen.dart';
import 'favorites_screen.dart';
import '../../search/ui/search_screen.dart';
import '../../profile/ui/profile_screen.dart';
import '../../shopping_bag/ui/shopping_bag_screen.dart';
import '../logic/cart_cubit.dart';
import '../logic/cart_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Index 0: Home Page
      BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is ProductLoaded) {
            final products = state.products;
            // Filter products into Featured and Popular
            final featuredList = products
                .where((p) =>
                    p.category.toLowerCase().contains('cloth') ||
                    p.category.toLowerCase().contains('shoe') ||
                    p.category.toLowerCase().contains('watch'))
                .toList();
            final featuredToShow = featuredList.isNotEmpty
                ? featuredList
                : products.take(products.length ~/ 2).toList();

            final popularList = products
                .where((p) =>
                    !p.category.toLowerCase().contains('cloth') &&
                    !p.category.toLowerCase().contains('shoe') &&
                    !p.category.toLowerCase().contains('watch'))
                .toList();
            final popularToShow = popularList.isNotEmpty
                ? popularList
                : products.skip(products.length ~/ 2).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 24),
                  CustomSearchBar(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const DiscountBanner(),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 0 ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? AppColors.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Featured', featuredToShow),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredToShow.length,
                      itemBuilder: (context, index) {
                        final product = featuredToShow[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: ProductItem(
                            product: product,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Most Popular', popularToShow),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularToShow.length,
                      itemBuilder: (context, index) {
                        final product = popularToShow[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: ProductItem(
                            product: product,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductCubit>().fetchProducts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      // Index 1: Shopping Bag Screen
      ShoppingBagScreen(
        onBack: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      // Index 2: Favorites Screen
      FavoritesScreen(
        onBack: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      // Index 3: Profile Screen
      ProfileScreen(
        onBack: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          int cartCount = 0;
          if (state is CartUpdated) {
            cartCount = state.totalCount;
          }
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                activeIcon: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, List<Product> products) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllProductsScreen(
                  title: title,
                  products: products,
                ),
              ),
            );
          },
          child: const Text(
            'See All',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
