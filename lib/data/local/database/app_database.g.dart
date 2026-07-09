// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayerProgressTable extends PlayerProgress
    with TableInfo<$PlayerProgressTable, PlayerProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _highestUnlockedLevelIndexMeta =
      const VerificationMeta('highestUnlockedLevelIndex');
  @override
  late final GeneratedColumn<int> highestUnlockedLevelIndex =
      GeneratedColumn<int>(
        'highest_unlocked_level_index',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAlchemistXpMeta = const VerificationMeta(
    'totalAlchemistXp',
  );
  @override
  late final GeneratedColumn<int> totalAlchemistXp = GeneratedColumn<int>(
    'total_alchemist_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    highestUnlockedLevelIndex,
    totalScore,
    totalAlchemistXp,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('highest_unlocked_level_index')) {
      context.handle(
        _highestUnlockedLevelIndexMeta,
        highestUnlockedLevelIndex.isAcceptableOrUnknown(
          data['highest_unlocked_level_index']!,
          _highestUnlockedLevelIndexMeta,
        ),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('total_alchemist_xp')) {
      context.handle(
        _totalAlchemistXpMeta,
        totalAlchemistXp.isAcceptableOrUnknown(
          data['total_alchemist_xp']!,
          _totalAlchemistXpMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      highestUnlockedLevelIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_unlocked_level_index'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
      totalAlchemistXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_alchemist_xp'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlayerProgressTable createAlias(String alias) {
    return $PlayerProgressTable(attachedDatabase, alias);
  }
}

class PlayerProgressData extends DataClass
    implements Insertable<PlayerProgressData> {
  final int id;
  final int highestUnlockedLevelIndex;
  final int totalScore;
  final int totalAlchemistXp;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlayerProgressData({
    required this.id,
    required this.highestUnlockedLevelIndex,
    required this.totalScore,
    required this.totalAlchemistXp,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['highest_unlocked_level_index'] = Variable<int>(
      highestUnlockedLevelIndex,
    );
    map['total_score'] = Variable<int>(totalScore);
    map['total_alchemist_xp'] = Variable<int>(totalAlchemistXp);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlayerProgressCompanion toCompanion(bool nullToAbsent) {
    return PlayerProgressCompanion(
      id: Value(id),
      highestUnlockedLevelIndex: Value(highestUnlockedLevelIndex),
      totalScore: Value(totalScore),
      totalAlchemistXp: Value(totalAlchemistXp),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlayerProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerProgressData(
      id: serializer.fromJson<int>(json['id']),
      highestUnlockedLevelIndex: serializer.fromJson<int>(
        json['highestUnlockedLevelIndex'],
      ),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      totalAlchemistXp: serializer.fromJson<int>(json['totalAlchemistXp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'highestUnlockedLevelIndex': serializer.toJson<int>(
        highestUnlockedLevelIndex,
      ),
      'totalScore': serializer.toJson<int>(totalScore),
      'totalAlchemistXp': serializer.toJson<int>(totalAlchemistXp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlayerProgressData copyWith({
    int? id,
    int? highestUnlockedLevelIndex,
    int? totalScore,
    int? totalAlchemistXp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlayerProgressData(
    id: id ?? this.id,
    highestUnlockedLevelIndex:
        highestUnlockedLevelIndex ?? this.highestUnlockedLevelIndex,
    totalScore: totalScore ?? this.totalScore,
    totalAlchemistXp: totalAlchemistXp ?? this.totalAlchemistXp,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlayerProgressData copyWithCompanion(PlayerProgressCompanion data) {
    return PlayerProgressData(
      id: data.id.present ? data.id.value : this.id,
      highestUnlockedLevelIndex: data.highestUnlockedLevelIndex.present
          ? data.highestUnlockedLevelIndex.value
          : this.highestUnlockedLevelIndex,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      totalAlchemistXp: data.totalAlchemistXp.present
          ? data.totalAlchemistXp.value
          : this.totalAlchemistXp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerProgressData(')
          ..write('id: $id, ')
          ..write('highestUnlockedLevelIndex: $highestUnlockedLevelIndex, ')
          ..write('totalScore: $totalScore, ')
          ..write('totalAlchemistXp: $totalAlchemistXp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    highestUnlockedLevelIndex,
    totalScore,
    totalAlchemistXp,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerProgressData &&
          other.id == this.id &&
          other.highestUnlockedLevelIndex == this.highestUnlockedLevelIndex &&
          other.totalScore == this.totalScore &&
          other.totalAlchemistXp == this.totalAlchemistXp &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlayerProgressCompanion extends UpdateCompanion<PlayerProgressData> {
  final Value<int> id;
  final Value<int> highestUnlockedLevelIndex;
  final Value<int> totalScore;
  final Value<int> totalAlchemistXp;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PlayerProgressCompanion({
    this.id = const Value.absent(),
    this.highestUnlockedLevelIndex = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.totalAlchemistXp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PlayerProgressCompanion.insert({
    this.id = const Value.absent(),
    this.highestUnlockedLevelIndex = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.totalAlchemistXp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<PlayerProgressData> custom({
    Expression<int>? id,
    Expression<int>? highestUnlockedLevelIndex,
    Expression<int>? totalScore,
    Expression<int>? totalAlchemistXp,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (highestUnlockedLevelIndex != null)
        'highest_unlocked_level_index': highestUnlockedLevelIndex,
      if (totalScore != null) 'total_score': totalScore,
      if (totalAlchemistXp != null) 'total_alchemist_xp': totalAlchemistXp,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PlayerProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? highestUnlockedLevelIndex,
    Value<int>? totalScore,
    Value<int>? totalAlchemistXp,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PlayerProgressCompanion(
      id: id ?? this.id,
      highestUnlockedLevelIndex:
          highestUnlockedLevelIndex ?? this.highestUnlockedLevelIndex,
      totalScore: totalScore ?? this.totalScore,
      totalAlchemistXp: totalAlchemistXp ?? this.totalAlchemistXp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (highestUnlockedLevelIndex.present) {
      map['highest_unlocked_level_index'] = Variable<int>(
        highestUnlockedLevelIndex.value,
      );
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (totalAlchemistXp.present) {
      map['total_alchemist_xp'] = Variable<int>(totalAlchemistXp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerProgressCompanion(')
          ..write('id: $id, ')
          ..write('highestUnlockedLevelIndex: $highestUnlockedLevelIndex, ')
          ..write('totalScore: $totalScore, ')
          ..write('totalAlchemistXp: $totalAlchemistXp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DiscoveredPotionsTable extends DiscoveredPotions
    with TableInfo<$DiscoveredPotionsTable, DiscoveredPotion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscoveredPotionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _potionIdMeta = const VerificationMeta(
    'potionId',
  );
  @override
  late final GeneratedColumn<String> potionId = GeneratedColumn<String>(
    'potion_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discoveredAtMeta = const VerificationMeta(
    'discoveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> discoveredAt = GeneratedColumn<DateTime>(
    'discovered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _discoveredLevelNumberMeta =
      const VerificationMeta('discoveredLevelNumber');
  @override
  late final GeneratedColumn<int> discoveredLevelNumber = GeneratedColumn<int>(
    'discovered_level_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    potionId,
    discoveredAt,
    discoveredLevelNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discovered_potions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiscoveredPotion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('potion_id')) {
      context.handle(
        _potionIdMeta,
        potionId.isAcceptableOrUnknown(data['potion_id']!, _potionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_potionIdMeta);
    }
    if (data.containsKey('discovered_at')) {
      context.handle(
        _discoveredAtMeta,
        discoveredAt.isAcceptableOrUnknown(
          data['discovered_at']!,
          _discoveredAtMeta,
        ),
      );
    }
    if (data.containsKey('discovered_level_number')) {
      context.handle(
        _discoveredLevelNumberMeta,
        discoveredLevelNumber.isAcceptableOrUnknown(
          data['discovered_level_number']!,
          _discoveredLevelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discoveredLevelNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {potionId};
  @override
  DiscoveredPotion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscoveredPotion(
      potionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}potion_id'],
      )!,
      discoveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}discovered_at'],
      )!,
      discoveredLevelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discovered_level_number'],
      )!,
    );
  }

  @override
  $DiscoveredPotionsTable createAlias(String alias) {
    return $DiscoveredPotionsTable(attachedDatabase, alias);
  }
}

class DiscoveredPotion extends DataClass
    implements Insertable<DiscoveredPotion> {
  final String potionId;
  final DateTime discoveredAt;
  final int discoveredLevelNumber;
  const DiscoveredPotion({
    required this.potionId,
    required this.discoveredAt,
    required this.discoveredLevelNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['potion_id'] = Variable<String>(potionId);
    map['discovered_at'] = Variable<DateTime>(discoveredAt);
    map['discovered_level_number'] = Variable<int>(discoveredLevelNumber);
    return map;
  }

  DiscoveredPotionsCompanion toCompanion(bool nullToAbsent) {
    return DiscoveredPotionsCompanion(
      potionId: Value(potionId),
      discoveredAt: Value(discoveredAt),
      discoveredLevelNumber: Value(discoveredLevelNumber),
    );
  }

  factory DiscoveredPotion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscoveredPotion(
      potionId: serializer.fromJson<String>(json['potionId']),
      discoveredAt: serializer.fromJson<DateTime>(json['discoveredAt']),
      discoveredLevelNumber: serializer.fromJson<int>(
        json['discoveredLevelNumber'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'potionId': serializer.toJson<String>(potionId),
      'discoveredAt': serializer.toJson<DateTime>(discoveredAt),
      'discoveredLevelNumber': serializer.toJson<int>(discoveredLevelNumber),
    };
  }

  DiscoveredPotion copyWith({
    String? potionId,
    DateTime? discoveredAt,
    int? discoveredLevelNumber,
  }) => DiscoveredPotion(
    potionId: potionId ?? this.potionId,
    discoveredAt: discoveredAt ?? this.discoveredAt,
    discoveredLevelNumber: discoveredLevelNumber ?? this.discoveredLevelNumber,
  );
  DiscoveredPotion copyWithCompanion(DiscoveredPotionsCompanion data) {
    return DiscoveredPotion(
      potionId: data.potionId.present ? data.potionId.value : this.potionId,
      discoveredAt: data.discoveredAt.present
          ? data.discoveredAt.value
          : this.discoveredAt,
      discoveredLevelNumber: data.discoveredLevelNumber.present
          ? data.discoveredLevelNumber.value
          : this.discoveredLevelNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveredPotion(')
          ..write('potionId: $potionId, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('discoveredLevelNumber: $discoveredLevelNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(potionId, discoveredAt, discoveredLevelNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscoveredPotion &&
          other.potionId == this.potionId &&
          other.discoveredAt == this.discoveredAt &&
          other.discoveredLevelNumber == this.discoveredLevelNumber);
}

class DiscoveredPotionsCompanion extends UpdateCompanion<DiscoveredPotion> {
  final Value<String> potionId;
  final Value<DateTime> discoveredAt;
  final Value<int> discoveredLevelNumber;
  final Value<int> rowid;
  const DiscoveredPotionsCompanion({
    this.potionId = const Value.absent(),
    this.discoveredAt = const Value.absent(),
    this.discoveredLevelNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscoveredPotionsCompanion.insert({
    required String potionId,
    this.discoveredAt = const Value.absent(),
    required int discoveredLevelNumber,
    this.rowid = const Value.absent(),
  }) : potionId = Value(potionId),
       discoveredLevelNumber = Value(discoveredLevelNumber);
  static Insertable<DiscoveredPotion> custom({
    Expression<String>? potionId,
    Expression<DateTime>? discoveredAt,
    Expression<int>? discoveredLevelNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (potionId != null) 'potion_id': potionId,
      if (discoveredAt != null) 'discovered_at': discoveredAt,
      if (discoveredLevelNumber != null)
        'discovered_level_number': discoveredLevelNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscoveredPotionsCompanion copyWith({
    Value<String>? potionId,
    Value<DateTime>? discoveredAt,
    Value<int>? discoveredLevelNumber,
    Value<int>? rowid,
  }) {
    return DiscoveredPotionsCompanion(
      potionId: potionId ?? this.potionId,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      discoveredLevelNumber:
          discoveredLevelNumber ?? this.discoveredLevelNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (potionId.present) {
      map['potion_id'] = Variable<String>(potionId.value);
    }
    if (discoveredAt.present) {
      map['discovered_at'] = Variable<DateTime>(discoveredAt.value);
    }
    if (discoveredLevelNumber.present) {
      map['discovered_level_number'] = Variable<int>(
        discoveredLevelNumber.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveredPotionsCompanion(')
          ..write('potionId: $potionId, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('discoveredLevelNumber: $discoveredLevelNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameAnalyticsEventsTable extends GameAnalyticsEvents
    with TableInfo<$GameAnalyticsEventsTable, GameAnalyticsEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameAnalyticsEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<int> eventType = GeneratedColumn<int>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelIndexMeta = const VerificationMeta(
    'levelIndex',
  );
  @override
  late final GeneratedColumn<int> levelIndex = GeneratedColumn<int>(
    'level_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelNumberMeta = const VerificationMeta(
    'levelNumber',
  );
  @override
  late final GeneratedColumn<int> levelNumber = GeneratedColumn<int>(
    'level_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTimestampMeta = const VerificationMeta(
    'eventTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> eventTimestamp =
      GeneratedColumn<DateTime>(
        'event_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _moveCountMeta = const VerificationMeta(
    'moveCount',
  );
  @override
  late final GeneratedColumn<int> moveCount = GeneratedColumn<int>(
    'move_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _undoCountMeta = const VerificationMeta(
    'undoCount',
  );
  @override
  late final GeneratedColumn<int> undoCount = GeneratedColumn<int>(
    'undo_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restartCountMeta = const VerificationMeta(
    'restartCount',
  );
  @override
  late final GeneratedColumn<int> restartCount = GeneratedColumn<int>(
    'restart_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _highestComboMeta = const VerificationMeta(
    'highestCombo',
  );
  @override
  late final GeneratedColumn<int> highestCombo = GeneratedColumn<int>(
    'highest_combo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _potionIdMeta = const VerificationMeta(
    'potionId',
  );
  @override
  late final GeneratedColumn<String> potionId = GeneratedColumn<String>(
    'potion_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    eventType,
    levelIndex,
    levelNumber,
    eventTimestamp,
    moveCount,
    undoCount,
    restartCount,
    durationMs,
    stars,
    highestCombo,
    potionId,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_analytics_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameAnalyticsEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('level_index')) {
      context.handle(
        _levelIndexMeta,
        levelIndex.isAcceptableOrUnknown(data['level_index']!, _levelIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIndexMeta);
    }
    if (data.containsKey('level_number')) {
      context.handle(
        _levelNumberMeta,
        levelNumber.isAcceptableOrUnknown(
          data['level_number']!,
          _levelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelNumberMeta);
    }
    if (data.containsKey('event_timestamp')) {
      context.handle(
        _eventTimestampMeta,
        eventTimestamp.isAcceptableOrUnknown(
          data['event_timestamp']!,
          _eventTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventTimestampMeta);
    }
    if (data.containsKey('move_count')) {
      context.handle(
        _moveCountMeta,
        moveCount.isAcceptableOrUnknown(data['move_count']!, _moveCountMeta),
      );
    }
    if (data.containsKey('undo_count')) {
      context.handle(
        _undoCountMeta,
        undoCount.isAcceptableOrUnknown(data['undo_count']!, _undoCountMeta),
      );
    }
    if (data.containsKey('restart_count')) {
      context.handle(
        _restartCountMeta,
        restartCount.isAcceptableOrUnknown(
          data['restart_count']!,
          _restartCountMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    }
    if (data.containsKey('highest_combo')) {
      context.handle(
        _highestComboMeta,
        highestCombo.isAcceptableOrUnknown(
          data['highest_combo']!,
          _highestComboMeta,
        ),
      );
    }
    if (data.containsKey('potion_id')) {
      context.handle(
        _potionIdMeta,
        potionId.isAcceptableOrUnknown(data['potion_id']!, _potionIdMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameAnalyticsEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameAnalyticsEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_type'],
      )!,
      levelIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_index'],
      )!,
      levelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_number'],
      )!,
      eventTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_timestamp'],
      )!,
      moveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}move_count'],
      ),
      undoCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}undo_count'],
      ),
      restartCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}restart_count'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      ),
      highestCombo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_combo'],
      ),
      potionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}potion_id'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
    );
  }

  @override
  $GameAnalyticsEventsTable createAlias(String alias) {
    return $GameAnalyticsEventsTable(attachedDatabase, alias);
  }
}

class GameAnalyticsEvent extends DataClass
    implements Insertable<GameAnalyticsEvent> {
  final int id;
  final String sessionId;
  final int eventType;
  final int levelIndex;
  final int levelNumber;
  final DateTime eventTimestamp;
  final int? moveCount;
  final int? undoCount;
  final int? restartCount;
  final int? durationMs;
  final int? stars;
  final int? highestCombo;
  final String? potionId;
  final String? metadataJson;
  const GameAnalyticsEvent({
    required this.id,
    required this.sessionId,
    required this.eventType,
    required this.levelIndex,
    required this.levelNumber,
    required this.eventTimestamp,
    this.moveCount,
    this.undoCount,
    this.restartCount,
    this.durationMs,
    this.stars,
    this.highestCombo,
    this.potionId,
    this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['event_type'] = Variable<int>(eventType);
    map['level_index'] = Variable<int>(levelIndex);
    map['level_number'] = Variable<int>(levelNumber);
    map['event_timestamp'] = Variable<DateTime>(eventTimestamp);
    if (!nullToAbsent || moveCount != null) {
      map['move_count'] = Variable<int>(moveCount);
    }
    if (!nullToAbsent || undoCount != null) {
      map['undo_count'] = Variable<int>(undoCount);
    }
    if (!nullToAbsent || restartCount != null) {
      map['restart_count'] = Variable<int>(restartCount);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || stars != null) {
      map['stars'] = Variable<int>(stars);
    }
    if (!nullToAbsent || highestCombo != null) {
      map['highest_combo'] = Variable<int>(highestCombo);
    }
    if (!nullToAbsent || potionId != null) {
      map['potion_id'] = Variable<String>(potionId);
    }
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  GameAnalyticsEventsCompanion toCompanion(bool nullToAbsent) {
    return GameAnalyticsEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      eventType: Value(eventType),
      levelIndex: Value(levelIndex),
      levelNumber: Value(levelNumber),
      eventTimestamp: Value(eventTimestamp),
      moveCount: moveCount == null && nullToAbsent
          ? const Value.absent()
          : Value(moveCount),
      undoCount: undoCount == null && nullToAbsent
          ? const Value.absent()
          : Value(undoCount),
      restartCount: restartCount == null && nullToAbsent
          ? const Value.absent()
          : Value(restartCount),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      stars: stars == null && nullToAbsent
          ? const Value.absent()
          : Value(stars),
      highestCombo: highestCombo == null && nullToAbsent
          ? const Value.absent()
          : Value(highestCombo),
      potionId: potionId == null && nullToAbsent
          ? const Value.absent()
          : Value(potionId),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory GameAnalyticsEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameAnalyticsEvent(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      eventType: serializer.fromJson<int>(json['eventType']),
      levelIndex: serializer.fromJson<int>(json['levelIndex']),
      levelNumber: serializer.fromJson<int>(json['levelNumber']),
      eventTimestamp: serializer.fromJson<DateTime>(json['eventTimestamp']),
      moveCount: serializer.fromJson<int?>(json['moveCount']),
      undoCount: serializer.fromJson<int?>(json['undoCount']),
      restartCount: serializer.fromJson<int?>(json['restartCount']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      stars: serializer.fromJson<int?>(json['stars']),
      highestCombo: serializer.fromJson<int?>(json['highestCombo']),
      potionId: serializer.fromJson<String?>(json['potionId']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'eventType': serializer.toJson<int>(eventType),
      'levelIndex': serializer.toJson<int>(levelIndex),
      'levelNumber': serializer.toJson<int>(levelNumber),
      'eventTimestamp': serializer.toJson<DateTime>(eventTimestamp),
      'moveCount': serializer.toJson<int?>(moveCount),
      'undoCount': serializer.toJson<int?>(undoCount),
      'restartCount': serializer.toJson<int?>(restartCount),
      'durationMs': serializer.toJson<int?>(durationMs),
      'stars': serializer.toJson<int?>(stars),
      'highestCombo': serializer.toJson<int?>(highestCombo),
      'potionId': serializer.toJson<String?>(potionId),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  GameAnalyticsEvent copyWith({
    int? id,
    String? sessionId,
    int? eventType,
    int? levelIndex,
    int? levelNumber,
    DateTime? eventTimestamp,
    Value<int?> moveCount = const Value.absent(),
    Value<int?> undoCount = const Value.absent(),
    Value<int?> restartCount = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<int?> stars = const Value.absent(),
    Value<int?> highestCombo = const Value.absent(),
    Value<String?> potionId = const Value.absent(),
    Value<String?> metadataJson = const Value.absent(),
  }) => GameAnalyticsEvent(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    eventType: eventType ?? this.eventType,
    levelIndex: levelIndex ?? this.levelIndex,
    levelNumber: levelNumber ?? this.levelNumber,
    eventTimestamp: eventTimestamp ?? this.eventTimestamp,
    moveCount: moveCount.present ? moveCount.value : this.moveCount,
    undoCount: undoCount.present ? undoCount.value : this.undoCount,
    restartCount: restartCount.present ? restartCount.value : this.restartCount,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    stars: stars.present ? stars.value : this.stars,
    highestCombo: highestCombo.present ? highestCombo.value : this.highestCombo,
    potionId: potionId.present ? potionId.value : this.potionId,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
  );
  GameAnalyticsEvent copyWithCompanion(GameAnalyticsEventsCompanion data) {
    return GameAnalyticsEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      levelIndex: data.levelIndex.present
          ? data.levelIndex.value
          : this.levelIndex,
      levelNumber: data.levelNumber.present
          ? data.levelNumber.value
          : this.levelNumber,
      eventTimestamp: data.eventTimestamp.present
          ? data.eventTimestamp.value
          : this.eventTimestamp,
      moveCount: data.moveCount.present ? data.moveCount.value : this.moveCount,
      undoCount: data.undoCount.present ? data.undoCount.value : this.undoCount,
      restartCount: data.restartCount.present
          ? data.restartCount.value
          : this.restartCount,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      stars: data.stars.present ? data.stars.value : this.stars,
      highestCombo: data.highestCombo.present
          ? data.highestCombo.value
          : this.highestCombo,
      potionId: data.potionId.present ? data.potionId.value : this.potionId,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameAnalyticsEvent(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('eventType: $eventType, ')
          ..write('levelIndex: $levelIndex, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('moveCount: $moveCount, ')
          ..write('undoCount: $undoCount, ')
          ..write('restartCount: $restartCount, ')
          ..write('durationMs: $durationMs, ')
          ..write('stars: $stars, ')
          ..write('highestCombo: $highestCombo, ')
          ..write('potionId: $potionId, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    eventType,
    levelIndex,
    levelNumber,
    eventTimestamp,
    moveCount,
    undoCount,
    restartCount,
    durationMs,
    stars,
    highestCombo,
    potionId,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameAnalyticsEvent &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.eventType == this.eventType &&
          other.levelIndex == this.levelIndex &&
          other.levelNumber == this.levelNumber &&
          other.eventTimestamp == this.eventTimestamp &&
          other.moveCount == this.moveCount &&
          other.undoCount == this.undoCount &&
          other.restartCount == this.restartCount &&
          other.durationMs == this.durationMs &&
          other.stars == this.stars &&
          other.highestCombo == this.highestCombo &&
          other.potionId == this.potionId &&
          other.metadataJson == this.metadataJson);
}

class GameAnalyticsEventsCompanion extends UpdateCompanion<GameAnalyticsEvent> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> eventType;
  final Value<int> levelIndex;
  final Value<int> levelNumber;
  final Value<DateTime> eventTimestamp;
  final Value<int?> moveCount;
  final Value<int?> undoCount;
  final Value<int?> restartCount;
  final Value<int?> durationMs;
  final Value<int?> stars;
  final Value<int?> highestCombo;
  final Value<String?> potionId;
  final Value<String?> metadataJson;
  const GameAnalyticsEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.levelIndex = const Value.absent(),
    this.levelNumber = const Value.absent(),
    this.eventTimestamp = const Value.absent(),
    this.moveCount = const Value.absent(),
    this.undoCount = const Value.absent(),
    this.restartCount = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.stars = const Value.absent(),
    this.highestCombo = const Value.absent(),
    this.potionId = const Value.absent(),
    this.metadataJson = const Value.absent(),
  });
  GameAnalyticsEventsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int eventType,
    required int levelIndex,
    required int levelNumber,
    required DateTime eventTimestamp,
    this.moveCount = const Value.absent(),
    this.undoCount = const Value.absent(),
    this.restartCount = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.stars = const Value.absent(),
    this.highestCombo = const Value.absent(),
    this.potionId = const Value.absent(),
    this.metadataJson = const Value.absent(),
  }) : sessionId = Value(sessionId),
       eventType = Value(eventType),
       levelIndex = Value(levelIndex),
       levelNumber = Value(levelNumber),
       eventTimestamp = Value(eventTimestamp);
  static Insertable<GameAnalyticsEvent> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? eventType,
    Expression<int>? levelIndex,
    Expression<int>? levelNumber,
    Expression<DateTime>? eventTimestamp,
    Expression<int>? moveCount,
    Expression<int>? undoCount,
    Expression<int>? restartCount,
    Expression<int>? durationMs,
    Expression<int>? stars,
    Expression<int>? highestCombo,
    Expression<String>? potionId,
    Expression<String>? metadataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (eventType != null) 'event_type': eventType,
      if (levelIndex != null) 'level_index': levelIndex,
      if (levelNumber != null) 'level_number': levelNumber,
      if (eventTimestamp != null) 'event_timestamp': eventTimestamp,
      if (moveCount != null) 'move_count': moveCount,
      if (undoCount != null) 'undo_count': undoCount,
      if (restartCount != null) 'restart_count': restartCount,
      if (durationMs != null) 'duration_ms': durationMs,
      if (stars != null) 'stars': stars,
      if (highestCombo != null) 'highest_combo': highestCombo,
      if (potionId != null) 'potion_id': potionId,
      if (metadataJson != null) 'metadata_json': metadataJson,
    });
  }

  GameAnalyticsEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<int>? eventType,
    Value<int>? levelIndex,
    Value<int>? levelNumber,
    Value<DateTime>? eventTimestamp,
    Value<int?>? moveCount,
    Value<int?>? undoCount,
    Value<int?>? restartCount,
    Value<int?>? durationMs,
    Value<int?>? stars,
    Value<int?>? highestCombo,
    Value<String?>? potionId,
    Value<String?>? metadataJson,
  }) {
    return GameAnalyticsEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      eventType: eventType ?? this.eventType,
      levelIndex: levelIndex ?? this.levelIndex,
      levelNumber: levelNumber ?? this.levelNumber,
      eventTimestamp: eventTimestamp ?? this.eventTimestamp,
      moveCount: moveCount ?? this.moveCount,
      undoCount: undoCount ?? this.undoCount,
      restartCount: restartCount ?? this.restartCount,
      durationMs: durationMs ?? this.durationMs,
      stars: stars ?? this.stars,
      highestCombo: highestCombo ?? this.highestCombo,
      potionId: potionId ?? this.potionId,
      metadataJson: metadataJson ?? this.metadataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<int>(eventType.value);
    }
    if (levelIndex.present) {
      map['level_index'] = Variable<int>(levelIndex.value);
    }
    if (levelNumber.present) {
      map['level_number'] = Variable<int>(levelNumber.value);
    }
    if (eventTimestamp.present) {
      map['event_timestamp'] = Variable<DateTime>(eventTimestamp.value);
    }
    if (moveCount.present) {
      map['move_count'] = Variable<int>(moveCount.value);
    }
    if (undoCount.present) {
      map['undo_count'] = Variable<int>(undoCount.value);
    }
    if (restartCount.present) {
      map['restart_count'] = Variable<int>(restartCount.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (highestCombo.present) {
      map['highest_combo'] = Variable<int>(highestCombo.value);
    }
    if (potionId.present) {
      map['potion_id'] = Variable<String>(potionId.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameAnalyticsEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('eventType: $eventType, ')
          ..write('levelIndex: $levelIndex, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('moveCount: $moveCount, ')
          ..write('undoCount: $undoCount, ')
          ..write('restartCount: $restartCount, ')
          ..write('durationMs: $durationMs, ')
          ..write('stars: $stars, ')
          ..write('highestCombo: $highestCombo, ')
          ..write('potionId: $potionId, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }
}

class $DailyAlchemyRecordsTable extends DailyAlchemyRecords
    with TableInfo<$DailyAlchemyRecordsTable, DailyAlchemyRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyAlchemyRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLevelIndexMeta = const VerificationMeta(
    'sourceLevelIndex',
  );
  @override
  late final GeneratedColumn<int> sourceLevelIndex = GeneratedColumn<int>(
    'source_level_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DailyChallengeStatus, String>
  status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DailyChallengeStatus>(
        $DailyAlchemyRecordsTable.$converterstatus,
      );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestMoveCountMeta = const VerificationMeta(
    'bestMoveCount',
  );
  @override
  late final GeneratedColumn<int> bestMoveCount = GeneratedColumn<int>(
    'best_move_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestDurationMsMeta = const VerificationMeta(
    'bestDurationMs',
  );
  @override
  late final GeneratedColumn<int> bestDurationMs = GeneratedColumn<int>(
    'best_duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestStarsMeta = const VerificationMeta(
    'bestStars',
  );
  @override
  late final GeneratedColumn<int> bestStars = GeneratedColumn<int>(
    'best_stars',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewardClaimedMeta = const VerificationMeta(
    'rewardClaimed',
  );
  @override
  late final GeneratedColumn<bool> rewardClaimed = GeneratedColumn<bool>(
    'reward_claimed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reward_claimed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _xpRewardMeta = const VerificationMeta(
    'xpReward',
  );
  @override
  late final GeneratedColumn<int> xpReward = GeneratedColumn<int>(
    'xp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    sourceLevelIndex,
    status,
    attemptCount,
    completedAt,
    bestMoveCount,
    bestDurationMs,
    bestStars,
    rewardClaimed,
    xpReward,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_alchemy_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyAlchemyRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('source_level_index')) {
      context.handle(
        _sourceLevelIndexMeta,
        sourceLevelIndex.isAcceptableOrUnknown(
          data['source_level_index']!,
          _sourceLevelIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLevelIndexMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('best_move_count')) {
      context.handle(
        _bestMoveCountMeta,
        bestMoveCount.isAcceptableOrUnknown(
          data['best_move_count']!,
          _bestMoveCountMeta,
        ),
      );
    }
    if (data.containsKey('best_duration_ms')) {
      context.handle(
        _bestDurationMsMeta,
        bestDurationMs.isAcceptableOrUnknown(
          data['best_duration_ms']!,
          _bestDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('best_stars')) {
      context.handle(
        _bestStarsMeta,
        bestStars.isAcceptableOrUnknown(data['best_stars']!, _bestStarsMeta),
      );
    }
    if (data.containsKey('reward_claimed')) {
      context.handle(
        _rewardClaimedMeta,
        rewardClaimed.isAcceptableOrUnknown(
          data['reward_claimed']!,
          _rewardClaimedMeta,
        ),
      );
    }
    if (data.containsKey('xp_reward')) {
      context.handle(
        _xpRewardMeta,
        xpReward.isAcceptableOrUnknown(data['xp_reward']!, _xpRewardMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateKey};
  @override
  DailyAlchemyRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyAlchemyRecordData(
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      sourceLevelIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_level_index'],
      )!,
      status: $DailyAlchemyRecordsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      bestMoveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_move_count'],
      ),
      bestDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_duration_ms'],
      ),
      bestStars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_stars'],
      ),
      rewardClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reward_claimed'],
      )!,
      xpReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_reward'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyAlchemyRecordsTable createAlias(String alias) {
    return $DailyAlchemyRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DailyChallengeStatus, String, String>
  $converterstatus = const EnumNameConverter(DailyChallengeStatus.values);
}

class DailyAlchemyRecordData extends DataClass
    implements Insertable<DailyAlchemyRecordData> {
  final String dateKey;
  final int sourceLevelIndex;
  final DailyChallengeStatus status;
  final int attemptCount;
  final DateTime? completedAt;
  final int? bestMoveCount;
  final int? bestDurationMs;
  final int? bestStars;
  final bool rewardClaimed;
  final int xpReward;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyAlchemyRecordData({
    required this.dateKey,
    required this.sourceLevelIndex,
    required this.status,
    required this.attemptCount,
    this.completedAt,
    this.bestMoveCount,
    this.bestDurationMs,
    this.bestStars,
    required this.rewardClaimed,
    required this.xpReward,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['source_level_index'] = Variable<int>(sourceLevelIndex);
    {
      map['status'] = Variable<String>(
        $DailyAlchemyRecordsTable.$converterstatus.toSql(status),
      );
    }
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || bestMoveCount != null) {
      map['best_move_count'] = Variable<int>(bestMoveCount);
    }
    if (!nullToAbsent || bestDurationMs != null) {
      map['best_duration_ms'] = Variable<int>(bestDurationMs);
    }
    if (!nullToAbsent || bestStars != null) {
      map['best_stars'] = Variable<int>(bestStars);
    }
    map['reward_claimed'] = Variable<bool>(rewardClaimed);
    map['xp_reward'] = Variable<int>(xpReward);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyAlchemyRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyAlchemyRecordsCompanion(
      dateKey: Value(dateKey),
      sourceLevelIndex: Value(sourceLevelIndex),
      status: Value(status),
      attemptCount: Value(attemptCount),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      bestMoveCount: bestMoveCount == null && nullToAbsent
          ? const Value.absent()
          : Value(bestMoveCount),
      bestDurationMs: bestDurationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(bestDurationMs),
      bestStars: bestStars == null && nullToAbsent
          ? const Value.absent()
          : Value(bestStars),
      rewardClaimed: Value(rewardClaimed),
      xpReward: Value(xpReward),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyAlchemyRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyAlchemyRecordData(
      dateKey: serializer.fromJson<String>(json['dateKey']),
      sourceLevelIndex: serializer.fromJson<int>(json['sourceLevelIndex']),
      status: $DailyAlchemyRecordsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      bestMoveCount: serializer.fromJson<int?>(json['bestMoveCount']),
      bestDurationMs: serializer.fromJson<int?>(json['bestDurationMs']),
      bestStars: serializer.fromJson<int?>(json['bestStars']),
      rewardClaimed: serializer.fromJson<bool>(json['rewardClaimed']),
      xpReward: serializer.fromJson<int>(json['xpReward']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateKey': serializer.toJson<String>(dateKey),
      'sourceLevelIndex': serializer.toJson<int>(sourceLevelIndex),
      'status': serializer.toJson<String>(
        $DailyAlchemyRecordsTable.$converterstatus.toJson(status),
      ),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'bestMoveCount': serializer.toJson<int?>(bestMoveCount),
      'bestDurationMs': serializer.toJson<int?>(bestDurationMs),
      'bestStars': serializer.toJson<int?>(bestStars),
      'rewardClaimed': serializer.toJson<bool>(rewardClaimed),
      'xpReward': serializer.toJson<int>(xpReward),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyAlchemyRecordData copyWith({
    String? dateKey,
    int? sourceLevelIndex,
    DailyChallengeStatus? status,
    int? attemptCount,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> bestMoveCount = const Value.absent(),
    Value<int?> bestDurationMs = const Value.absent(),
    Value<int?> bestStars = const Value.absent(),
    bool? rewardClaimed,
    int? xpReward,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyAlchemyRecordData(
    dateKey: dateKey ?? this.dateKey,
    sourceLevelIndex: sourceLevelIndex ?? this.sourceLevelIndex,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    bestMoveCount: bestMoveCount.present
        ? bestMoveCount.value
        : this.bestMoveCount,
    bestDurationMs: bestDurationMs.present
        ? bestDurationMs.value
        : this.bestDurationMs,
    bestStars: bestStars.present ? bestStars.value : this.bestStars,
    rewardClaimed: rewardClaimed ?? this.rewardClaimed,
    xpReward: xpReward ?? this.xpReward,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyAlchemyRecordData copyWithCompanion(DailyAlchemyRecordsCompanion data) {
    return DailyAlchemyRecordData(
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      sourceLevelIndex: data.sourceLevelIndex.present
          ? data.sourceLevelIndex.value
          : this.sourceLevelIndex,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      bestMoveCount: data.bestMoveCount.present
          ? data.bestMoveCount.value
          : this.bestMoveCount,
      bestDurationMs: data.bestDurationMs.present
          ? data.bestDurationMs.value
          : this.bestDurationMs,
      bestStars: data.bestStars.present ? data.bestStars.value : this.bestStars,
      rewardClaimed: data.rewardClaimed.present
          ? data.rewardClaimed.value
          : this.rewardClaimed,
      xpReward: data.xpReward.present ? data.xpReward.value : this.xpReward,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyAlchemyRecordData(')
          ..write('dateKey: $dateKey, ')
          ..write('sourceLevelIndex: $sourceLevelIndex, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('bestMoveCount: $bestMoveCount, ')
          ..write('bestDurationMs: $bestDurationMs, ')
          ..write('bestStars: $bestStars, ')
          ..write('rewardClaimed: $rewardClaimed, ')
          ..write('xpReward: $xpReward, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dateKey,
    sourceLevelIndex,
    status,
    attemptCount,
    completedAt,
    bestMoveCount,
    bestDurationMs,
    bestStars,
    rewardClaimed,
    xpReward,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyAlchemyRecordData &&
          other.dateKey == this.dateKey &&
          other.sourceLevelIndex == this.sourceLevelIndex &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.completedAt == this.completedAt &&
          other.bestMoveCount == this.bestMoveCount &&
          other.bestDurationMs == this.bestDurationMs &&
          other.bestStars == this.bestStars &&
          other.rewardClaimed == this.rewardClaimed &&
          other.xpReward == this.xpReward &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyAlchemyRecordsCompanion
    extends UpdateCompanion<DailyAlchemyRecordData> {
  final Value<String> dateKey;
  final Value<int> sourceLevelIndex;
  final Value<DailyChallengeStatus> status;
  final Value<int> attemptCount;
  final Value<DateTime?> completedAt;
  final Value<int?> bestMoveCount;
  final Value<int?> bestDurationMs;
  final Value<int?> bestStars;
  final Value<bool> rewardClaimed;
  final Value<int> xpReward;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyAlchemyRecordsCompanion({
    this.dateKey = const Value.absent(),
    this.sourceLevelIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.bestMoveCount = const Value.absent(),
    this.bestDurationMs = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.rewardClaimed = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyAlchemyRecordsCompanion.insert({
    required String dateKey,
    required int sourceLevelIndex,
    required DailyChallengeStatus status,
    this.attemptCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.bestMoveCount = const Value.absent(),
    this.bestDurationMs = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.rewardClaimed = const Value.absent(),
    this.xpReward = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey),
       sourceLevelIndex = Value(sourceLevelIndex),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyAlchemyRecordData> custom({
    Expression<String>? dateKey,
    Expression<int>? sourceLevelIndex,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<DateTime>? completedAt,
    Expression<int>? bestMoveCount,
    Expression<int>? bestDurationMs,
    Expression<int>? bestStars,
    Expression<bool>? rewardClaimed,
    Expression<int>? xpReward,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (sourceLevelIndex != null) 'source_level_index': sourceLevelIndex,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (completedAt != null) 'completed_at': completedAt,
      if (bestMoveCount != null) 'best_move_count': bestMoveCount,
      if (bestDurationMs != null) 'best_duration_ms': bestDurationMs,
      if (bestStars != null) 'best_stars': bestStars,
      if (rewardClaimed != null) 'reward_claimed': rewardClaimed,
      if (xpReward != null) 'xp_reward': xpReward,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyAlchemyRecordsCompanion copyWith({
    Value<String>? dateKey,
    Value<int>? sourceLevelIndex,
    Value<DailyChallengeStatus>? status,
    Value<int>? attemptCount,
    Value<DateTime?>? completedAt,
    Value<int?>? bestMoveCount,
    Value<int?>? bestDurationMs,
    Value<int?>? bestStars,
    Value<bool>? rewardClaimed,
    Value<int>? xpReward,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyAlchemyRecordsCompanion(
      dateKey: dateKey ?? this.dateKey,
      sourceLevelIndex: sourceLevelIndex ?? this.sourceLevelIndex,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      completedAt: completedAt ?? this.completedAt,
      bestMoveCount: bestMoveCount ?? this.bestMoveCount,
      bestDurationMs: bestDurationMs ?? this.bestDurationMs,
      bestStars: bestStars ?? this.bestStars,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      xpReward: xpReward ?? this.xpReward,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (sourceLevelIndex.present) {
      map['source_level_index'] = Variable<int>(sourceLevelIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DailyAlchemyRecordsTable.$converterstatus.toSql(status.value),
      );
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (bestMoveCount.present) {
      map['best_move_count'] = Variable<int>(bestMoveCount.value);
    }
    if (bestDurationMs.present) {
      map['best_duration_ms'] = Variable<int>(bestDurationMs.value);
    }
    if (bestStars.present) {
      map['best_stars'] = Variable<int>(bestStars.value);
    }
    if (rewardClaimed.present) {
      map['reward_claimed'] = Variable<bool>(rewardClaimed.value);
    }
    if (xpReward.present) {
      map['xp_reward'] = Variable<int>(xpReward.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyAlchemyRecordsCompanion(')
          ..write('dateKey: $dateKey, ')
          ..write('sourceLevelIndex: $sourceLevelIndex, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('bestMoveCount: $bestMoveCount, ')
          ..write('bestDurationMs: $bestDurationMs, ')
          ..write('bestStars: $bestStars, ')
          ..write('rewardClaimed: $rewardClaimed, ')
          ..write('xpReward: $xpReward, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayerProgressTable playerProgress = $PlayerProgressTable(this);
  late final $DiscoveredPotionsTable discoveredPotions =
      $DiscoveredPotionsTable(this);
  late final $GameAnalyticsEventsTable gameAnalyticsEvents =
      $GameAnalyticsEventsTable(this);
  late final $DailyAlchemyRecordsTable dailyAlchemyRecords =
      $DailyAlchemyRecordsTable(this);
  late final Index idxAnalyticsEventType = Index(
    'idx_analytics_event_type',
    'CREATE INDEX idx_analytics_event_type ON game_analytics_events (event_type)',
  );
  late final Index idxAnalyticsLevelNumber = Index(
    'idx_analytics_level_number',
    'CREATE INDEX idx_analytics_level_number ON game_analytics_events (level_number)',
  );
  late final Index idxAnalyticsSessionId = Index(
    'idx_analytics_session_id',
    'CREATE INDEX idx_analytics_session_id ON game_analytics_events (session_id)',
  );
  late final PlayerProgressDao playerProgressDao = PlayerProgressDao(
    this as AppDatabase,
  );
  late final PotionCollectionDao potionCollectionDao = PotionCollectionDao(
    this as AppDatabase,
  );
  late final GameAnalyticsDao gameAnalyticsDao = GameAnalyticsDao(
    this as AppDatabase,
  );
  late final DailyAlchemyDao dailyAlchemyDao = DailyAlchemyDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    playerProgress,
    discoveredPotions,
    gameAnalyticsEvents,
    dailyAlchemyRecords,
    idxAnalyticsEventType,
    idxAnalyticsLevelNumber,
    idxAnalyticsSessionId,
  ];
}

typedef $$PlayerProgressTableCreateCompanionBuilder =
    PlayerProgressCompanion Function({
      Value<int> id,
      Value<int> highestUnlockedLevelIndex,
      Value<int> totalScore,
      Value<int> totalAlchemistXp,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PlayerProgressTableUpdateCompanionBuilder =
    PlayerProgressCompanion Function({
      Value<int> id,
      Value<int> highestUnlockedLevelIndex,
      Value<int> totalScore,
      Value<int> totalAlchemistXp,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PlayerProgressTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerProgressTable> {
  $$PlayerProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highestUnlockedLevelIndex => $composableBuilder(
    column: $table.highestUnlockedLevelIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAlchemistXp => $composableBuilder(
    column: $table.totalAlchemistXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerProgressTable> {
  $$PlayerProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highestUnlockedLevelIndex => $composableBuilder(
    column: $table.highestUnlockedLevelIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAlchemistXp => $composableBuilder(
    column: $table.totalAlchemistXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerProgressTable> {
  $$PlayerProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get highestUnlockedLevelIndex => $composableBuilder(
    column: $table.highestUnlockedLevelIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAlchemistXp => $composableBuilder(
    column: $table.totalAlchemistXp,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlayerProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerProgressTable,
          PlayerProgressData,
          $$PlayerProgressTableFilterComposer,
          $$PlayerProgressTableOrderingComposer,
          $$PlayerProgressTableAnnotationComposer,
          $$PlayerProgressTableCreateCompanionBuilder,
          $$PlayerProgressTableUpdateCompanionBuilder,
          (
            PlayerProgressData,
            BaseReferences<
              _$AppDatabase,
              $PlayerProgressTable,
              PlayerProgressData
            >,
          ),
          PlayerProgressData,
          PrefetchHooks Function()
        > {
  $$PlayerProgressTableTableManager(
    _$AppDatabase db,
    $PlayerProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> highestUnlockedLevelIndex = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> totalAlchemistXp = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PlayerProgressCompanion(
                id: id,
                highestUnlockedLevelIndex: highestUnlockedLevelIndex,
                totalScore: totalScore,
                totalAlchemistXp: totalAlchemistXp,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> highestUnlockedLevelIndex = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> totalAlchemistXp = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PlayerProgressCompanion.insert(
                id: id,
                highestUnlockedLevelIndex: highestUnlockedLevelIndex,
                totalScore: totalScore,
                totalAlchemistXp: totalAlchemistXp,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerProgressTable,
      PlayerProgressData,
      $$PlayerProgressTableFilterComposer,
      $$PlayerProgressTableOrderingComposer,
      $$PlayerProgressTableAnnotationComposer,
      $$PlayerProgressTableCreateCompanionBuilder,
      $$PlayerProgressTableUpdateCompanionBuilder,
      (
        PlayerProgressData,
        BaseReferences<_$AppDatabase, $PlayerProgressTable, PlayerProgressData>,
      ),
      PlayerProgressData,
      PrefetchHooks Function()
    >;
typedef $$DiscoveredPotionsTableCreateCompanionBuilder =
    DiscoveredPotionsCompanion Function({
      required String potionId,
      Value<DateTime> discoveredAt,
      required int discoveredLevelNumber,
      Value<int> rowid,
    });
typedef $$DiscoveredPotionsTableUpdateCompanionBuilder =
    DiscoveredPotionsCompanion Function({
      Value<String> potionId,
      Value<DateTime> discoveredAt,
      Value<int> discoveredLevelNumber,
      Value<int> rowid,
    });

class $$DiscoveredPotionsTableFilterComposer
    extends Composer<_$AppDatabase, $DiscoveredPotionsTable> {
  $$DiscoveredPotionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get potionId => $composableBuilder(
    column: $table.potionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discoveredLevelNumber => $composableBuilder(
    column: $table.discoveredLevelNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiscoveredPotionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscoveredPotionsTable> {
  $$DiscoveredPotionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get potionId => $composableBuilder(
    column: $table.potionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discoveredLevelNumber => $composableBuilder(
    column: $table.discoveredLevelNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiscoveredPotionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscoveredPotionsTable> {
  $$DiscoveredPotionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get potionId =>
      $composableBuilder(column: $table.potionId, builder: (column) => column);

  GeneratedColumn<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discoveredLevelNumber => $composableBuilder(
    column: $table.discoveredLevelNumber,
    builder: (column) => column,
  );
}

class $$DiscoveredPotionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiscoveredPotionsTable,
          DiscoveredPotion,
          $$DiscoveredPotionsTableFilterComposer,
          $$DiscoveredPotionsTableOrderingComposer,
          $$DiscoveredPotionsTableAnnotationComposer,
          $$DiscoveredPotionsTableCreateCompanionBuilder,
          $$DiscoveredPotionsTableUpdateCompanionBuilder,
          (
            DiscoveredPotion,
            BaseReferences<
              _$AppDatabase,
              $DiscoveredPotionsTable,
              DiscoveredPotion
            >,
          ),
          DiscoveredPotion,
          PrefetchHooks Function()
        > {
  $$DiscoveredPotionsTableTableManager(
    _$AppDatabase db,
    $DiscoveredPotionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscoveredPotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscoveredPotionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscoveredPotionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> potionId = const Value.absent(),
                Value<DateTime> discoveredAt = const Value.absent(),
                Value<int> discoveredLevelNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscoveredPotionsCompanion(
                potionId: potionId,
                discoveredAt: discoveredAt,
                discoveredLevelNumber: discoveredLevelNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String potionId,
                Value<DateTime> discoveredAt = const Value.absent(),
                required int discoveredLevelNumber,
                Value<int> rowid = const Value.absent(),
              }) => DiscoveredPotionsCompanion.insert(
                potionId: potionId,
                discoveredAt: discoveredAt,
                discoveredLevelNumber: discoveredLevelNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiscoveredPotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiscoveredPotionsTable,
      DiscoveredPotion,
      $$DiscoveredPotionsTableFilterComposer,
      $$DiscoveredPotionsTableOrderingComposer,
      $$DiscoveredPotionsTableAnnotationComposer,
      $$DiscoveredPotionsTableCreateCompanionBuilder,
      $$DiscoveredPotionsTableUpdateCompanionBuilder,
      (
        DiscoveredPotion,
        BaseReferences<
          _$AppDatabase,
          $DiscoveredPotionsTable,
          DiscoveredPotion
        >,
      ),
      DiscoveredPotion,
      PrefetchHooks Function()
    >;
typedef $$GameAnalyticsEventsTableCreateCompanionBuilder =
    GameAnalyticsEventsCompanion Function({
      Value<int> id,
      required String sessionId,
      required int eventType,
      required int levelIndex,
      required int levelNumber,
      required DateTime eventTimestamp,
      Value<int?> moveCount,
      Value<int?> undoCount,
      Value<int?> restartCount,
      Value<int?> durationMs,
      Value<int?> stars,
      Value<int?> highestCombo,
      Value<String?> potionId,
      Value<String?> metadataJson,
    });
typedef $$GameAnalyticsEventsTableUpdateCompanionBuilder =
    GameAnalyticsEventsCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<int> eventType,
      Value<int> levelIndex,
      Value<int> levelNumber,
      Value<DateTime> eventTimestamp,
      Value<int?> moveCount,
      Value<int?> undoCount,
      Value<int?> restartCount,
      Value<int?> durationMs,
      Value<int?> stars,
      Value<int?> highestCombo,
      Value<String?> potionId,
      Value<String?> metadataJson,
    });

class $$GameAnalyticsEventsTableFilterComposer
    extends Composer<_$AppDatabase, $GameAnalyticsEventsTable> {
  $$GameAnalyticsEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelIndex => $composableBuilder(
    column: $table.levelIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moveCount => $composableBuilder(
    column: $table.moveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get undoCount => $composableBuilder(
    column: $table.undoCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restartCount => $composableBuilder(
    column: $table.restartCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highestCombo => $composableBuilder(
    column: $table.highestCombo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get potionId => $composableBuilder(
    column: $table.potionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameAnalyticsEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameAnalyticsEventsTable> {
  $$GameAnalyticsEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelIndex => $composableBuilder(
    column: $table.levelIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moveCount => $composableBuilder(
    column: $table.moveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get undoCount => $composableBuilder(
    column: $table.undoCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restartCount => $composableBuilder(
    column: $table.restartCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highestCombo => $composableBuilder(
    column: $table.highestCombo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get potionId => $composableBuilder(
    column: $table.potionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameAnalyticsEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameAnalyticsEventsTable> {
  $$GameAnalyticsEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get levelIndex => $composableBuilder(
    column: $table.levelIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get moveCount =>
      $composableBuilder(column: $table.moveCount, builder: (column) => column);

  GeneratedColumn<int> get undoCount =>
      $composableBuilder(column: $table.undoCount, builder: (column) => column);

  GeneratedColumn<int> get restartCount => $composableBuilder(
    column: $table.restartCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get highestCombo => $composableBuilder(
    column: $table.highestCombo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get potionId =>
      $composableBuilder(column: $table.potionId, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );
}

class $$GameAnalyticsEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameAnalyticsEventsTable,
          GameAnalyticsEvent,
          $$GameAnalyticsEventsTableFilterComposer,
          $$GameAnalyticsEventsTableOrderingComposer,
          $$GameAnalyticsEventsTableAnnotationComposer,
          $$GameAnalyticsEventsTableCreateCompanionBuilder,
          $$GameAnalyticsEventsTableUpdateCompanionBuilder,
          (
            GameAnalyticsEvent,
            BaseReferences<
              _$AppDatabase,
              $GameAnalyticsEventsTable,
              GameAnalyticsEvent
            >,
          ),
          GameAnalyticsEvent,
          PrefetchHooks Function()
        > {
  $$GameAnalyticsEventsTableTableManager(
    _$AppDatabase db,
    $GameAnalyticsEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameAnalyticsEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameAnalyticsEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GameAnalyticsEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> eventType = const Value.absent(),
                Value<int> levelIndex = const Value.absent(),
                Value<int> levelNumber = const Value.absent(),
                Value<DateTime> eventTimestamp = const Value.absent(),
                Value<int?> moveCount = const Value.absent(),
                Value<int?> undoCount = const Value.absent(),
                Value<int?> restartCount = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> stars = const Value.absent(),
                Value<int?> highestCombo = const Value.absent(),
                Value<String?> potionId = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
              }) => GameAnalyticsEventsCompanion(
                id: id,
                sessionId: sessionId,
                eventType: eventType,
                levelIndex: levelIndex,
                levelNumber: levelNumber,
                eventTimestamp: eventTimestamp,
                moveCount: moveCount,
                undoCount: undoCount,
                restartCount: restartCount,
                durationMs: durationMs,
                stars: stars,
                highestCombo: highestCombo,
                potionId: potionId,
                metadataJson: metadataJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required int eventType,
                required int levelIndex,
                required int levelNumber,
                required DateTime eventTimestamp,
                Value<int?> moveCount = const Value.absent(),
                Value<int?> undoCount = const Value.absent(),
                Value<int?> restartCount = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> stars = const Value.absent(),
                Value<int?> highestCombo = const Value.absent(),
                Value<String?> potionId = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
              }) => GameAnalyticsEventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                eventType: eventType,
                levelIndex: levelIndex,
                levelNumber: levelNumber,
                eventTimestamp: eventTimestamp,
                moveCount: moveCount,
                undoCount: undoCount,
                restartCount: restartCount,
                durationMs: durationMs,
                stars: stars,
                highestCombo: highestCombo,
                potionId: potionId,
                metadataJson: metadataJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameAnalyticsEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameAnalyticsEventsTable,
      GameAnalyticsEvent,
      $$GameAnalyticsEventsTableFilterComposer,
      $$GameAnalyticsEventsTableOrderingComposer,
      $$GameAnalyticsEventsTableAnnotationComposer,
      $$GameAnalyticsEventsTableCreateCompanionBuilder,
      $$GameAnalyticsEventsTableUpdateCompanionBuilder,
      (
        GameAnalyticsEvent,
        BaseReferences<
          _$AppDatabase,
          $GameAnalyticsEventsTable,
          GameAnalyticsEvent
        >,
      ),
      GameAnalyticsEvent,
      PrefetchHooks Function()
    >;
typedef $$DailyAlchemyRecordsTableCreateCompanionBuilder =
    DailyAlchemyRecordsCompanion Function({
      required String dateKey,
      required int sourceLevelIndex,
      required DailyChallengeStatus status,
      Value<int> attemptCount,
      Value<DateTime?> completedAt,
      Value<int?> bestMoveCount,
      Value<int?> bestDurationMs,
      Value<int?> bestStars,
      Value<bool> rewardClaimed,
      Value<int> xpReward,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyAlchemyRecordsTableUpdateCompanionBuilder =
    DailyAlchemyRecordsCompanion Function({
      Value<String> dateKey,
      Value<int> sourceLevelIndex,
      Value<DailyChallengeStatus> status,
      Value<int> attemptCount,
      Value<DateTime?> completedAt,
      Value<int?> bestMoveCount,
      Value<int?> bestDurationMs,
      Value<int?> bestStars,
      Value<bool> rewardClaimed,
      Value<int> xpReward,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyAlchemyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyAlchemyRecordsTable> {
  $$DailyAlchemyRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceLevelIndex => $composableBuilder(
    column: $table.sourceLevelIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    DailyChallengeStatus,
    DailyChallengeStatus,
    String
  >
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestMoveCount => $composableBuilder(
    column: $table.bestMoveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestDurationMs => $composableBuilder(
    column: $table.bestDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpReward => $composableBuilder(
    column: $table.xpReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyAlchemyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyAlchemyRecordsTable> {
  $$DailyAlchemyRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceLevelIndex => $composableBuilder(
    column: $table.sourceLevelIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestMoveCount => $composableBuilder(
    column: $table.bestMoveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestDurationMs => $composableBuilder(
    column: $table.bestDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpReward => $composableBuilder(
    column: $table.xpReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyAlchemyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyAlchemyRecordsTable> {
  $$DailyAlchemyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get sourceLevelIndex => $composableBuilder(
    column: $table.sourceLevelIndex,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DailyChallengeStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestMoveCount => $composableBuilder(
    column: $table.bestMoveCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestDurationMs => $composableBuilder(
    column: $table.bestDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestStars =>
      $composableBuilder(column: $table.bestStars, builder: (column) => column);

  GeneratedColumn<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpReward =>
      $composableBuilder(column: $table.xpReward, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyAlchemyRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyAlchemyRecordsTable,
          DailyAlchemyRecordData,
          $$DailyAlchemyRecordsTableFilterComposer,
          $$DailyAlchemyRecordsTableOrderingComposer,
          $$DailyAlchemyRecordsTableAnnotationComposer,
          $$DailyAlchemyRecordsTableCreateCompanionBuilder,
          $$DailyAlchemyRecordsTableUpdateCompanionBuilder,
          (
            DailyAlchemyRecordData,
            BaseReferences<
              _$AppDatabase,
              $DailyAlchemyRecordsTable,
              DailyAlchemyRecordData
            >,
          ),
          DailyAlchemyRecordData,
          PrefetchHooks Function()
        > {
  $$DailyAlchemyRecordsTableTableManager(
    _$AppDatabase db,
    $DailyAlchemyRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyAlchemyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyAlchemyRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyAlchemyRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> dateKey = const Value.absent(),
                Value<int> sourceLevelIndex = const Value.absent(),
                Value<DailyChallengeStatus> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> bestMoveCount = const Value.absent(),
                Value<int?> bestDurationMs = const Value.absent(),
                Value<int?> bestStars = const Value.absent(),
                Value<bool> rewardClaimed = const Value.absent(),
                Value<int> xpReward = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyAlchemyRecordsCompanion(
                dateKey: dateKey,
                sourceLevelIndex: sourceLevelIndex,
                status: status,
                attemptCount: attemptCount,
                completedAt: completedAt,
                bestMoveCount: bestMoveCount,
                bestDurationMs: bestDurationMs,
                bestStars: bestStars,
                rewardClaimed: rewardClaimed,
                xpReward: xpReward,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                required int sourceLevelIndex,
                required DailyChallengeStatus status,
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> bestMoveCount = const Value.absent(),
                Value<int?> bestDurationMs = const Value.absent(),
                Value<int?> bestStars = const Value.absent(),
                Value<bool> rewardClaimed = const Value.absent(),
                Value<int> xpReward = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyAlchemyRecordsCompanion.insert(
                dateKey: dateKey,
                sourceLevelIndex: sourceLevelIndex,
                status: status,
                attemptCount: attemptCount,
                completedAt: completedAt,
                bestMoveCount: bestMoveCount,
                bestDurationMs: bestDurationMs,
                bestStars: bestStars,
                rewardClaimed: rewardClaimed,
                xpReward: xpReward,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyAlchemyRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyAlchemyRecordsTable,
      DailyAlchemyRecordData,
      $$DailyAlchemyRecordsTableFilterComposer,
      $$DailyAlchemyRecordsTableOrderingComposer,
      $$DailyAlchemyRecordsTableAnnotationComposer,
      $$DailyAlchemyRecordsTableCreateCompanionBuilder,
      $$DailyAlchemyRecordsTableUpdateCompanionBuilder,
      (
        DailyAlchemyRecordData,
        BaseReferences<
          _$AppDatabase,
          $DailyAlchemyRecordsTable,
          DailyAlchemyRecordData
        >,
      ),
      DailyAlchemyRecordData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayerProgressTableTableManager get playerProgress =>
      $$PlayerProgressTableTableManager(_db, _db.playerProgress);
  $$DiscoveredPotionsTableTableManager get discoveredPotions =>
      $$DiscoveredPotionsTableTableManager(_db, _db.discoveredPotions);
  $$GameAnalyticsEventsTableTableManager get gameAnalyticsEvents =>
      $$GameAnalyticsEventsTableTableManager(_db, _db.gameAnalyticsEvents);
  $$DailyAlchemyRecordsTableTableManager get dailyAlchemyRecords =>
      $$DailyAlchemyRecordsTableTableManager(_db, _db.dailyAlchemyRecords);
}
