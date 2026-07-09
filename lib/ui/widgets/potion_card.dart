import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/models/potion_definition.dart';
import 'potion_visual.dart';

class PotionCard extends StatelessWidget {
  final PotionDefinition potion;
  final bool isDiscovered;

  const PotionCard({
    super.key,
    required this.potion,
    required this.isDiscovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a0b2e).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDiscovered
              ? _getRarityColor(potion.rarity).withValues(alpha: 0.5)
              : Colors.white10,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: PotionVisual(
                primaryColor: potion.primaryColor,
                secondaryColor: potion.secondaryColor,
                isDiscovered: isDiscovered,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isDiscovered ? potion.name : '???',
            style: GoogleFonts.cinzel(
              color: isDiscovered ? Colors.white : Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (isDiscovered)
            Text(
              potion.rarity.name.toUpperCase(),
              style: GoogleFonts.outfit(
                color: _getRarityColor(potion.rarity),
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              'LOCKED',
              style: GoogleFonts.outfit(
                color: Colors.white30,
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Color _getRarityColor(PotionRarity rarity) {
    switch (rarity) {
      case PotionRarity.common:
        return Colors.white70;
      case PotionRarity.rare:
        return Colors.blueAccent;
      case PotionRarity.epic:
        return Colors.purpleAccent;
      case PotionRarity.legendary:
        return Colors.orangeAccent;
    }
  }
}
