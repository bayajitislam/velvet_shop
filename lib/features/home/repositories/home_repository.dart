import 'package:flutter/material.dart';
import 'package:velvet/features/home/models/bennar_model.dart';
import 'package:velvet/features/home/models/product_model.dart';

class HomeRepository {
  // ── Banners ────────────────────────────────────────────
  Future<List<BannerModel>> fetchBanners() async {
    // Replace with real API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const BannerModel(
        title: 'Discover Your Raw\nSignature Look',
        subtitle: 'Explore the latest fashion\ntrends curated just for you.',
        imageUrl:
            'https://i.pinimg.com/736x/e4/d8/b1/e4d8b149c25abcef1c4d43b2a94ebbb8.jpg',
        bgColor: Color(0xFFD81B60),
      ),
      const BannerModel(
        title: 'New Summer\nCollection 2025',
        subtitle: 'Fresh styles for the\nwarm season ahead.',
        imageUrl:
            'https://img.magnific.com/free-photo/attractive-smiling-asian-woman-holding-shopping-bags-wearing-sunglasses-cute-dress-standing-agai_1258-153611.jpg?w=360',
        bgColor: Color(0xFFC2185B),
      ),
      const BannerModel(
        title: 'Up to 50% Off\nSelected Items',
        subtitle: 'Limited time offer on\npremium collections.',
        imageUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/028/714/263/small/fashion-week-model-isolated-on-pastel-background-with-a-place-for-text-photo.jpg',
        bgColor: Color(0xFFAD1457),
      ),
    ];
  }

  // ── Categories ─────────────────────────────────────────
  Future<List<String>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Discover', 'Women', 'Men', 'Shoes', 'Watch', 'Bags'];
  }

  // ── Products ───────────────────────────────────────────
  Future<List<ProductModel>> fetchProducts({
    String category = 'Discover',
  }) async {
    // Replace with real API call filtered by category
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      ProductModel(
        id: '1',
        name: 'Boho-Chic Fedora',
        subtitle:
            'Unveiling effortless indie style',
        price: 199.00,
        originalPrice: 249.00,
        imageUrl:
            'https://img.magnific.com/free-photo/studio-close-up-portrait-young-fresh-blonde-woman-brown-straw-poncho-wool-black-trendy-hat-round-glasses-looking-camera-green-leather-had-bag_273443-1121.jpg?semt=ais_hybrid&w=740&q=80',
        images: [
          'https://img.magnific.com/free-photo/studio-close-up-portrait-young-fresh-blonde-woman-brown-straw-poncho-wool-black-trendy-hat-round-glasses-looking-camera-green-leather-had-bag_273443-1121.jpg?semt=ais_hybrid&w=740&q=80',
          'https://img.magnific.com/free-photo/outdoor-hight-fashion-portrait-stylish-casual-woman-black-hat-pink-suit-white-blouse-posing-old-street_273443-1186.jpg?t=st=1779596969~exp=1779600569~hmac=4754d87d627983a3f31d7ba026f2b131d520d6f7d4baf6705556519c60486ca4&w=740',
          'https://img.magnific.com/free-photo/fashionable-woman-pink-coat-black-hat-posing_273443-2429.jpg',
        ],
        rating: 4.8,
        reviewCount: 340,
        description:
            'A perfectly tailored blend of formal and casual wear. Crafted from premium breathable fabric designed for the modern professional who never compromises on style.',
      ),
      ProductModel(
        id: '2',
        name: 'Elegant Pink Midi',
        subtitle: 'Luxury fashion wear',
        price: 199.00,
        originalPrice: 219.00,
        imageUrl:
            'https://images.unsplash.com/photo-1596783074918-c84cb06531ca',
        images: [
          'https://images.unsplash.com/photo-1596783074918-c84cb06531ca',
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
          'https://images.unsplash.com/photo-1529139574466-a303027c1d8b',
        ],
        rating: 4.9,
        reviewCount: 780,
        description:
            'Crafted from soft, breathable fabric, perfect for both casual outings and special occasions. Feel confident, stylish, and comfortable all day long.',
        isFavorite: true,
      ),
      ProductModel(
        id: '3',
        name: 'Street Chic',
        subtitle: 'Urban style essentials',
        price: 149.00,
        imageUrl:
            'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600',
        images: [
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800',
        ],
        rating: 4.6,
        reviewCount: 215,
        description:
            'Bold, expressive urban fashion that turns heads. Built for those who want to make a statement on every street corner.',
      ),
      ProductModel(
        id: '4',
        name: 'Boho Dream',
        subtitle: 'Free-spirited fashion',
        price: 179.00,
        originalPrice: 220.00,
        imageUrl:
            'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=600',
        images: [
          'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=800',
        ],
        rating: 4.7,
        reviewCount: 512,
        description:
            'Embrace your inner free spirit with this beautifully crafted boho-inspired collection. Flowing fabrics and earthy tones meet modern silhouettes.',
      ),
    ];
  }
}
