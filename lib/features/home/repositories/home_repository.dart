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
            'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=600',
        bgColor: Color(0xFFD81B60),
      ),
      const BannerModel(
        title: 'New Summer\nCollection 2025',
        subtitle: 'Fresh styles for the\nwarm season ahead.',
        imageUrl:
            'https://images.unsplash.com/photo-1612215326956-c2bb6228c72d?w=600',
        bgColor: Color(0xFFC2185B),
      ),
      const BannerModel(
        title: 'Up to 50% Off\nSelected Items',
        subtitle: 'Limited time offer on\npremium collections.',
        imageUrl:
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600',
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
        name: 'Velvet Rider Jacket',
        subtitle: 'Urban Style, Endless Motion',
        price: 199.00,
        originalPrice: 249.00,
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1742916917924-00d56e4ca5d7',
        images: [
          'https://plus.unsplash.com/premium_photo-1742916917924-00d56e4ca5d7',
          'https://plus.unsplash.com/premium_photo-1667520043080-53dcca77e2aa',
          'https://plus.unsplash.com/premium_photo-1682095763838-0ca2593193bd',
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
