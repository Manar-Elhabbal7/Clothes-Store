import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../logic/product_model.dart';
import '../logic/cart_cubit.dart';
import '../logic/favorites_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedSize;
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'M';
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : 0xff6055D8;
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoritesCubit>().isProductFavorite(widget.product);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsible Image Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : Colors.black87,
                      size: 20,
                    ),
                    onPressed: () {
                      context.read<FavoritesCubit>().toggleFavorite(widget.product);
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-image-${widget.product.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Details content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Size Selection
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: widget.product.sizes.map((sizeOption) {
                      final isSelected = _selectedSize == sizeOption;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = sizeOption;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            sizeOption,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Color Selection
                  const Text(
                    'Select Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: widget.product.colors.map((colorHex) {
                      final isSelected = _selectedColor == colorHex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = colorHex;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(colorHex),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: _isColorLight(colorHex)
                                      ? Colors.black87
                                      : Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.read<CartCubit>().addItem(
                      widget.product,
                      _selectedSize,
                      _selectedColor,
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.product.name} added to the cart Successfully'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 8),
                  Text(
                    'Add to the Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isColorLight(int hex) {
    final color = Color(hex);
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }
}
