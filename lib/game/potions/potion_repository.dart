import 'package:flutter/material.dart';
import '../models/potion_definition.dart';

class PotionRepository {
  static const List<PotionDefinition> _potions = [
    PotionDefinition(
      id: 'ember_essence',
      name: 'Ember Essence',
      description:
          'A warm, glowing liquid that smells of woodsmoke and adventure.',
      requiredLevel: 3,
      primaryColor: Colors.deepOrange,
      secondaryColor: Colors.orangeAccent,
      rarity: PotionRarity.common,
    ),
    PotionDefinition(
      id: 'frost_elixir',
      name: 'Frost Elixir',
      description:
          'Chilled to the touch, this potion crystallizes breath upon exhalation.',
      requiredLevel: 5,
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlueAccent,
      rarity: PotionRarity.common,
    ),
    PotionDefinition(
      id: 'verdant_brew',
      name: 'Verdant Brew',
      description: 'Teeming with the life force of ancient forests.',
      requiredLevel: 8,
      primaryColor: Colors.green,
      secondaryColor: Colors.lightGreenAccent,
      rarity: PotionRarity.rare,
    ),
    PotionDefinition(
      id: 'arcane_elixir',
      name: 'Arcane Elixir',
      description: 'An ancient essence infused with raw mystical energy.',
      requiredLevel: 12,
      primaryColor: Colors.purple,
      secondaryColor: Colors.purpleAccent,
      rarity: PotionRarity.epic,
    ),
    PotionDefinition(
      id: 'shadow_serum',
      name: 'Shadow Serum',
      description:
          'Swirling darkness that seems to consume the light around it.',
      requiredLevel: 16,
      primaryColor: Colors.deepPurple,
      secondaryColor: Colors.black87,
      rarity: PotionRarity.rare,
    ),
    PotionDefinition(
      id: 'thunder_essence',
      name: 'Thunder Essence',
      description: 'Sparks of static electricity dance along the glass.',
      requiredLevel: 20,
      primaryColor: Colors.yellow,
      secondaryColor: Colors.amberAccent,
      rarity: PotionRarity.epic,
    ),
    PotionDefinition(
      id: 'moonlight_tonic',
      name: 'Moonlight Tonic',
      description: 'A soft, silvery liquid brewed under a full moon.',
      requiredLevel: 25,
      primaryColor: Colors.white70,
      secondaryColor: Colors.lightBlue,
      rarity: PotionRarity.rare,
    ),
    PotionDefinition(
      id: 'solar_draught',
      name: 'Solar Draught',
      description: 'Radiates intense heat and shines like a captured star.',
      requiredLevel: 30,
      primaryColor: Colors.amber,
      secondaryColor: Colors.redAccent,
      rarity: PotionRarity.epic,
    ),
    PotionDefinition(
      id: 'crystal_infusion',
      name: 'Crystal Infusion',
      description: 'Contains microscopic gemstones that chime when shaken.',
      requiredLevel: 40,
      primaryColor: Colors.cyan,
      secondaryColor: Colors.tealAccent,
      rarity: PotionRarity.rare,
    ),
    PotionDefinition(
      id: 'void_extract',
      name: 'Void Extract',
      description: 'Gazing into it feels like falling into nothingness.',
      requiredLevel: 50,
      primaryColor: Colors.black,
      secondaryColor: Colors.deepPurpleAccent,
      rarity: PotionRarity.epic,
    ),
    PotionDefinition(
      id: 'dragonfire_elixir',
      name: 'Dragonfire Elixir',
      description: 'Boils continuously without a heat source.',
      requiredLevel: 60,
      primaryColor: Colors.red,
      secondaryColor: Colors.orange,
      rarity: PotionRarity.legendary,
    ),
    PotionDefinition(
      id: 'celestial_essence',
      name: 'Celestial Essence',
      description: 'A cosmic brew containing the dust of fallen stars.',
      requiredLevel: 75,
      primaryColor: Colors.indigo,
      secondaryColor: Colors.pinkAccent,
      rarity: PotionRarity.legendary,
    ),
  ];

  static List<PotionDefinition> get allPotions => _potions;

  static int get totalPotionCount => _potions.length;

  static PotionDefinition? getById(String id) {
    try {
      return _potions.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static PotionDefinition? getPotionUnlockedAtLevel(int levelNumber) {
    try {
      return _potions.firstWhere((p) => p.requiredLevel == levelNumber);
    } catch (e) {
      return null;
    }
  }

  static PotionDefinition? getNextPotionAfterLevel(int levelNumber) {
    try {
      return _potions.firstWhere((p) => p.requiredLevel > levelNumber);
    } catch (e) {
      return null;
    }
  }
}
