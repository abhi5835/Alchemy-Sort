// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_alchemy_dao.dart';

// ignore_for_file: type=lint
mixin _$DailyAlchemyDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyAlchemyRecordsTable get dailyAlchemyRecords =>
      attachedDatabase.dailyAlchemyRecords;
  DailyAlchemyDaoManager get managers => DailyAlchemyDaoManager(this);
}

class DailyAlchemyDaoManager {
  final _$DailyAlchemyDaoMixin _db;
  DailyAlchemyDaoManager(this._db);
  $$DailyAlchemyRecordsTableTableManager get dailyAlchemyRecords =>
      $$DailyAlchemyRecordsTableTableManager(
        _db.attachedDatabase,
        _db.dailyAlchemyRecords,
      );
}
