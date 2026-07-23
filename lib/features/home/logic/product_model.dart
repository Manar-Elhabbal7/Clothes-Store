import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;
  final String category;
  final List<String> sizes;
  final List<int> colors;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const [0xff6055D8, 0xff1A1A1A, 0xffA0A0A0, 0xffE0E0E0],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : const ['S', 'M', 'L', 'XL'],
      colors: json['colors'] != null ? List<int>.from(json['colors']) : const [0xff6055D8, 0xff1A1A1A, 0xffA0A0A0, 0xffE0E0E0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'category': category,
      'sizes': sizes,
      'colors': colors,
    };
  }

  @override
  List<Object?> get props => [id, name, image, price, description, category, sizes, colors];
}

const List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Classic Leather Watch',
    price: 40.0,
    category: 'Watch',
    image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
    description: 'This minimalist leather watch is perfect for everyday elegance. Featuring a high-quality genuine leather strap and a durable stainless steel case, it brings comfort and timeless style to any outfit.',
  ),
  Product(
    id: '2',
    name: 'Nike Air Max Shoes',
    price: 430.0,
    category: 'Shoes',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    description: 'Elevate your performance and comfort with these premium athletic shoes. Boasting responsive air cushioning, a breathable mesh upper, and a stylish sporty design suitable for running or casual wear.',
  ),
  Product(
    id: '3',
    name: 'Wireless Airpods Pro',
    price: 333.0,
    category: 'Electronics',
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
    description: 'Immerse yourself in crystal-clear sound with active noise cancellation. These wireless earbuds deliver seamless connectivity, deep bass, and comfortable silicone tips for all-day listening.',
  ),
  Product(
    id: '4',
    name: 'LG Smart OLED TV',
    price: 330.0,
    category: 'Electronics',
    image: 'https://images.unsplash.com/photo-1593305841991-05c297ba4575',
    description: 'Experience stunning realism with self-lit pixels and brilliant colors. This smart OLED TV features high dynamic range, AI picture processing, and built-in streaming apps for ultimate entertainment.',
  ),
  Product(
    id: '5',
    name: 'Casual Street Hoodie',
    price: 50.0,
    category: 'Clothes',
    image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7',
    description: 'Stay cozy and stylish in this soft, fleece-lined casual hoodie. Crafted with a premium cotton blend, it features an adjustable drawstring hood, a kangaroo pocket, and a modern relaxed fit.',
  ),
  Product(
    id: '6',
    name: 'Leather Bomber Jacket',
    price: 400.0,
    category: 'Clothes',
    image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5',
    description: 'Add an edge to your look with this classic leather bomber jacket. Features robust zippers, side pockets, ribbed cuffs, and soft inner lining for wind protection and sleek aesthetics.',
  ),
  Product(
    id: '7',
    name: 'Premium Wool Sweater',
    price: 85.0,
    category: 'Clothes',
    image: 'https://images.unsplash.com/photo-1574169208507-84376144848b',
    description: 'Knitted from organic merino wool, this knit sweater offers natural warmth and a premium hand-feel. Perfect for layering in colder months.',
  ),
  Product(
    id: '8',
    name: 'Denim Slim Fit Jacket',
    price: 120.0,
    category: 'Clothes',
    image: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0',
    description: 'A timeless classic denim jacket that never goes out of style. Features durable cotton denim, button closures, and classic chest pockets for a relaxed, layered look.',
  ),
];
