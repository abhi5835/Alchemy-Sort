// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_progress_dao.dart';

// ignore_for_file: type=lint
mixin _$PlayerProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlayerProgressTable get playerProgress => attachedDatabase.playerProgress;
  PlayerProgressDaoManager get managers => PlayerProgressDaoManager(this);
}

class PlayerProgressDaoManager {
  final _$PlayerProgressDaoMixin _db;
  PlayerProgressDaoManager(this._db);
  $$PlayerProgressTableTableManager get playerProgress =>
      $$PlayerProgressTableTableManager(
        _db.attachedDatabase,
        _db.playerProgress,
      );
}
