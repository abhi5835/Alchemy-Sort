import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/managers/potion_collection_manager.dart';
import '../../game/potions/potion_repository.dart';
import '../widgets/potion_card.dart';

class PotionBookScreen extends StatefulWidget {
  final bool embedded;
  const PotionBookScreen({super.key, this.embedded = false});

  @override
  State<PotionBookScreen> createState() => _PotionBookScreenState();
}

class _PotionBookScreenState extends State<PotionBookScreen> {
  final PotionCollectionManager _manager = PotionCollectionManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101420),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.embedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          'POTION BOOK',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: _manager.discoveredPotionIds,
                builder: (context, discovered, child) {
                  final int count = discovered.length;
                  final int total = PotionRepository.totalPotionCount;

                  return Column(
                    children: [
                      Text(
                        '$count / $total DISCOVERED',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total > 0 ? count / total : 0,
                          backgroundColor: Colors.white12,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.purpleAccent,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Grid
            Expanded(
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: _manager.discoveredPotionIds,
                builder: (context, discovered, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: PotionRepository.totalPotionCount,
                    itemBuilder: (context, index) {
                      final potion = PotionRepository.allPotions[index];
                      final isDiscovered = discovered.contains(potion.id);

                      return PotionCard(
                        potion: potion,
                        isDiscovered: isDiscovered,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
