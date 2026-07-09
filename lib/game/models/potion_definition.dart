import 'package:flutter/material.dart';

enum PotionRarity { common, rare, epic, legendary }

class PotionDefinition {
  final String id;
  final String name;
  final String description;
  final int requiredLevel;
  final Color primaryColor;
  final Color secondaryColor;
  final PotionRarity rarity;

  const PotionDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredLevel,
    required this.primaryColor,
    required this.secondaryColor,
    required this.rarity,
  });
}
