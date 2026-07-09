import 'package:drift/drift.dart';
import '../tables/discovered_potions_table.dart';
import '../app_database.dart';

part 'potion_collection_dao.g.dart';

@DriftAccessor(tables: [DiscoveredPotions])
class PotionCollectionDao extends DatabaseAccessor<AppDatabase>
    with _$PotionCollectionDaoMixin {
  PotionCollectionDao(super.db);

  Future<List<DiscoveredPotion>> getAll() {
    return select(discoveredPotions).get();
  }

  Stream<List<DiscoveredPotion>> watchAll() {
    return select(discoveredPotions).watch();
  }

  Future<bool> isDiscovered(String potionId) async {
    final query = select(discoveredPotions)
      ..where((tbl) => tbl.potionId.equals(potionId));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<bool> discoverPotion({
    required String potionId,
    required int discoveredLevelNumber,
  }) async {
    final existing = await isDiscovered(potionId);
    if (!existing) {
      await into(discoveredPotions).insert(
        DiscoveredPotionsCompanion.insert(
          potionId: potionId,
          discoveredLevelNumber: discoveredLevelNumber,
        ),
        mode: InsertMode.insertOrIgnore,
      );
      return true;
    }
    return false;
  }

  Future<int> getDiscoveredCount() async {
    final countExp = discoveredPotions.potionId.count();
    final query = selectOnly(discoveredPotions)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}
