import 'package:flutter/material.dart';

class BannerModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color bgColor;

  const BannerModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.bgColor,
  });
}