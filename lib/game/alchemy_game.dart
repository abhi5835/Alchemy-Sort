import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'world/game_world.dart';
import 'models/potion_definition.dart';
import 'alchemy_game_mode.dart';
import 'daily/daily_challenge_generator.dart';

class AlchemyGame extends FlameGame<GameWorld> {
  PotionDefinition? lastDiscoveredPotion;
  final GameMode gameMode;
  final DailyChallenge? dailyChallenge;

  AlchemyGame({this.gameMode = GameMode.normal, this.dailyChallenge})
    : super(
        world: GameWorld(gameMode: gameMode, dailyChallenge: dailyChallenge),
      );

  @override
  Color backgroundColor() => Colors.transparent;
}
