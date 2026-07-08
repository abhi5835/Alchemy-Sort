import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'world/game_world.dart';

class AlchemyGame extends FlameGame<GameWorld> {
  AlchemyGame() : super(world: GameWorld());

  @override
  Color backgroundColor() => Colors.transparent;
}
