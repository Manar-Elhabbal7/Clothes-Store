import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/discount_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar.dart';
import 'widgets/product_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../logic/product_cubit.dart';
import '../logic/product_state.dart';
import '../../search/ui/search_screen.dart';
import '../../shopping_bag/ui/shopping_bag_screen.dart';
import '../../profile/ui/profile_screen.dart';

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
                  const CustomSearchBar(),
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
                  _buildSectionTitle('Featured'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredToShow.length,
                      itemBuilder: (context, index) {
                        final product = featuredToShow[index];
                        return ProductItem(
                          image: product.image,
                          name: product.name,
                          price: '\$${product.price.toStringAsFixed(0)}',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Most Popular'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularToShow.length,
                      itemBuilder: (context, index) {
                        final product = popularToShow[index];
                        return ProductItem(
                          image: product.image,
                          name: product.name,
                          price: '\$${product.price.toStringAsFixed(0)}',
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
      // Index 1: Search Screen
      const SearchScreen(),
      // Index 2: Shopping Bag Screen
      const ShoppingBagScreen(),
      // Index 3: Profile Screen
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
