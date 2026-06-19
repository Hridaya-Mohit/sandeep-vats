import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final IconData icon;
  final String symbol;
  final String title;
  final String titleHi;
  final String shortDesc;
  final String shortDescHi;
  final String description;
  final List<String> includes;
  final String duration;
  final String price;

  const ServiceModel({
    required this.id,
    required this.icon,
    required this.symbol,
    required this.title,
    required this.titleHi,
    required this.shortDesc,
    required this.shortDescHi,
    required this.description,
    required this.includes,
    required this.duration,
    required this.price,
  });
}
