// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potion_collection_dao.dart';

// ignore_for_file: type=lint
mixin _$PotionCollectionDaoMixin on DatabaseAccessor<AppDatabase> {
  $DiscoveredPotionsTable get discoveredPotions =>
      attachedDatabase.discoveredPotions;
  PotionCollectionDaoManager get managers => PotionCollectionDaoManager(this);
}

class PotionCollectionDaoManager {
  final _$PotionCollectionDaoMixin _db;
  PotionCollectionDaoManager(this._db);
  $$DiscoveredPotionsTableTableManager get discoveredPotions =>
      $$DiscoveredPotionsTableTableManager(
        _db.attachedDatabase,
        _db.discoveredPotions,
      );
}
