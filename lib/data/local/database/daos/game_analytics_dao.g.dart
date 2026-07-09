// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_analytics_dao.dart';

// ignore_for_file: type=lint
mixin _$GameAnalyticsDaoMixin on DatabaseAccessor<AppDatabase> {
  $GameAnalyticsEventsTable get gameAnalyticsEvents =>
      attachedDatabase.gameAnalyticsEvents;
  GameAnalyticsDaoManager get managers => GameAnalyticsDaoManager(this);
}

class GameAnalyticsDaoManager {
  final _$GameAnalyticsDaoMixin _db;
  GameAnalyticsDaoManager(this._db);
  $$GameAnalyticsEventsTableTableManager get gameAnalyticsEvents =>
      $$GameAnalyticsEventsTableTableManager(
        _db.attachedDatabase,
        _db.gameAnalyticsEvents,
      );
}
