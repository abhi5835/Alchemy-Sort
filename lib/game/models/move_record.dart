import 'dart:ui';
import 'package:equatable/equatable.dart';

class MoveRecord extends Equatable {
  final int sourceTubeIndex;
  final int targetTubeIndex;
  final List<Color> sourceLiquidsBefore;
  final List<Color> targetLiquidsBefore;
  final int scoreBefore;
  final int solvedPotionCountBefore;
  final int comboBonusEarnedBefore;
  final int highestComboBefore;

  const MoveRecord({
    required this.sourceTubeIndex,
    required this.targetTubeIndex,
    required this.sourceLiquidsBefore,
    required this.targetLiquidsBefore,
    required this.scoreBefore,
    required this.solvedPotionCountBefore,
    required this.comboBonusEarnedBefore,
    required this.highestComboBefore,
  });

  @override
  List<Object?> get props => [
    sourceTubeIndex,
    targetTubeIndex,
    sourceLiquidsBefore,
    targetLiquidsBefore,
    scoreBefore,
    solvedPotionCountBefore,
    comboBonusEarnedBefore,
    highestComboBefore,
  ];
}
