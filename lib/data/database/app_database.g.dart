// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MediaTable extends Media with TableInfo<$MediaTable, MediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<MediaType, String> mediaType =
      GeneratedColumn<String>(
        'media_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaType>($MediaTable.$convertermediaType);
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
  List<GeneratedColumn> get $columns => [id, mediaType, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mediaType: $MediaTable.$convertermediaType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}media_type'],
        )!,
      ),
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
  $MediaTable createAlias(String alias) {
    return $MediaTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaType, String, String> $convertermediaType =
      const EnumNameConverter<MediaType>(MediaType.values);
}

class MediaData extends DataClass implements Insertable<MediaData> {
  final int id;
  final MediaType mediaType;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MediaData({
    required this.id,
    required this.mediaType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['media_type'] = Variable<String>(
        $MediaTable.$convertermediaType.toSql(mediaType),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaCompanion toCompanion(bool nullToAbsent) {
    return MediaCompanion(
      id: Value(id),
      mediaType: Value(mediaType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaData(
      id: serializer.fromJson<int>(json['id']),
      mediaType: $MediaTable.$convertermediaType.fromJson(
        serializer.fromJson<String>(json['mediaType']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mediaType': serializer.toJson<String>(
        $MediaTable.$convertermediaType.toJson(mediaType),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaData copyWith({
    int? id,
    MediaType? mediaType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MediaData(
    id: id ?? this.id,
    mediaType: mediaType ?? this.mediaType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaData copyWithCompanion(MediaCompanion data) {
    return MediaData(
      id: data.id.present ? data.id.value : this.id,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaData(')
          ..write('id: $id, ')
          ..write('mediaType: $mediaType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mediaType, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaData &&
          other.id == this.id &&
          other.mediaType == this.mediaType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MediaCompanion extends UpdateCompanion<MediaData> {
  final Value<int> id;
  final Value<MediaType> mediaType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MediaCompanion({
    this.id = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MediaCompanion.insert({
    this.id = const Value.absent(),
    required MediaType mediaType,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : mediaType = Value(mediaType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MediaData> custom({
    Expression<int>? id,
    Expression<String>? mediaType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mediaType != null) 'media_type': mediaType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MediaCompanion copyWith({
    Value<int>? id,
    Value<MediaType>? mediaType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MediaCompanion(
      id: id ?? this.id,
      mediaType: mediaType ?? this.mediaType,
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
    if (mediaType.present) {
      map['media_type'] = Variable<String>(
        $MediaTable.$convertermediaType.toSql(mediaType.value),
      );
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
    return (StringBuffer('MediaCompanion(')
          ..write('id: $id, ')
          ..write('mediaType: $mediaType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MediaMetadataTable extends MediaMetadata
    with TableInfo<$MediaMetadataTable, MediaMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateOnly?, String> releaseDate =
      GeneratedColumn<String>(
        'release_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateOnly?>($MediaMetadataTable.$converterreleaseDaten);
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
    mediaId,
    title,
    description,
    coverUrl,
    releaseDate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MediaMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaMetadataData(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      releaseDate: $MediaMetadataTable.$converterreleaseDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}release_date'],
        ),
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MediaMetadataTable createAlias(String alias) {
    return $MediaMetadataTable(attachedDatabase, alias);
  }

  static TypeConverter<DateOnly, String> $converterreleaseDate =
      const DateOnlyConverter();
  static TypeConverter<DateOnly?, String?> $converterreleaseDaten =
      NullAwareTypeConverter.wrap($converterreleaseDate);
}

class MediaMetadataData extends DataClass
    implements Insertable<MediaMetadataData> {
  final int mediaId;
  final String title;
  final String? description;
  final String? coverUrl;
  final DateOnly? releaseDate;
  final DateTime updatedAt;
  const MediaMetadataData({
    required this.mediaId,
    required this.title,
    this.description,
    this.coverUrl,
    this.releaseDate,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<String>(
        $MediaMetadataTable.$converterreleaseDaten.toSql(releaseDate),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaMetadataCompanion toCompanion(bool nullToAbsent) {
    return MediaMetadataCompanion(
      mediaId: Value(mediaId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaMetadataData(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      releaseDate: serializer.fromJson<DateOnly?>(json['releaseDate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'releaseDate': serializer.toJson<DateOnly?>(releaseDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaMetadataData copyWith({
    int? mediaId,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<DateOnly?> releaseDate = const Value.absent(),
    DateTime? updatedAt,
  }) => MediaMetadataData(
    mediaId: mediaId ?? this.mediaId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaMetadataData copyWithCompanion(MediaMetadataCompanion data) {
    return MediaMetadataData(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaMetadataData(')
          ..write('mediaId: $mediaId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaId,
    title,
    description,
    coverUrl,
    releaseDate,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaMetadataData &&
          other.mediaId == this.mediaId &&
          other.title == this.title &&
          other.description == this.description &&
          other.coverUrl == this.coverUrl &&
          other.releaseDate == this.releaseDate &&
          other.updatedAt == this.updatedAt);
}

class MediaMetadataCompanion extends UpdateCompanion<MediaMetadataData> {
  final Value<int> mediaId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> coverUrl;
  final Value<DateOnly?> releaseDate;
  final Value<DateTime> updatedAt;
  const MediaMetadataCompanion({
    this.mediaId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MediaMetadataCompanion.insert({
    this.mediaId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.releaseDate = const Value.absent(),
    required DateTime updatedAt,
  }) : title = Value(title),
       updatedAt = Value(updatedAt);
  static Insertable<MediaMetadataData> custom({
    Expression<int>? mediaId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? coverUrl,
    Expression<String>? releaseDate,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (releaseDate != null) 'release_date': releaseDate,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MediaMetadataCompanion copyWith({
    Value<int>? mediaId,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? coverUrl,
    Value<DateOnly?>? releaseDate,
    Value<DateTime>? updatedAt,
  }) {
    return MediaMetadataCompanion(
      mediaId: mediaId ?? this.mediaId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(
        $MediaMetadataTable.$converterreleaseDaten.toSql(releaseDate.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaMetadataCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MediaUserDataTable extends MediaUserData
    with TableInfo<$MediaUserDataTable, MediaUserDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaUserDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaStatus>($MediaUserDataTable.$converterstatus);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(0, 100),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateOnly?, String> startedOn =
      GeneratedColumn<String>(
        'started_on',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateOnly?>($MediaUserDataTable.$converterstartedOnn);
  @override
  late final GeneratedColumnWithTypeConverter<DateOnly?, String> finishedOn =
      GeneratedColumn<String>(
        'finished_on',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateOnly?>($MediaUserDataTable.$converterfinishedOnn);
  static const VerificationMeta _reviewMeta = const VerificationMeta('review');
  @override
  late final GeneratedColumn<String> review = GeneratedColumn<String>(
    'review',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    mediaId,
    status,
    rating,
    startedOn,
    finishedOn,
    review,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_user_data';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaUserDataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('review')) {
      context.handle(
        _reviewMeta,
        review.isAcceptableOrUnknown(data['review']!, _reviewMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MediaUserDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaUserDataData(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      status: $MediaUserDataTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      startedOn: $MediaUserDataTable.$converterstartedOnn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}started_on'],
        ),
      ),
      finishedOn: $MediaUserDataTable.$converterfinishedOnn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}finished_on'],
        ),
      ),
      review: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MediaUserDataTable createAlias(String alias) {
    return $MediaUserDataTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaStatus, String, String> $converterstatus =
      const EnumNameConverter<MediaStatus>(MediaStatus.values);
  static TypeConverter<DateOnly, String> $converterstartedOn =
      const DateOnlyConverter();
  static TypeConverter<DateOnly?, String?> $converterstartedOnn =
      NullAwareTypeConverter.wrap($converterstartedOn);
  static TypeConverter<DateOnly, String> $converterfinishedOn =
      const DateOnlyConverter();
  static TypeConverter<DateOnly?, String?> $converterfinishedOnn =
      NullAwareTypeConverter.wrap($converterfinishedOn);
}

class MediaUserDataData extends DataClass
    implements Insertable<MediaUserDataData> {
  final int mediaId;
  final MediaStatus status;
  final int? rating;
  final DateOnly? startedOn;
  final DateOnly? finishedOn;
  final String? review;
  final DateTime updatedAt;
  const MediaUserDataData({
    required this.mediaId,
    required this.status,
    this.rating,
    this.startedOn,
    this.finishedOn,
    this.review,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    {
      map['status'] = Variable<String>(
        $MediaUserDataTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || startedOn != null) {
      map['started_on'] = Variable<String>(
        $MediaUserDataTable.$converterstartedOnn.toSql(startedOn),
      );
    }
    if (!nullToAbsent || finishedOn != null) {
      map['finished_on'] = Variable<String>(
        $MediaUserDataTable.$converterfinishedOnn.toSql(finishedOn),
      );
    }
    if (!nullToAbsent || review != null) {
      map['review'] = Variable<String>(review);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaUserDataCompanion toCompanion(bool nullToAbsent) {
    return MediaUserDataCompanion(
      mediaId: Value(mediaId),
      status: Value(status),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      startedOn: startedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(startedOn),
      finishedOn: finishedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedOn),
      review: review == null && nullToAbsent
          ? const Value.absent()
          : Value(review),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaUserDataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaUserDataData(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      status: $MediaUserDataTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      rating: serializer.fromJson<int?>(json['rating']),
      startedOn: serializer.fromJson<DateOnly?>(json['startedOn']),
      finishedOn: serializer.fromJson<DateOnly?>(json['finishedOn']),
      review: serializer.fromJson<String?>(json['review']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'status': serializer.toJson<String>(
        $MediaUserDataTable.$converterstatus.toJson(status),
      ),
      'rating': serializer.toJson<int?>(rating),
      'startedOn': serializer.toJson<DateOnly?>(startedOn),
      'finishedOn': serializer.toJson<DateOnly?>(finishedOn),
      'review': serializer.toJson<String?>(review),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaUserDataData copyWith({
    int? mediaId,
    MediaStatus? status,
    Value<int?> rating = const Value.absent(),
    Value<DateOnly?> startedOn = const Value.absent(),
    Value<DateOnly?> finishedOn = const Value.absent(),
    Value<String?> review = const Value.absent(),
    DateTime? updatedAt,
  }) => MediaUserDataData(
    mediaId: mediaId ?? this.mediaId,
    status: status ?? this.status,
    rating: rating.present ? rating.value : this.rating,
    startedOn: startedOn.present ? startedOn.value : this.startedOn,
    finishedOn: finishedOn.present ? finishedOn.value : this.finishedOn,
    review: review.present ? review.value : this.review,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaUserDataData copyWithCompanion(MediaUserDataCompanion data) {
    return MediaUserDataData(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      status: data.status.present ? data.status.value : this.status,
      rating: data.rating.present ? data.rating.value : this.rating,
      startedOn: data.startedOn.present ? data.startedOn.value : this.startedOn,
      finishedOn: data.finishedOn.present
          ? data.finishedOn.value
          : this.finishedOn,
      review: data.review.present ? data.review.value : this.review,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaUserDataData(')
          ..write('mediaId: $mediaId, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('startedOn: $startedOn, ')
          ..write('finishedOn: $finishedOn, ')
          ..write('review: $review, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaId,
    status,
    rating,
    startedOn,
    finishedOn,
    review,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaUserDataData &&
          other.mediaId == this.mediaId &&
          other.status == this.status &&
          other.rating == this.rating &&
          other.startedOn == this.startedOn &&
          other.finishedOn == this.finishedOn &&
          other.review == this.review &&
          other.updatedAt == this.updatedAt);
}

class MediaUserDataCompanion extends UpdateCompanion<MediaUserDataData> {
  final Value<int> mediaId;
  final Value<MediaStatus> status;
  final Value<int?> rating;
  final Value<DateOnly?> startedOn;
  final Value<DateOnly?> finishedOn;
  final Value<String?> review;
  final Value<DateTime> updatedAt;
  const MediaUserDataCompanion({
    this.mediaId = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.finishedOn = const Value.absent(),
    this.review = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MediaUserDataCompanion.insert({
    this.mediaId = const Value.absent(),
    required MediaStatus status,
    this.rating = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.finishedOn = const Value.absent(),
    this.review = const Value.absent(),
    required DateTime updatedAt,
  }) : status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<MediaUserDataData> custom({
    Expression<int>? mediaId,
    Expression<String>? status,
    Expression<int>? rating,
    Expression<String>? startedOn,
    Expression<String>? finishedOn,
    Expression<String>? review,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (status != null) 'status': status,
      if (rating != null) 'rating': rating,
      if (startedOn != null) 'started_on': startedOn,
      if (finishedOn != null) 'finished_on': finishedOn,
      if (review != null) 'review': review,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MediaUserDataCompanion copyWith({
    Value<int>? mediaId,
    Value<MediaStatus>? status,
    Value<int?>? rating,
    Value<DateOnly?>? startedOn,
    Value<DateOnly?>? finishedOn,
    Value<String?>? review,
    Value<DateTime>? updatedAt,
  }) {
    return MediaUserDataCompanion(
      mediaId: mediaId ?? this.mediaId,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      startedOn: startedOn ?? this.startedOn,
      finishedOn: finishedOn ?? this.finishedOn,
      review: review ?? this.review,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $MediaUserDataTable.$converterstatus.toSql(status.value),
      );
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (startedOn.present) {
      map['started_on'] = Variable<String>(
        $MediaUserDataTable.$converterstartedOnn.toSql(startedOn.value),
      );
    }
    if (finishedOn.present) {
      map['finished_on'] = Variable<String>(
        $MediaUserDataTable.$converterfinishedOnn.toSql(finishedOn.value),
      );
    }
    if (review.present) {
      map['review'] = Variable<String>(review.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaUserDataCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('startedOn: $startedOn, ')
          ..write('finishedOn: $finishedOn, ')
          ..write('review: $review, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GenresTable extends Genres with TableInfo<$GenresTable, Genre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GenresTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'genres';
  @override
  VerificationContext validateIntegrity(
    Insertable<Genre> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Genre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Genre(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $GenresTable createAlias(String alias) {
    return $GenresTable(attachedDatabase, alias);
  }
}

class Genre extends DataClass implements Insertable<Genre> {
  final int id;
  final String name;
  const Genre({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  GenresCompanion toCompanion(bool nullToAbsent) {
    return GenresCompanion(id: Value(id), name: Value(name));
  }

  factory Genre.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Genre(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Genre copyWith({int? id, String? name}) =>
      Genre(id: id ?? this.id, name: name ?? this.name);
  Genre copyWithCompanion(GenresCompanion data) {
    return Genre(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Genre(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Genre && other.id == this.id && other.name == this.name);
}

class GenresCompanion extends UpdateCompanion<Genre> {
  final Value<int> id;
  final Value<String> name;
  const GenresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GenresCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Genre> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GenresCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return GenresCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GenresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $MediaGenresTable extends MediaGenres
    with TableInfo<$MediaGenresTable, MediaGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _genreIdMeta = const VerificationMeta(
    'genreId',
  );
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
    'genre_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES genres (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId, genreId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_genres';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaGenre> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(
        _genreIdMeta,
        genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta),
      );
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, genreId};
  @override
  MediaGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaGenre(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      genreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}genre_id'],
      )!,
    );
  }

  @override
  $MediaGenresTable createAlias(String alias) {
    return $MediaGenresTable(attachedDatabase, alias);
  }
}

class MediaGenre extends DataClass implements Insertable<MediaGenre> {
  final int mediaId;
  final int genreId;
  const MediaGenre({required this.mediaId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  MediaGenresCompanion toCompanion(bool nullToAbsent) {
    return MediaGenresCompanion(
      mediaId: Value(mediaId),
      genreId: Value(genreId),
    );
  }

  factory MediaGenre.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaGenre(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  MediaGenre copyWith({int? mediaId, int? genreId}) => MediaGenre(
    mediaId: mediaId ?? this.mediaId,
    genreId: genreId ?? this.genreId,
  );
  MediaGenre copyWithCompanion(MediaGenresCompanion data) {
    return MediaGenre(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      genreId: data.genreId.present ? data.genreId.value : this.genreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaGenre(')
          ..write('mediaId: $mediaId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaGenre &&
          other.mediaId == this.mediaId &&
          other.genreId == this.genreId);
}

class MediaGenresCompanion extends UpdateCompanion<MediaGenre> {
  final Value<int> mediaId;
  final Value<int> genreId;
  final Value<int> rowid;
  const MediaGenresCompanion({
    this.mediaId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaGenresCompanion.insert({
    required int mediaId,
    required int genreId,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       genreId = Value(genreId);
  static Insertable<MediaGenre> custom({
    Expression<int>? mediaId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaGenresCompanion copyWith({
    Value<int>? mediaId,
    Value<int>? genreId,
    Value<int>? rowid,
  }) {
    return MediaGenresCompanion(
      mediaId: mediaId ?? this.mediaId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaGenresCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExternalIdsTable extends ExternalIds
    with TableInfo<$ExternalIdsTable, ExternalId> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExternalIdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId, source, externalId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'external_ids';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExternalId> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, source};
  @override
  ExternalId map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExternalId(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
    );
  }

  @override
  $ExternalIdsTable createAlias(String alias) {
    return $ExternalIdsTable(attachedDatabase, alias);
  }
}

class ExternalId extends DataClass implements Insertable<ExternalId> {
  final int mediaId;
  final String source;
  final String externalId;
  const ExternalId({
    required this.mediaId,
    required this.source,
    required this.externalId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['source'] = Variable<String>(source);
    map['external_id'] = Variable<String>(externalId);
    return map;
  }

  ExternalIdsCompanion toCompanion(bool nullToAbsent) {
    return ExternalIdsCompanion(
      mediaId: Value(mediaId),
      source: Value(source),
      externalId: Value(externalId),
    );
  }

  factory ExternalId.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExternalId(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String>(json['externalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String>(externalId),
    };
  }

  ExternalId copyWith({int? mediaId, String? source, String? externalId}) =>
      ExternalId(
        mediaId: mediaId ?? this.mediaId,
        source: source ?? this.source,
        externalId: externalId ?? this.externalId,
      );
  ExternalId copyWithCompanion(ExternalIdsCompanion data) {
    return ExternalId(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExternalId(')
          ..write('mediaId: $mediaId, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, source, externalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExternalId &&
          other.mediaId == this.mediaId &&
          other.source == this.source &&
          other.externalId == this.externalId);
}

class ExternalIdsCompanion extends UpdateCompanion<ExternalId> {
  final Value<int> mediaId;
  final Value<String> source;
  final Value<String> externalId;
  final Value<int> rowid;
  const ExternalIdsCompanion({
    this.mediaId = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExternalIdsCompanion.insert({
    required int mediaId,
    required String source,
    required String externalId,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       source = Value(source),
       externalId = Value(externalId);
  static Insertable<ExternalId> custom({
    Expression<int>? mediaId,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExternalIdsCompanion copyWith({
    Value<int>? mediaId,
    Value<String>? source,
    Value<String>? externalId,
    Value<int>? rowid,
  }) {
    return ExternalIdsCompanion(
      mediaId: mediaId ?? this.mediaId,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExternalIdsCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({int? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $MediaTagsTable extends MediaTags
    with TableInfo<$MediaTagsTable, MediaTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, tagId};
  @override
  MediaTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaTag(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $MediaTagsTable createAlias(String alias) {
    return $MediaTagsTable(attachedDatabase, alias);
  }
}

class MediaTag extends DataClass implements Insertable<MediaTag> {
  final int mediaId;
  final int tagId;
  const MediaTag({required this.mediaId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  MediaTagsCompanion toCompanion(bool nullToAbsent) {
    return MediaTagsCompanion(mediaId: Value(mediaId), tagId: Value(tagId));
  }

  factory MediaTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaTag(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  MediaTag copyWith({int? mediaId, int? tagId}) =>
      MediaTag(mediaId: mediaId ?? this.mediaId, tagId: tagId ?? this.tagId);
  MediaTag copyWithCompanion(MediaTagsCompanion data) {
    return MediaTag(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaTag(')
          ..write('mediaId: $mediaId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaTag &&
          other.mediaId == this.mediaId &&
          other.tagId == this.tagId);
}

class MediaTagsCompanion extends UpdateCompanion<MediaTag> {
  final Value<int> mediaId;
  final Value<int> tagId;
  final Value<int> rowid;
  const MediaTagsCompanion({
    this.mediaId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaTagsCompanion.insert({
    required int mediaId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       tagId = Value(tagId);
  static Insertable<MediaTag> custom({
    Expression<int>? mediaId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaTagsCompanion copyWith({
    Value<int>? mediaId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return MediaTagsCompanion(
      mediaId: mediaId ?? this.mediaId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaTagsCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final int mediaId;
  const Game({required this.mediaId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(mediaId: Value(mediaId));
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(mediaId: serializer.fromJson<int>(json['mediaId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'mediaId': serializer.toJson<int>(mediaId)};
  }

  Game copyWith({int? mediaId}) => Game(mediaId: mediaId ?? this.mediaId);
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('mediaId: $mediaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => mediaId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game && other.mediaId == this.mediaId);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> mediaId;
  const GamesCompanion({this.mediaId = const Value.absent()});
  GamesCompanion.insert({this.mediaId = const Value.absent()});
  static Insertable<Game> custom({Expression<int>? mediaId}) {
    return RawValuesInsertable({if (mediaId != null) 'media_id': mediaId});
  }

  GamesCompanion copyWith({Value<int>? mediaId}) {
    return GamesCompanion(mediaId: mediaId ?? this.mediaId);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('mediaId: $mediaId')
          ..write(')'))
        .toString();
  }
}

class $GameAvailableModesTable extends GameAvailableModes
    with TableInfo<$GameAvailableModesTable, GameAvailableMode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameAvailableModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (media_id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GameMode>($GameAvailableModesTable.$convertermode);
  @override
  List<GeneratedColumn> get $columns => [mediaId, mode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_available_modes';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameAvailableMode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, mode};
  @override
  GameAvailableMode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameAvailableMode(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      mode: $GameAvailableModesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
    );
  }

  @override
  $GameAvailableModesTable createAlias(String alias) {
    return $GameAvailableModesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameMode, String, String> $convertermode =
      const EnumNameConverter<GameMode>(GameMode.values);
}

class GameAvailableMode extends DataClass
    implements Insertable<GameAvailableMode> {
  final int mediaId;
  final GameMode mode;
  const GameAvailableMode({required this.mediaId, required this.mode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    {
      map['mode'] = Variable<String>(
        $GameAvailableModesTable.$convertermode.toSql(mode),
      );
    }
    return map;
  }

  GameAvailableModesCompanion toCompanion(bool nullToAbsent) {
    return GameAvailableModesCompanion(
      mediaId: Value(mediaId),
      mode: Value(mode),
    );
  }

  factory GameAvailableMode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameAvailableMode(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      mode: $GameAvailableModesTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'mode': serializer.toJson<String>(
        $GameAvailableModesTable.$convertermode.toJson(mode),
      ),
    };
  }

  GameAvailableMode copyWith({int? mediaId, GameMode? mode}) =>
      GameAvailableMode(
        mediaId: mediaId ?? this.mediaId,
        mode: mode ?? this.mode,
      );
  GameAvailableMode copyWithCompanion(GameAvailableModesCompanion data) {
    return GameAvailableMode(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      mode: data.mode.present ? data.mode.value : this.mode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameAvailableMode(')
          ..write('mediaId: $mediaId, ')
          ..write('mode: $mode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, mode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameAvailableMode &&
          other.mediaId == this.mediaId &&
          other.mode == this.mode);
}

class GameAvailableModesCompanion extends UpdateCompanion<GameAvailableMode> {
  final Value<int> mediaId;
  final Value<GameMode> mode;
  final Value<int> rowid;
  const GameAvailableModesCompanion({
    this.mediaId = const Value.absent(),
    this.mode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameAvailableModesCompanion.insert({
    required int mediaId,
    required GameMode mode,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       mode = Value(mode);
  static Insertable<GameAvailableMode> custom({
    Expression<int>? mediaId,
    Expression<String>? mode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (mode != null) 'mode': mode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameAvailableModesCompanion copyWith({
    Value<int>? mediaId,
    Value<GameMode>? mode,
    Value<int>? rowid,
  }) {
    return GameAvailableModesCompanion(
      mediaId: mediaId ?? this.mediaId,
      mode: mode ?? this.mode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $GameAvailableModesTable.$convertermode.toSql(mode.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameAvailableModesCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('mode: $mode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamePlayedModesTable extends GamePlayedModes
    with TableInfo<$GamePlayedModesTable, GamePlayedMode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamePlayedModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (media_id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GameMode>($GamePlayedModesTable.$convertermode);
  @override
  List<GeneratedColumn> get $columns => [mediaId, mode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_played_modes';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamePlayedMode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, mode};
  @override
  GamePlayedMode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamePlayedMode(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      mode: $GamePlayedModesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
    );
  }

  @override
  $GamePlayedModesTable createAlias(String alias) {
    return $GamePlayedModesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameMode, String, String> $convertermode =
      const EnumNameConverter<GameMode>(GameMode.values);
}

class GamePlayedMode extends DataClass implements Insertable<GamePlayedMode> {
  final int mediaId;
  final GameMode mode;
  const GamePlayedMode({required this.mediaId, required this.mode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    {
      map['mode'] = Variable<String>(
        $GamePlayedModesTable.$convertermode.toSql(mode),
      );
    }
    return map;
  }

  GamePlayedModesCompanion toCompanion(bool nullToAbsent) {
    return GamePlayedModesCompanion(mediaId: Value(mediaId), mode: Value(mode));
  }

  factory GamePlayedMode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamePlayedMode(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      mode: $GamePlayedModesTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'mode': serializer.toJson<String>(
        $GamePlayedModesTable.$convertermode.toJson(mode),
      ),
    };
  }

  GamePlayedMode copyWith({int? mediaId, GameMode? mode}) =>
      GamePlayedMode(mediaId: mediaId ?? this.mediaId, mode: mode ?? this.mode);
  GamePlayedMode copyWithCompanion(GamePlayedModesCompanion data) {
    return GamePlayedMode(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      mode: data.mode.present ? data.mode.value : this.mode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayedMode(')
          ..write('mediaId: $mediaId, ')
          ..write('mode: $mode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, mode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamePlayedMode &&
          other.mediaId == this.mediaId &&
          other.mode == this.mode);
}

class GamePlayedModesCompanion extends UpdateCompanion<GamePlayedMode> {
  final Value<int> mediaId;
  final Value<GameMode> mode;
  final Value<int> rowid;
  const GamePlayedModesCompanion({
    this.mediaId = const Value.absent(),
    this.mode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamePlayedModesCompanion.insert({
    required int mediaId,
    required GameMode mode,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       mode = Value(mode);
  static Insertable<GamePlayedMode> custom({
    Expression<int>? mediaId,
    Expression<String>? mode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (mode != null) 'mode': mode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamePlayedModesCompanion copyWith({
    Value<int>? mediaId,
    Value<GameMode>? mode,
    Value<int>? rowid,
  }) {
    return GamePlayedModesCompanion(
      mediaId: mediaId ?? this.mediaId,
      mode: mode ?? this.mode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $GamePlayedModesTable.$convertermode.toSql(mode.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayedModesCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('mode: $mode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamePlayedPlatformsTable extends GamePlayedPlatforms
    with TableInfo<$GamePlayedPlatformsTable, GamePlayedPlatform> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamePlayedPlatformsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (media_id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GamePlatform, String> platform =
      GeneratedColumn<String>(
        'platform',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GamePlatform>(
        $GamePlayedPlatformsTable.$converterplatform,
      );
  @override
  List<GeneratedColumn> get $columns => [mediaId, platform];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_played_platforms';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamePlayedPlatform> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, platform};
  @override
  GamePlayedPlatform map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamePlayedPlatform(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      platform: $GamePlayedPlatformsTable.$converterplatform.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platform'],
        )!,
      ),
    );
  }

  @override
  $GamePlayedPlatformsTable createAlias(String alias) {
    return $GamePlayedPlatformsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GamePlatform, String, String> $converterplatform =
      const EnumNameConverter<GamePlatform>(GamePlatform.values);
}

class GamePlayedPlatform extends DataClass
    implements Insertable<GamePlayedPlatform> {
  final int mediaId;
  final GamePlatform platform;
  const GamePlayedPlatform({required this.mediaId, required this.platform});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    {
      map['platform'] = Variable<String>(
        $GamePlayedPlatformsTable.$converterplatform.toSql(platform),
      );
    }
    return map;
  }

  GamePlayedPlatformsCompanion toCompanion(bool nullToAbsent) {
    return GamePlayedPlatformsCompanion(
      mediaId: Value(mediaId),
      platform: Value(platform),
    );
  }

  factory GamePlayedPlatform.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamePlayedPlatform(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      platform: $GamePlayedPlatformsTable.$converterplatform.fromJson(
        serializer.fromJson<String>(json['platform']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'platform': serializer.toJson<String>(
        $GamePlayedPlatformsTable.$converterplatform.toJson(platform),
      ),
    };
  }

  GamePlayedPlatform copyWith({int? mediaId, GamePlatform? platform}) =>
      GamePlayedPlatform(
        mediaId: mediaId ?? this.mediaId,
        platform: platform ?? this.platform,
      );
  GamePlayedPlatform copyWithCompanion(GamePlayedPlatformsCompanion data) {
    return GamePlayedPlatform(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      platform: data.platform.present ? data.platform.value : this.platform,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayedPlatform(')
          ..write('mediaId: $mediaId, ')
          ..write('platform: $platform')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, platform);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamePlayedPlatform &&
          other.mediaId == this.mediaId &&
          other.platform == this.platform);
}

class GamePlayedPlatformsCompanion extends UpdateCompanion<GamePlayedPlatform> {
  final Value<int> mediaId;
  final Value<GamePlatform> platform;
  final Value<int> rowid;
  const GamePlayedPlatformsCompanion({
    this.mediaId = const Value.absent(),
    this.platform = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamePlayedPlatformsCompanion.insert({
    required int mediaId,
    required GamePlatform platform,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       platform = Value(platform);
  static Insertable<GamePlayedPlatform> custom({
    Expression<int>? mediaId,
    Expression<String>? platform,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (platform != null) 'platform': platform,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamePlayedPlatformsCompanion copyWith({
    Value<int>? mediaId,
    Value<GamePlatform>? platform,
    Value<int>? rowid,
  }) {
    return GamePlayedPlatformsCompanion(
      mediaId: mediaId ?? this.mediaId,
      platform: platform ?? this.platform,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(
        $GamePlayedPlatformsTable.$converterplatform.toSql(platform.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayedPlatformsCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('platform: $platform, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeopleTable extends People with TableInfo<$PeopleTable, PeopleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(
    Insertable<PeopleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeopleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeopleData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class PeopleData extends DataClass implements Insertable<PeopleData> {
  final int id;
  final String name;
  const PeopleData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(id: Value(id), name: Value(name));
  }

  factory PeopleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeopleData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  PeopleData copyWith({int? id, String? name}) =>
      PeopleData(id: id ?? this.id, name: name ?? this.name);
  PeopleData copyWithCompanion(PeopleCompanion data) {
    return PeopleData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeopleData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeopleData && other.id == this.id && other.name == this.name);
}

class PeopleCompanion extends UpdateCompanion<PeopleData> {
  final Value<int> id;
  final Value<String> name;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PeopleCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<PeopleData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PeopleCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PeopleCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Company> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }
}

class Company extends DataClass implements Insertable<Company> {
  final int id;
  final String name;
  const Company({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(id: Value(id), name: Value(name));
  }

  factory Company.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Company copyWith({int? id, String? name}) =>
      Company(id: id ?? this.id, name: name ?? this.name);
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company && other.id == this.id && other.name == this.name);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<int> id;
  final Value<String> name;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CompaniesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Company> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  CompaniesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return CompaniesCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ContributorsTable extends Contributors
    with TableInfo<$ContributorsTable, Contributor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContributorsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES people (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, personId, companyId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contributors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contributor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contributor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contributor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
    );
  }

  @override
  $ContributorsTable createAlias(String alias) {
    return $ContributorsTable(attachedDatabase, alias);
  }
}

class Contributor extends DataClass implements Insertable<Contributor> {
  final int id;
  final int? personId;
  final int? companyId;
  const Contributor({required this.id, this.personId, this.companyId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    return map;
  }

  ContributorsCompanion toCompanion(bool nullToAbsent) {
    return ContributorsCompanion(
      id: Value(id),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
    );
  }

  factory Contributor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contributor(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int?>(json['personId']),
      companyId: serializer.fromJson<int?>(json['companyId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int?>(personId),
      'companyId': serializer.toJson<int?>(companyId),
    };
  }

  Contributor copyWith({
    int? id,
    Value<int?> personId = const Value.absent(),
    Value<int?> companyId = const Value.absent(),
  }) => Contributor(
    id: id ?? this.id,
    personId: personId.present ? personId.value : this.personId,
    companyId: companyId.present ? companyId.value : this.companyId,
  );
  Contributor copyWithCompanion(ContributorsCompanion data) {
    return Contributor(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contributor(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('companyId: $companyId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personId, companyId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contributor &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.companyId == this.companyId);
}

class ContributorsCompanion extends UpdateCompanion<Contributor> {
  final Value<int> id;
  final Value<int?> personId;
  final Value<int?> companyId;
  const ContributorsCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.companyId = const Value.absent(),
  });
  ContributorsCompanion.insert({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.companyId = const Value.absent(),
  });
  static Insertable<Contributor> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<int>? companyId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (companyId != null) 'company_id': companyId,
    });
  }

  ContributorsCompanion copyWith({
    Value<int>? id,
    Value<int?>? personId,
    Value<int?>? companyId,
  }) {
    return ContributorsCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContributorsCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('companyId: $companyId')
          ..write(')'))
        .toString();
  }
}

class $GameDevelopersTable extends GameDevelopers
    with TableInfo<$GameDevelopersTable, GameDeveloper> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameDevelopersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (media_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contributorIdMeta = const VerificationMeta(
    'contributorId',
  );
  @override
  late final GeneratedColumn<int> contributorId = GeneratedColumn<int>(
    'contributor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contributors (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId, contributorId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_developers';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameDeveloper> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('contributor_id')) {
      context.handle(
        _contributorIdMeta,
        contributorId.isAcceptableOrUnknown(
          data['contributor_id']!,
          _contributorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contributorIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, contributorId};
  @override
  GameDeveloper map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameDeveloper(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      contributorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contributor_id'],
      )!,
    );
  }

  @override
  $GameDevelopersTable createAlias(String alias) {
    return $GameDevelopersTable(attachedDatabase, alias);
  }
}

class GameDeveloper extends DataClass implements Insertable<GameDeveloper> {
  final int mediaId;
  final int contributorId;
  const GameDeveloper({required this.mediaId, required this.contributorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['contributor_id'] = Variable<int>(contributorId);
    return map;
  }

  GameDevelopersCompanion toCompanion(bool nullToAbsent) {
    return GameDevelopersCompanion(
      mediaId: Value(mediaId),
      contributorId: Value(contributorId),
    );
  }

  factory GameDeveloper.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameDeveloper(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      contributorId: serializer.fromJson<int>(json['contributorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'contributorId': serializer.toJson<int>(contributorId),
    };
  }

  GameDeveloper copyWith({int? mediaId, int? contributorId}) => GameDeveloper(
    mediaId: mediaId ?? this.mediaId,
    contributorId: contributorId ?? this.contributorId,
  );
  GameDeveloper copyWithCompanion(GameDevelopersCompanion data) {
    return GameDeveloper(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      contributorId: data.contributorId.present
          ? data.contributorId.value
          : this.contributorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameDeveloper(')
          ..write('mediaId: $mediaId, ')
          ..write('contributorId: $contributorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, contributorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameDeveloper &&
          other.mediaId == this.mediaId &&
          other.contributorId == this.contributorId);
}

class GameDevelopersCompanion extends UpdateCompanion<GameDeveloper> {
  final Value<int> mediaId;
  final Value<int> contributorId;
  final Value<int> rowid;
  const GameDevelopersCompanion({
    this.mediaId = const Value.absent(),
    this.contributorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameDevelopersCompanion.insert({
    required int mediaId,
    required int contributorId,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       contributorId = Value(contributorId);
  static Insertable<GameDeveloper> custom({
    Expression<int>? mediaId,
    Expression<int>? contributorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (contributorId != null) 'contributor_id': contributorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameDevelopersCompanion copyWith({
    Value<int>? mediaId,
    Value<int>? contributorId,
    Value<int>? rowid,
  }) {
    return GameDevelopersCompanion(
      mediaId: mediaId ?? this.mediaId,
      contributorId: contributorId ?? this.contributorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (contributorId.present) {
      map['contributor_id'] = Variable<int>(contributorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameDevelopersCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('contributorId: $contributorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamePublishersTable extends GamePublishers
    with TableInfo<$GamePublishersTable, GamePublisher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamePublishersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (media_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contributorIdMeta = const VerificationMeta(
    'contributorId',
  );
  @override
  late final GeneratedColumn<int> contributorId = GeneratedColumn<int>(
    'contributor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contributors (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId, contributorId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_publishers';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamePublisher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('contributor_id')) {
      context.handle(
        _contributorIdMeta,
        contributorId.isAcceptableOrUnknown(
          data['contributor_id']!,
          _contributorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contributorIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, contributorId};
  @override
  GamePublisher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamePublisher(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      contributorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contributor_id'],
      )!,
    );
  }

  @override
  $GamePublishersTable createAlias(String alias) {
    return $GamePublishersTable(attachedDatabase, alias);
  }
}

class GamePublisher extends DataClass implements Insertable<GamePublisher> {
  final int mediaId;
  final int contributorId;
  const GamePublisher({required this.mediaId, required this.contributorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['contributor_id'] = Variable<int>(contributorId);
    return map;
  }

  GamePublishersCompanion toCompanion(bool nullToAbsent) {
    return GamePublishersCompanion(
      mediaId: Value(mediaId),
      contributorId: Value(contributorId),
    );
  }

  factory GamePublisher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamePublisher(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      contributorId: serializer.fromJson<int>(json['contributorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'contributorId': serializer.toJson<int>(contributorId),
    };
  }

  GamePublisher copyWith({int? mediaId, int? contributorId}) => GamePublisher(
    mediaId: mediaId ?? this.mediaId,
    contributorId: contributorId ?? this.contributorId,
  );
  GamePublisher copyWithCompanion(GamePublishersCompanion data) {
    return GamePublisher(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      contributorId: data.contributorId.present
          ? data.contributorId.value
          : this.contributorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamePublisher(')
          ..write('mediaId: $mediaId, ')
          ..write('contributorId: $contributorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, contributorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamePublisher &&
          other.mediaId == this.mediaId &&
          other.contributorId == this.contributorId);
}

class GamePublishersCompanion extends UpdateCompanion<GamePublisher> {
  final Value<int> mediaId;
  final Value<int> contributorId;
  final Value<int> rowid;
  const GamePublishersCompanion({
    this.mediaId = const Value.absent(),
    this.contributorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamePublishersCompanion.insert({
    required int mediaId,
    required int contributorId,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       contributorId = Value(contributorId);
  static Insertable<GamePublisher> custom({
    Expression<int>? mediaId,
    Expression<int>? contributorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (contributorId != null) 'contributor_id': contributorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamePublishersCompanion copyWith({
    Value<int>? mediaId,
    Value<int>? contributorId,
    Value<int>? rowid,
  }) {
    return GamePublishersCompanion(
      mediaId: mediaId ?? this.mediaId,
      contributorId: contributorId ?? this.contributorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (contributorId.present) {
      map['contributor_id'] = Variable<int>(contributorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamePublishersCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('contributorId: $contributorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThemesTable extends Themes with TableInfo<$ThemesTable, Theme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'themes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Theme> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Theme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Theme(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ThemesTable createAlias(String alias) {
    return $ThemesTable(attachedDatabase, alias);
  }
}

class Theme extends DataClass implements Insertable<Theme> {
  final int id;
  final String name;
  const Theme({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ThemesCompanion toCompanion(bool nullToAbsent) {
    return ThemesCompanion(id: Value(id), name: Value(name));
  }

  factory Theme.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Theme(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Theme copyWith({int? id, String? name}) =>
      Theme(id: id ?? this.id, name: name ?? this.name);
  Theme copyWithCompanion(ThemesCompanion data) {
    return Theme(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Theme(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Theme && other.id == this.id && other.name == this.name);
}

class ThemesCompanion extends UpdateCompanion<Theme> {
  final Value<int> id;
  final Value<String> name;
  const ThemesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ThemesCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Theme> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ThemesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ThemesCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $MediaThemesTable extends MediaThemes
    with TableInfo<$MediaThemesTable, MediaTheme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaThemesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _themeIdMeta = const VerificationMeta(
    'themeId',
  );
  @override
  late final GeneratedColumn<int> themeId = GeneratedColumn<int>(
    'theme_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES themes (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [mediaId, themeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_themes';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaTheme> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('theme_id')) {
      context.handle(
        _themeIdMeta,
        themeId.isAcceptableOrUnknown(data['theme_id']!, _themeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_themeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId, themeId};
  @override
  MediaTheme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaTheme(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      themeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_id'],
      )!,
    );
  }

  @override
  $MediaThemesTable createAlias(String alias) {
    return $MediaThemesTable(attachedDatabase, alias);
  }
}

class MediaTheme extends DataClass implements Insertable<MediaTheme> {
  final int mediaId;
  final int themeId;
  const MediaTheme({required this.mediaId, required this.themeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['theme_id'] = Variable<int>(themeId);
    return map;
  }

  MediaThemesCompanion toCompanion(bool nullToAbsent) {
    return MediaThemesCompanion(
      mediaId: Value(mediaId),
      themeId: Value(themeId),
    );
  }

  factory MediaTheme.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaTheme(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      themeId: serializer.fromJson<int>(json['themeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'themeId': serializer.toJson<int>(themeId),
    };
  }

  MediaTheme copyWith({int? mediaId, int? themeId}) => MediaTheme(
    mediaId: mediaId ?? this.mediaId,
    themeId: themeId ?? this.themeId,
  );
  MediaTheme copyWithCompanion(MediaThemesCompanion data) {
    return MediaTheme(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      themeId: data.themeId.present ? data.themeId.value : this.themeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaTheme(')
          ..write('mediaId: $mediaId, ')
          ..write('themeId: $themeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaId, themeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaTheme &&
          other.mediaId == this.mediaId &&
          other.themeId == this.themeId);
}

class MediaThemesCompanion extends UpdateCompanion<MediaTheme> {
  final Value<int> mediaId;
  final Value<int> themeId;
  final Value<int> rowid;
  const MediaThemesCompanion({
    this.mediaId = const Value.absent(),
    this.themeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaThemesCompanion.insert({
    required int mediaId,
    required int themeId,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       themeId = Value(themeId);
  static Insertable<MediaTheme> custom({
    Expression<int>? mediaId,
    Expression<int>? themeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (themeId != null) 'theme_id': themeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaThemesCompanion copyWith({
    Value<int>? mediaId,
    Value<int>? themeId,
    Value<int>? rowid,
  }) {
    return MediaThemesCompanion(
      mediaId: mediaId ?? this.mediaId,
      themeId: themeId ?? this.themeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (themeId.present) {
      map['theme_id'] = Variable<int>(themeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaThemesCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('themeId: $themeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MediaTable media = $MediaTable(this);
  late final $MediaMetadataTable mediaMetadata = $MediaMetadataTable(this);
  late final $MediaUserDataTable mediaUserData = $MediaUserDataTable(this);
  late final $GenresTable genres = $GenresTable(this);
  late final $MediaGenresTable mediaGenres = $MediaGenresTable(this);
  late final $ExternalIdsTable externalIds = $ExternalIdsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $MediaTagsTable mediaTags = $MediaTagsTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $GameAvailableModesTable gameAvailableModes =
      $GameAvailableModesTable(this);
  late final $GamePlayedModesTable gamePlayedModes = $GamePlayedModesTable(
    this,
  );
  late final $GamePlayedPlatformsTable gamePlayedPlatforms =
      $GamePlayedPlatformsTable(this);
  late final $PeopleTable people = $PeopleTable(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $ContributorsTable contributors = $ContributorsTable(this);
  late final $GameDevelopersTable gameDevelopers = $GameDevelopersTable(this);
  late final $GamePublishersTable gamePublishers = $GamePublishersTable(this);
  late final $ThemesTable themes = $ThemesTable(this);
  late final $MediaThemesTable mediaThemes = $MediaThemesTable(this);
  late final Index mediaTypeIdx = Index(
    'media_type_idx',
    'CREATE INDEX media_type_idx ON media (media_type)',
  );
  late final Index externalIdsMediaSourceIdx = Index(
    'external_ids_media_source_idx',
    'CREATE UNIQUE INDEX external_ids_media_source_idx ON external_ids (media_id, source)',
  );
  late final Index externalIdsSourceExternalIdIdx = Index(
    'external_ids_source_external_id_idx',
    'CREATE UNIQUE INDEX external_ids_source_external_id_idx ON external_ids (source, external_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    media,
    mediaMetadata,
    mediaUserData,
    genres,
    mediaGenres,
    externalIds,
    tags,
    mediaTags,
    games,
    gameAvailableModes,
    gamePlayedModes,
    gamePlayedPlatforms,
    people,
    companies,
    contributors,
    gameDevelopers,
    gamePublishers,
    themes,
    mediaThemes,
    mediaTypeIdx,
    externalIdsMediaSourceIdx,
    externalIdsSourceExternalIdIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_metadata', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_user_data', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_genres', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'genres',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_genres', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('external_ids', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_available_modes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_played_modes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_played_platforms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'people',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contributors', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'companies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contributors', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_developers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contributors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_developers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_publishers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contributors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_publishers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_themes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'themes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_themes', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MediaTableCreateCompanionBuilder = MediaCompanion Function({
  Value<int> id,
  required MediaType mediaType,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$MediaTableUpdateCompanionBuilder = MediaCompanion Function({
  Value<int> id,
  Value<MediaType> mediaType,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MediaTableReferences
    extends BaseReferences<_$AppDatabase, $MediaTable, MediaData> {
  $$MediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaMetadataTable, List<MediaMetadataData>>
  _mediaMetadataRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaMetadata,
    aliasName: 'media__id__media_metadata__media_id',
  );

  $$MediaMetadataTableProcessedTableManager get mediaMetadataRefs {
    final manager = $$MediaMetadataTableTableManager(
      $_db,
      $_db.mediaMetadata,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaMetadataRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MediaUserDataTable, List<MediaUserDataData>>
  _mediaUserDataRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaUserData,
    aliasName: 'media__id__media_user_data__media_id',
  );

  $$MediaUserDataTableProcessedTableManager get mediaUserDataRefs {
    final manager = $$MediaUserDataTableTableManager(
      $_db,
      $_db.mediaUserData,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaUserDataRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MediaGenresTable, List<MediaGenre>>
  _mediaGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaGenres,
    aliasName: 'media__id__media_genres__media_id',
  );

  $$MediaGenresTableProcessedTableManager get mediaGenresRefs {
    final manager = $$MediaGenresTableTableManager(
      $_db,
      $_db.mediaGenres,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaGenresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExternalIdsTable, List<ExternalId>>
  _externalIdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.externalIds,
    aliasName: 'media__id__external_ids__media_id',
  );

  $$ExternalIdsTableProcessedTableManager get externalIdsRefs {
    final manager = $$ExternalIdsTableTableManager(
      $_db,
      $_db.externalIds,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_externalIdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MediaTagsTable, List<MediaTag>>
  _mediaTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaTags,
    aliasName: 'media__id__media_tags__media_id',
  );

  $$MediaTagsTableProcessedTableManager get mediaTagsRefs {
    final manager = $$MediaTagsTableTableManager(
      $_db,
      $_db.mediaTags,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamesTable, List<Game>> _gamesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.games,
    aliasName: 'media__id__games__media_id',
  );

  $$GamesTableProcessedTableManager get gamesRefs {
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MediaThemesTable, List<MediaTheme>>
  _mediaThemesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaThemes,
    aliasName: 'media__id__media_themes__media_id',
  );

  $$MediaThemesTableProcessedTableManager get mediaThemesRefs {
    final manager = $$MediaThemesTableTableManager(
      $_db,
      $_db.mediaThemes,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaThemesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaTableFilterComposer extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MediaType, MediaType, String> get mediaType =>
      $composableBuilder(
        column: $table.mediaType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaMetadataRefs(
    Expression<bool> Function($$MediaMetadataTableFilterComposer f) f,
  ) {
    final $$MediaMetadataTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaMetadata,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaMetadataTableFilterComposer(
            $db: $db,
            $table: $db.mediaMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaUserDataRefs(
    Expression<bool> Function($$MediaUserDataTableFilterComposer f) f,
  ) {
    final $$MediaUserDataTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaUserData,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaUserDataTableFilterComposer(
            $db: $db,
            $table: $db.mediaUserData,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaGenresRefs(
    Expression<bool> Function($$MediaGenresTableFilterComposer f) f,
  ) {
    final $$MediaGenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaGenres,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaGenresTableFilterComposer(
            $db: $db,
            $table: $db.mediaGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> externalIdsRefs(
    Expression<bool> Function($$ExternalIdsTableFilterComposer f) f,
  ) {
    final $$ExternalIdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.externalIds,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExternalIdsTableFilterComposer(
            $db: $db,
            $table: $db.externalIds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaTagsRefs(
    Expression<bool> Function($$MediaTagsTableFilterComposer f) f,
  ) {
    final $$MediaTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaTags,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTagsTableFilterComposer(
            $db: $db,
            $table: $db.mediaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gamesRefs(
    Expression<bool> Function($$GamesTableFilterComposer f) f,
  ) {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaThemesRefs(
    Expression<bool> Function($$MediaThemesTableFilterComposer f) f,
  ) {
    final $$MediaThemesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaThemes,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaThemesTableFilterComposer(
            $db: $db,
            $table: $db.mediaThemes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableOrderingComposer({
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

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
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

class $$MediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaType, String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mediaMetadataRefs<T extends Object>(
    Expression<T> Function($$MediaMetadataTableAnnotationComposer a) f,
  ) {
    final $$MediaMetadataTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaMetadata,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaMetadataTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mediaUserDataRefs<T extends Object>(
    Expression<T> Function($$MediaUserDataTableAnnotationComposer a) f,
  ) {
    final $$MediaUserDataTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaUserData,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaUserDataTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaUserData,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mediaGenresRefs<T extends Object>(
    Expression<T> Function($$MediaGenresTableAnnotationComposer a) f,
  ) {
    final $$MediaGenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaGenres,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaGenresTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> externalIdsRefs<T extends Object>(
    Expression<T> Function($$ExternalIdsTableAnnotationComposer a) f,
  ) {
    final $$ExternalIdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.externalIds,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExternalIdsTableAnnotationComposer(
            $db: $db,
            $table: $db.externalIds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mediaTagsRefs<T extends Object>(
    Expression<T> Function($$MediaTagsTableAnnotationComposer a) f,
  ) {
    final $$MediaTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaTags,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gamesRefs<T extends Object>(
    Expression<T> Function($$GamesTableAnnotationComposer a) f,
  ) {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mediaThemesRefs<T extends Object>(
    Expression<T> Function($$MediaThemesTableAnnotationComposer a) f,
  ) {
    final $$MediaThemesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaThemes,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaThemesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaThemes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaTable,
          MediaData,
          $$MediaTableFilterComposer,
          $$MediaTableOrderingComposer,
          $$MediaTableAnnotationComposer,
          $$MediaTableCreateCompanionBuilder,
          $$MediaTableUpdateCompanionBuilder,
          (MediaData, $$MediaTableReferences),
          MediaData,
          PrefetchHooks Function({
            bool mediaMetadataRefs,
            bool mediaUserDataRefs,
            bool mediaGenresRefs,
            bool externalIdsRefs,
            bool mediaTagsRefs,
            bool gamesRefs,
            bool mediaThemesRefs,
          })
        > {
  $$MediaTableTableManager(_$AppDatabase db, $MediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<MediaType> mediaType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MediaCompanion(
                id: id,
                mediaType: mediaType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required MediaType mediaType,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => MediaCompanion.insert(
                id: id,
                mediaType: mediaType,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MediaTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                mediaMetadataRefs = false,
                mediaUserDataRefs = false,
                mediaGenresRefs = false,
                externalIdsRefs = false,
                mediaTagsRefs = false,
                gamesRefs = false,
                mediaThemesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mediaMetadataRefs) db.mediaMetadata,
                    if (mediaUserDataRefs) db.mediaUserData,
                    if (mediaGenresRefs) db.mediaGenres,
                    if (externalIdsRefs) db.externalIds,
                    if (mediaTagsRefs) db.mediaTags,
                    if (gamesRefs) db.games,
                    if (mediaThemesRefs) db.mediaThemes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mediaMetadataRefs)
                        await $_getPrefetchedData<
                          MediaData,
                          $MediaTable,
                          MediaMetadataData
                        >(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._mediaMetadataRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaMetadataRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mediaUserDataRefs)
                        await $_getPrefetchedData<
                          MediaData,
                          $MediaTable,
                          MediaUserDataData
                        >(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._mediaUserDataRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaUserDataRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mediaGenresRefs)
                        await $_getPrefetchedData<
                          MediaData,
                          $MediaTable,
                          MediaGenre
                        >(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._mediaGenresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaGenresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (externalIdsRefs)
                        await $_getPrefetchedData<
                          MediaData,
                          $MediaTable,
                          ExternalId
                        >(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._externalIdsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(
                                db,
                                table,
                                p0,
                              ).externalIdsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mediaTagsRefs)
                        await $_getPrefetchedData<
                          MediaData,
                          $MediaTable,
                          MediaTag
                        >(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._mediaTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamesRefs)
                        await $_getPrefetchedData<MediaData, $MediaTable, Game>(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._gamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(db, table, p0).gamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mediaThemesRefs)
                        await $_getPrefetchedData<
                          MediaData,
                          $MediaTable,
                          MediaTheme
                        >(
                          currentTable: table,
                          referencedTable: $$MediaTableReferences
                              ._mediaThemesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaThemesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaTable,
      MediaData,
      $$MediaTableFilterComposer,
      $$MediaTableOrderingComposer,
      $$MediaTableAnnotationComposer,
      $$MediaTableCreateCompanionBuilder,
      $$MediaTableUpdateCompanionBuilder,
      (MediaData, $$MediaTableReferences),
      MediaData,
      PrefetchHooks Function({
        bool mediaMetadataRefs,
        bool mediaUserDataRefs,
        bool mediaGenresRefs,
        bool externalIdsRefs,
        bool mediaTagsRefs,
        bool gamesRefs,
        bool mediaThemesRefs,
      })
    >;
typedef $$MediaMetadataTableCreateCompanionBuilder =
    MediaMetadataCompanion Function({
      Value<int> mediaId,
      required String title,
      Value<String?> description,
      Value<String?> coverUrl,
      Value<DateOnly?> releaseDate,
      required DateTime updatedAt,
    });
typedef $$MediaMetadataTableUpdateCompanionBuilder =
    MediaMetadataCompanion Function({
      Value<int> mediaId,
      Value<String> title,
      Value<String?> description,
      Value<String?> coverUrl,
      Value<DateOnly?> releaseDate,
      Value<DateTime> updatedAt,
    });

final class $$MediaMetadataTableReferences
    extends
        BaseReferences<_$AppDatabase, $MediaMetadataTable, MediaMetadataData> {
  $$MediaMetadataTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('media_metadata__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $MediaMetadataTable> {
  $$MediaMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateOnly?, DateOnly, String> get releaseDate =>
      $composableBuilder(
        column: $table.releaseDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaMetadataTable> {
  $$MediaMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaMetadataTable> {
  $$MediaMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateOnly?, String> get releaseDate =>
      $composableBuilder(
        column: $table.releaseDate,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaMetadataTable,
          MediaMetadataData,
          $$MediaMetadataTableFilterComposer,
          $$MediaMetadataTableOrderingComposer,
          $$MediaMetadataTableAnnotationComposer,
          $$MediaMetadataTableCreateCompanionBuilder,
          $$MediaMetadataTableUpdateCompanionBuilder,
          (MediaMetadataData, $$MediaMetadataTableReferences),
          MediaMetadataData,
          PrefetchHooks Function({bool mediaId})
        > {
  $$MediaMetadataTableTableManager(_$AppDatabase db, $MediaMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<DateOnly?> releaseDate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MediaMetadataCompanion(
                mediaId: mediaId,
                title: title,
                description: description,
                coverUrl: coverUrl,
                releaseDate: releaseDate,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<DateOnly?> releaseDate = const Value.absent(),
                required DateTime updatedAt,
              }) => MediaMetadataCompanion.insert(
                mediaId: mediaId,
                title: title,
                description: description,
                coverUrl: coverUrl,
                releaseDate: releaseDate,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaMetadataTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$MediaMetadataTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$MediaMetadataTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaMetadataTable,
      MediaMetadataData,
      $$MediaMetadataTableFilterComposer,
      $$MediaMetadataTableOrderingComposer,
      $$MediaMetadataTableAnnotationComposer,
      $$MediaMetadataTableCreateCompanionBuilder,
      $$MediaMetadataTableUpdateCompanionBuilder,
      (MediaMetadataData, $$MediaMetadataTableReferences),
      MediaMetadataData,
      PrefetchHooks Function({bool mediaId})
    >;
typedef $$MediaUserDataTableCreateCompanionBuilder =
    MediaUserDataCompanion Function({
      Value<int> mediaId,
      required MediaStatus status,
      Value<int?> rating,
      Value<DateOnly?> startedOn,
      Value<DateOnly?> finishedOn,
      Value<String?> review,
      required DateTime updatedAt,
    });
typedef $$MediaUserDataTableUpdateCompanionBuilder =
    MediaUserDataCompanion Function({
      Value<int> mediaId,
      Value<MediaStatus> status,
      Value<int?> rating,
      Value<DateOnly?> startedOn,
      Value<DateOnly?> finishedOn,
      Value<String?> review,
      Value<DateTime> updatedAt,
    });

final class $$MediaUserDataTableReferences
    extends
        BaseReferences<_$AppDatabase, $MediaUserDataTable, MediaUserDataData> {
  $$MediaUserDataTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('media_user_data__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaUserDataTableFilterComposer
    extends Composer<_$AppDatabase, $MediaUserDataTable> {
  $$MediaUserDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<MediaStatus, MediaStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateOnly?, DateOnly, String> get startedOn =>
      $composableBuilder(
        column: $table.startedOn,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateOnly?, DateOnly, String> get finishedOn =>
      $composableBuilder(
        column: $table.finishedOn,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get review => $composableBuilder(
    column: $table.review,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaUserDataTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaUserDataTable> {
  $$MediaUserDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finishedOn => $composableBuilder(
    column: $table.finishedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get review => $composableBuilder(
    column: $table.review,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaUserDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaUserDataTable> {
  $$MediaUserDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<MediaStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateOnly?, String> get startedOn =>
      $composableBuilder(column: $table.startedOn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateOnly?, String> get finishedOn =>
      $composableBuilder(
        column: $table.finishedOn,
        builder: (column) => column,
      );

  GeneratedColumn<String> get review =>
      $composableBuilder(column: $table.review, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaUserDataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaUserDataTable,
          MediaUserDataData,
          $$MediaUserDataTableFilterComposer,
          $$MediaUserDataTableOrderingComposer,
          $$MediaUserDataTableAnnotationComposer,
          $$MediaUserDataTableCreateCompanionBuilder,
          $$MediaUserDataTableUpdateCompanionBuilder,
          (MediaUserDataData, $$MediaUserDataTableReferences),
          MediaUserDataData,
          PrefetchHooks Function({bool mediaId})
        > {
  $$MediaUserDataTableTableManager(_$AppDatabase db, $MediaUserDataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaUserDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaUserDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaUserDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<MediaStatus> status = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateOnly?> startedOn = const Value.absent(),
                Value<DateOnly?> finishedOn = const Value.absent(),
                Value<String?> review = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MediaUserDataCompanion(
                mediaId: mediaId,
                status: status,
                rating: rating,
                startedOn: startedOn,
                finishedOn: finishedOn,
                review: review,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                required MediaStatus status,
                Value<int?> rating = const Value.absent(),
                Value<DateOnly?> startedOn = const Value.absent(),
                Value<DateOnly?> finishedOn = const Value.absent(),
                Value<String?> review = const Value.absent(),
                required DateTime updatedAt,
              }) => MediaUserDataCompanion.insert(
                mediaId: mediaId,
                status: status,
                rating: rating,
                startedOn: startedOn,
                finishedOn: finishedOn,
                review: review,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaUserDataTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$MediaUserDataTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$MediaUserDataTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaUserDataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaUserDataTable,
      MediaUserDataData,
      $$MediaUserDataTableFilterComposer,
      $$MediaUserDataTableOrderingComposer,
      $$MediaUserDataTableAnnotationComposer,
      $$MediaUserDataTableCreateCompanionBuilder,
      $$MediaUserDataTableUpdateCompanionBuilder,
      (MediaUserDataData, $$MediaUserDataTableReferences),
      MediaUserDataData,
      PrefetchHooks Function({bool mediaId})
    >;
typedef $$GenresTableCreateCompanionBuilder = GenresCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$GenresTableUpdateCompanionBuilder = GenresCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$GenresTableReferences
    extends BaseReferences<_$AppDatabase, $GenresTable, Genre> {
  $$GenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaGenresTable, List<MediaGenre>>
  _mediaGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaGenres,
    aliasName: 'genres__id__media_genres__genre_id',
  );

  $$MediaGenresTableProcessedTableManager get mediaGenresRefs {
    final manager = $$MediaGenresTableTableManager(
      $_db,
      $_db.mediaGenres,
    ).filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaGenresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GenresTableFilterComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaGenresRefs(
    Expression<bool> Function($$MediaGenresTableFilterComposer f) f,
  ) {
    final $$MediaGenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaGenres,
      getReferencedColumn: (t) => t.genreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaGenresTableFilterComposer(
            $db: $db,
            $table: $db.mediaGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GenresTableOrderingComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> mediaGenresRefs<T extends Object>(
    Expression<T> Function($$MediaGenresTableAnnotationComposer a) f,
  ) {
    final $$MediaGenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaGenres,
      getReferencedColumn: (t) => t.genreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaGenresTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GenresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GenresTable,
          Genre,
          $$GenresTableFilterComposer,
          $$GenresTableOrderingComposer,
          $$GenresTableAnnotationComposer,
          $$GenresTableCreateCompanionBuilder,
          $$GenresTableUpdateCompanionBuilder,
          (Genre, $$GenresTableReferences),
          Genre,
          PrefetchHooks Function({bool mediaGenresRefs})
        > {
  $$GenresTableTableManager(_$AppDatabase db, $GenresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => GenresCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => GenresCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GenresTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({mediaGenresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaGenresRefs) db.mediaGenres],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaGenresRefs)
                    await $_getPrefetchedData<Genre, $GenresTable, MediaGenre>(
                      currentTable: table,
                      referencedTable: $$GenresTableReferences
                          ._mediaGenresRefsTable(db),
                      managerFromTypedResult: (p0) => $$GenresTableReferences(
                        db,
                        table,
                        p0,
                      ).mediaGenresRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.genreId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GenresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GenresTable,
      Genre,
      $$GenresTableFilterComposer,
      $$GenresTableOrderingComposer,
      $$GenresTableAnnotationComposer,
      $$GenresTableCreateCompanionBuilder,
      $$GenresTableUpdateCompanionBuilder,
      (Genre, $$GenresTableReferences),
      Genre,
      PrefetchHooks Function({bool mediaGenresRefs})
    >;
typedef $$MediaGenresTableCreateCompanionBuilder =
    MediaGenresCompanion Function({
      required int mediaId,
      required int genreId,
      Value<int> rowid,
    });
typedef $$MediaGenresTableUpdateCompanionBuilder =
    MediaGenresCompanion Function({
      Value<int> mediaId,
      Value<int> genreId,
      Value<int> rowid,
    });

final class $$MediaGenresTableReferences
    extends BaseReferences<_$AppDatabase, $MediaGenresTable, MediaGenre> {
  $$MediaGenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('media_genres__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GenresTable _genreIdTable(_$AppDatabase db) =>
      db.genres.createAlias('media_genres__genre_id__genres__id');

  $$GenresTableProcessedTableManager get genreId {
    final $_column = $_itemColumn<int>('genre_id')!;

    final manager = $$GenresTableTableManager(
      $_db,
      $_db.genres,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaGenresTableFilterComposer
    extends Composer<_$AppDatabase, $MediaGenresTable> {
  $$MediaGenresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableFilterComposer get genreId {
    final $$GenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableFilterComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaGenresTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaGenresTable> {
  $$MediaGenresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableOrderingComposer get genreId {
    final $$GenresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableOrderingComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaGenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaGenresTable> {
  $$MediaGenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableAnnotationComposer get genreId {
    final $$GenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableAnnotationComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaGenresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaGenresTable,
          MediaGenre,
          $$MediaGenresTableFilterComposer,
          $$MediaGenresTableOrderingComposer,
          $$MediaGenresTableAnnotationComposer,
          $$MediaGenresTableCreateCompanionBuilder,
          $$MediaGenresTableUpdateCompanionBuilder,
          (MediaGenre, $$MediaGenresTableReferences),
          MediaGenre,
          PrefetchHooks Function({bool mediaId, bool genreId})
        > {
  $$MediaGenresTableTableManager(_$AppDatabase db, $MediaGenresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaGenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaGenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaGenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<int> genreId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaGenresCompanion(
                mediaId: mediaId,
                genreId: genreId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required int genreId,
                Value<int> rowid = const Value.absent(),
              }) => MediaGenresCompanion.insert(
                mediaId: mediaId,
                genreId: genreId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaGenresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false, genreId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$MediaGenresTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$MediaGenresTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (genreId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.genreId,
                        referencedTable: $$MediaGenresTableReferences
                            ._genreIdTable(db),
                        referencedColumn: $$MediaGenresTableReferences
                            ._genreIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaGenresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaGenresTable,
      MediaGenre,
      $$MediaGenresTableFilterComposer,
      $$MediaGenresTableOrderingComposer,
      $$MediaGenresTableAnnotationComposer,
      $$MediaGenresTableCreateCompanionBuilder,
      $$MediaGenresTableUpdateCompanionBuilder,
      (MediaGenre, $$MediaGenresTableReferences),
      MediaGenre,
      PrefetchHooks Function({bool mediaId, bool genreId})
    >;
typedef $$ExternalIdsTableCreateCompanionBuilder =
    ExternalIdsCompanion Function({
      required int mediaId,
      required String source,
      required String externalId,
      Value<int> rowid,
    });
typedef $$ExternalIdsTableUpdateCompanionBuilder =
    ExternalIdsCompanion Function({
      Value<int> mediaId,
      Value<String> source,
      Value<String> externalId,
      Value<int> rowid,
    });

final class $$ExternalIdsTableReferences
    extends BaseReferences<_$AppDatabase, $ExternalIdsTable, ExternalId> {
  $$ExternalIdsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('external_ids__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExternalIdsTableFilterComposer
    extends Composer<_$AppDatabase, $ExternalIdsTable> {
  $$ExternalIdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExternalIdsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExternalIdsTable> {
  $$ExternalIdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExternalIdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExternalIdsTable> {
  $$ExternalIdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExternalIdsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExternalIdsTable,
          ExternalId,
          $$ExternalIdsTableFilterComposer,
          $$ExternalIdsTableOrderingComposer,
          $$ExternalIdsTableAnnotationComposer,
          $$ExternalIdsTableCreateCompanionBuilder,
          $$ExternalIdsTableUpdateCompanionBuilder,
          (ExternalId, $$ExternalIdsTableReferences),
          ExternalId,
          PrefetchHooks Function({bool mediaId})
        > {
  $$ExternalIdsTableTableManager(_$AppDatabase db, $ExternalIdsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExternalIdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExternalIdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExternalIdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExternalIdsCompanion(
                mediaId: mediaId,
                source: source,
                externalId: externalId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required String source,
                required String externalId,
                Value<int> rowid = const Value.absent(),
              }) => ExternalIdsCompanion.insert(
                mediaId: mediaId,
                source: source,
                externalId: externalId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExternalIdsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$ExternalIdsTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$ExternalIdsTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExternalIdsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExternalIdsTable,
      ExternalId,
      $$ExternalIdsTableFilterComposer,
      $$ExternalIdsTableOrderingComposer,
      $$ExternalIdsTableAnnotationComposer,
      $$ExternalIdsTableCreateCompanionBuilder,
      $$ExternalIdsTableUpdateCompanionBuilder,
      (ExternalId, $$ExternalIdsTableReferences),
      ExternalId,
      PrefetchHooks Function({bool mediaId})
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaTagsTable, List<MediaTag>>
  _mediaTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaTags,
    aliasName: 'tags__id__media_tags__tag_id',
  );

  $$MediaTagsTableProcessedTableManager get mediaTagsRefs {
    final manager = $$MediaTagsTableTableManager(
      $_db,
      $_db.mediaTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaTagsRefs(
    Expression<bool> Function($$MediaTagsTableFilterComposer f) f,
  ) {
    final $$MediaTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTagsTableFilterComposer(
            $db: $db,
            $table: $db.mediaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> mediaTagsRefs<T extends Object>(
    Expression<T> Function($$MediaTagsTableAnnotationComposer a) f,
  ) {
    final $$MediaTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool mediaTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => TagsCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => TagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({mediaTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaTagsRefs) db.mediaTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, MediaTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._mediaTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).mediaTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool mediaTagsRefs})
    >;
typedef $$MediaTagsTableCreateCompanionBuilder = MediaTagsCompanion Function({
  required int mediaId,
  required int tagId,
  Value<int> rowid,
});
typedef $$MediaTagsTableUpdateCompanionBuilder = MediaTagsCompanion Function({
  Value<int> mediaId,
  Value<int> tagId,
  Value<int> rowid,
});

final class $$MediaTagsTableReferences
    extends BaseReferences<_$AppDatabase, $MediaTagsTable, MediaTag> {
  $$MediaTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('media_tags__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('media_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaTagsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaTagsTable> {
  $$MediaTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaTagsTable> {
  $$MediaTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaTagsTable> {
  $$MediaTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaTagsTable,
          MediaTag,
          $$MediaTagsTableFilterComposer,
          $$MediaTagsTableOrderingComposer,
          $$MediaTagsTableAnnotationComposer,
          $$MediaTagsTableCreateCompanionBuilder,
          $$MediaTagsTableUpdateCompanionBuilder,
          (MediaTag, $$MediaTagsTableReferences),
          MediaTag,
          PrefetchHooks Function({bool mediaId, bool tagId})
        > {
  $$MediaTagsTableTableManager(_$AppDatabase db, $MediaTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaTagsCompanion(
                mediaId: mediaId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => MediaTagsCompanion.insert(
                mediaId: mediaId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$MediaTagsTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$MediaTagsTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$MediaTagsTableReferences._tagIdTable(
                          db,
                        ),
                        referencedColumn: $$MediaTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaTagsTable,
      MediaTag,
      $$MediaTagsTableFilterComposer,
      $$MediaTagsTableOrderingComposer,
      $$MediaTagsTableAnnotationComposer,
      $$MediaTagsTableCreateCompanionBuilder,
      $$MediaTagsTableUpdateCompanionBuilder,
      (MediaTag, $$MediaTagsTableReferences),
      MediaTag,
      PrefetchHooks Function({bool mediaId, bool tagId})
    >;
typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> mediaId,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> mediaId,
});

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('games__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({bool mediaId})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> mediaId = const Value.absent(),
          }) => GamesCompanion(mediaId: mediaId),
          createCompanionCallback: ({
            Value<int> mediaId = const Value.absent(),
          }) => GamesCompanion.insert(mediaId: mediaId),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$GamesTableReferences._mediaIdTable(
                          db,
                        ),
                        referencedColumn: $$GamesTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({bool mediaId})
    >;
typedef $$GameAvailableModesTableCreateCompanionBuilder =
    GameAvailableModesCompanion Function({
      required int mediaId,
      required GameMode mode,
      Value<int> rowid,
    });
typedef $$GameAvailableModesTableUpdateCompanionBuilder =
    GameAvailableModesCompanion Function({
      Value<int> mediaId,
      Value<GameMode> mode,
      Value<int> rowid,
    });

class $$GameAvailableModesTableFilterComposer
    extends Composer<_$AppDatabase, $GameAvailableModesTable> {
  $$GameAvailableModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<GameMode, GameMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$GameAvailableModesTableOrderingComposer
    extends Composer<_$AppDatabase, $GameAvailableModesTable> {
  $$GameAvailableModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameAvailableModesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameAvailableModesTable> {
  $$GameAvailableModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<GameMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);
}

class $$GameAvailableModesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameAvailableModesTable,
          GameAvailableMode,
          $$GameAvailableModesTableFilterComposer,
          $$GameAvailableModesTableOrderingComposer,
          $$GameAvailableModesTableAnnotationComposer,
          $$GameAvailableModesTableCreateCompanionBuilder,
          $$GameAvailableModesTableUpdateCompanionBuilder,
          (
            GameAvailableMode,
            BaseReferences<
              _$AppDatabase,
              $GameAvailableModesTable,
              GameAvailableMode
            >,
          ),
          GameAvailableMode,
          PrefetchHooks Function()
        > {
  $$GameAvailableModesTableTableManager(
    _$AppDatabase db,
    $GameAvailableModesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameAvailableModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameAvailableModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameAvailableModesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<GameMode> mode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameAvailableModesCompanion(
                mediaId: mediaId,
                mode: mode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required GameMode mode,
                Value<int> rowid = const Value.absent(),
              }) => GameAvailableModesCompanion.insert(
                mediaId: mediaId,
                mode: mode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameAvailableModesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameAvailableModesTable,
      GameAvailableMode,
      $$GameAvailableModesTableFilterComposer,
      $$GameAvailableModesTableOrderingComposer,
      $$GameAvailableModesTableAnnotationComposer,
      $$GameAvailableModesTableCreateCompanionBuilder,
      $$GameAvailableModesTableUpdateCompanionBuilder,
      (
        GameAvailableMode,
        BaseReferences<
          _$AppDatabase,
          $GameAvailableModesTable,
          GameAvailableMode
        >,
      ),
      GameAvailableMode,
      PrefetchHooks Function()
    >;
typedef $$GamePlayedModesTableCreateCompanionBuilder =
    GamePlayedModesCompanion Function({
      required int mediaId,
      required GameMode mode,
      Value<int> rowid,
    });
typedef $$GamePlayedModesTableUpdateCompanionBuilder =
    GamePlayedModesCompanion Function({
      Value<int> mediaId,
      Value<GameMode> mode,
      Value<int> rowid,
    });

class $$GamePlayedModesTableFilterComposer
    extends Composer<_$AppDatabase, $GamePlayedModesTable> {
  $$GamePlayedModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<GameMode, GameMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$GamePlayedModesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamePlayedModesTable> {
  $$GamePlayedModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamePlayedModesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamePlayedModesTable> {
  $$GamePlayedModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<GameMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);
}

class $$GamePlayedModesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamePlayedModesTable,
          GamePlayedMode,
          $$GamePlayedModesTableFilterComposer,
          $$GamePlayedModesTableOrderingComposer,
          $$GamePlayedModesTableAnnotationComposer,
          $$GamePlayedModesTableCreateCompanionBuilder,
          $$GamePlayedModesTableUpdateCompanionBuilder,
          (
            GamePlayedMode,
            BaseReferences<
              _$AppDatabase,
              $GamePlayedModesTable,
              GamePlayedMode
            >,
          ),
          GamePlayedMode,
          PrefetchHooks Function()
        > {
  $$GamePlayedModesTableTableManager(
    _$AppDatabase db,
    $GamePlayedModesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamePlayedModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamePlayedModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamePlayedModesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<GameMode> mode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamePlayedModesCompanion(
                mediaId: mediaId,
                mode: mode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required GameMode mode,
                Value<int> rowid = const Value.absent(),
              }) => GamePlayedModesCompanion.insert(
                mediaId: mediaId,
                mode: mode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GamePlayedModesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamePlayedModesTable,
      GamePlayedMode,
      $$GamePlayedModesTableFilterComposer,
      $$GamePlayedModesTableOrderingComposer,
      $$GamePlayedModesTableAnnotationComposer,
      $$GamePlayedModesTableCreateCompanionBuilder,
      $$GamePlayedModesTableUpdateCompanionBuilder,
      (
        GamePlayedMode,
        BaseReferences<_$AppDatabase, $GamePlayedModesTable, GamePlayedMode>,
      ),
      GamePlayedMode,
      PrefetchHooks Function()
    >;
typedef $$GamePlayedPlatformsTableCreateCompanionBuilder =
    GamePlayedPlatformsCompanion Function({
      required int mediaId,
      required GamePlatform platform,
      Value<int> rowid,
    });
typedef $$GamePlayedPlatformsTableUpdateCompanionBuilder =
    GamePlayedPlatformsCompanion Function({
      Value<int> mediaId,
      Value<GamePlatform> platform,
      Value<int> rowid,
    });

class $$GamePlayedPlatformsTableFilterComposer
    extends Composer<_$AppDatabase, $GamePlayedPlatformsTable> {
  $$GamePlayedPlatformsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<GamePlatform, GamePlatform, String>
  get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$GamePlayedPlatformsTableOrderingComposer
    extends Composer<_$AppDatabase, $GamePlayedPlatformsTable> {
  $$GamePlayedPlatformsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamePlayedPlatformsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamePlayedPlatformsTable> {
  $$GamePlayedPlatformsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<GamePlatform, String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);
}

class $$GamePlayedPlatformsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamePlayedPlatformsTable,
          GamePlayedPlatform,
          $$GamePlayedPlatformsTableFilterComposer,
          $$GamePlayedPlatformsTableOrderingComposer,
          $$GamePlayedPlatformsTableAnnotationComposer,
          $$GamePlayedPlatformsTableCreateCompanionBuilder,
          $$GamePlayedPlatformsTableUpdateCompanionBuilder,
          (
            GamePlayedPlatform,
            BaseReferences<
              _$AppDatabase,
              $GamePlayedPlatformsTable,
              GamePlayedPlatform
            >,
          ),
          GamePlayedPlatform,
          PrefetchHooks Function()
        > {
  $$GamePlayedPlatformsTableTableManager(
    _$AppDatabase db,
    $GamePlayedPlatformsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamePlayedPlatformsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamePlayedPlatformsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GamePlayedPlatformsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<GamePlatform> platform = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamePlayedPlatformsCompanion(
                mediaId: mediaId,
                platform: platform,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required GamePlatform platform,
                Value<int> rowid = const Value.absent(),
              }) => GamePlayedPlatformsCompanion.insert(
                mediaId: mediaId,
                platform: platform,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GamePlayedPlatformsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamePlayedPlatformsTable,
      GamePlayedPlatform,
      $$GamePlayedPlatformsTableFilterComposer,
      $$GamePlayedPlatformsTableOrderingComposer,
      $$GamePlayedPlatformsTableAnnotationComposer,
      $$GamePlayedPlatformsTableCreateCompanionBuilder,
      $$GamePlayedPlatformsTableUpdateCompanionBuilder,
      (
        GamePlayedPlatform,
        BaseReferences<
          _$AppDatabase,
          $GamePlayedPlatformsTable,
          GamePlayedPlatform
        >,
      ),
      GamePlayedPlatform,
      PrefetchHooks Function()
    >;
typedef $$PeopleTableCreateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$PeopleTableUpdateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$PeopleTableReferences
    extends BaseReferences<_$AppDatabase, $PeopleTable, PeopleData> {
  $$PeopleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContributorsTable, List<Contributor>>
  _contributorsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contributors,
    aliasName: 'people__id__contributors__person_id',
  );

  $$ContributorsTableProcessedTableManager get contributorsRefs {
    final manager = $$ContributorsTableTableManager(
      $_db,
      $_db.contributors,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contributorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PeopleTableFilterComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contributorsRefs(
    Expression<bool> Function($$ContributorsTableFilterComposer f) f,
  ) {
    final $$ContributorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableFilterComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeopleTableOrderingComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeopleTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> contributorsRefs<T extends Object>(
    Expression<T> Function($$ContributorsTableAnnotationComposer a) f,
  ) {
    final $$ContributorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableAnnotationComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeopleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeopleTable,
          PeopleData,
          $$PeopleTableFilterComposer,
          $$PeopleTableOrderingComposer,
          $$PeopleTableAnnotationComposer,
          $$PeopleTableCreateCompanionBuilder,
          $$PeopleTableUpdateCompanionBuilder,
          (PeopleData, $$PeopleTableReferences),
          PeopleData,
          PrefetchHooks Function({bool contributorsRefs})
        > {
  $$PeopleTableTableManager(_$AppDatabase db, $PeopleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => PeopleCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => PeopleCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PeopleTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({contributorsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (contributorsRefs) db.contributors],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contributorsRefs)
                    await $_getPrefetchedData<
                      PeopleData,
                      $PeopleTable,
                      Contributor
                    >(
                      currentTable: table,
                      referencedTable: $$PeopleTableReferences
                          ._contributorsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PeopleTableReferences(
                        db,
                        table,
                        p0,
                      ).contributorsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.personId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PeopleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeopleTable,
      PeopleData,
      $$PeopleTableFilterComposer,
      $$PeopleTableOrderingComposer,
      $$PeopleTableAnnotationComposer,
      $$PeopleTableCreateCompanionBuilder,
      $$PeopleTableUpdateCompanionBuilder,
      (PeopleData, $$PeopleTableReferences),
      PeopleData,
      PrefetchHooks Function({bool contributorsRefs})
    >;
typedef $$CompaniesTableCreateCompanionBuilder = CompaniesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$CompaniesTableUpdateCompanionBuilder = CompaniesCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$CompaniesTableReferences
    extends BaseReferences<_$AppDatabase, $CompaniesTable, Company> {
  $$CompaniesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContributorsTable, List<Contributor>>
  _contributorsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contributors,
    aliasName: 'companies__id__contributors__company_id',
  );

  $$ContributorsTableProcessedTableManager get contributorsRefs {
    final manager = $$ContributorsTableTableManager(
      $_db,
      $_db.contributors,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contributorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contributorsRefs(
    Expression<bool> Function($$ContributorsTableFilterComposer f) f,
  ) {
    final $$ContributorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableFilterComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> contributorsRefs<T extends Object>(
    Expression<T> Function($$ContributorsTableAnnotationComposer a) f,
  ) {
    final $$ContributorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableAnnotationComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompaniesTable,
          Company,
          $$CompaniesTableFilterComposer,
          $$CompaniesTableOrderingComposer,
          $$CompaniesTableAnnotationComposer,
          $$CompaniesTableCreateCompanionBuilder,
          $$CompaniesTableUpdateCompanionBuilder,
          (Company, $$CompaniesTableReferences),
          Company,
          PrefetchHooks Function({bool contributorsRefs})
        > {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => CompaniesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => CompaniesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompaniesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contributorsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (contributorsRefs) db.contributors],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contributorsRefs)
                    await $_getPrefetchedData<
                      Company,
                      $CompaniesTable,
                      Contributor
                    >(
                      currentTable: table,
                      referencedTable: $$CompaniesTableReferences
                          ._contributorsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CompaniesTableReferences(
                            db,
                            table,
                            p0,
                          ).contributorsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.companyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompaniesTable,
      Company,
      $$CompaniesTableFilterComposer,
      $$CompaniesTableOrderingComposer,
      $$CompaniesTableAnnotationComposer,
      $$CompaniesTableCreateCompanionBuilder,
      $$CompaniesTableUpdateCompanionBuilder,
      (Company, $$CompaniesTableReferences),
      Company,
      PrefetchHooks Function({bool contributorsRefs})
    >;
typedef $$ContributorsTableCreateCompanionBuilder =
    ContributorsCompanion Function({
      Value<int> id,
      Value<int?> personId,
      Value<int?> companyId,
    });
typedef $$ContributorsTableUpdateCompanionBuilder =
    ContributorsCompanion Function({
      Value<int> id,
      Value<int?> personId,
      Value<int?> companyId,
    });

final class $$ContributorsTableReferences
    extends BaseReferences<_$AppDatabase, $ContributorsTable, Contributor> {
  $$ContributorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PeopleTable _personIdTable(_$AppDatabase db) =>
      db.people.createAlias('contributors__person_id__people__id');

  $$PeopleTableProcessedTableManager? get personId {
    final $_column = $_itemColumn<int>('person_id');
    if ($_column == null) return null;
    final manager = $$PeopleTableTableManager(
      $_db,
      $_db.people,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('contributors__company_id__companies__id');

  $$CompaniesTableProcessedTableManager? get companyId {
    final $_column = $_itemColumn<int>('company_id');
    if ($_column == null) return null;
    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GameDevelopersTable, List<GameDeveloper>>
  _gameDevelopersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gameDevelopers,
    aliasName: 'contributors__id__game_developers__contributor_id',
  );

  $$GameDevelopersTableProcessedTableManager get gameDevelopersRefs {
    final manager = $$GameDevelopersTableTableManager(
      $_db,
      $_db.gameDevelopers,
    ).filter((f) => f.contributorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gameDevelopersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamePublishersTable, List<GamePublisher>>
  _gamePublishersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamePublishers,
    aliasName: 'contributors__id__game_publishers__contributor_id',
  );

  $$GamePublishersTableProcessedTableManager get gamePublishersRefs {
    final manager = $$GamePublishersTableTableManager(
      $_db,
      $_db.gamePublishers,
    ).filter((f) => f.contributorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamePublishersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContributorsTableFilterComposer
    extends Composer<_$AppDatabase, $ContributorsTable> {
  $$ContributorsTableFilterComposer({
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

  $$PeopleTableFilterComposer get personId {
    final $$PeopleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableFilterComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gameDevelopersRefs(
    Expression<bool> Function($$GameDevelopersTableFilterComposer f) f,
  ) {
    final $$GameDevelopersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameDevelopers,
      getReferencedColumn: (t) => t.contributorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameDevelopersTableFilterComposer(
            $db: $db,
            $table: $db.gameDevelopers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gamePublishersRefs(
    Expression<bool> Function($$GamePublishersTableFilterComposer f) f,
  ) {
    final $$GamePublishersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePublishers,
      getReferencedColumn: (t) => t.contributorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePublishersTableFilterComposer(
            $db: $db,
            $table: $db.gamePublishers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContributorsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContributorsTable> {
  $$ContributorsTableOrderingComposer({
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

  $$PeopleTableOrderingComposer get personId {
    final $$PeopleTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableOrderingComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContributorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContributorsTable> {
  $$ContributorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$PeopleTableAnnotationComposer get personId {
    final $$PeopleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.people,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeopleTableAnnotationComposer(
            $db: $db,
            $table: $db.people,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gameDevelopersRefs<T extends Object>(
    Expression<T> Function($$GameDevelopersTableAnnotationComposer a) f,
  ) {
    final $$GameDevelopersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameDevelopers,
      getReferencedColumn: (t) => t.contributorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameDevelopersTableAnnotationComposer(
            $db: $db,
            $table: $db.gameDevelopers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gamePublishersRefs<T extends Object>(
    Expression<T> Function($$GamePublishersTableAnnotationComposer a) f,
  ) {
    final $$GamePublishersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePublishers,
      getReferencedColumn: (t) => t.contributorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePublishersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamePublishers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContributorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContributorsTable,
          Contributor,
          $$ContributorsTableFilterComposer,
          $$ContributorsTableOrderingComposer,
          $$ContributorsTableAnnotationComposer,
          $$ContributorsTableCreateCompanionBuilder,
          $$ContributorsTableUpdateCompanionBuilder,
          (Contributor, $$ContributorsTableReferences),
          Contributor,
          PrefetchHooks Function({
            bool personId,
            bool companyId,
            bool gameDevelopersRefs,
            bool gamePublishersRefs,
          })
        > {
  $$ContributorsTableTableManager(_$AppDatabase db, $ContributorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContributorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContributorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContributorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> personId = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
              }) => ContributorsCompanion(
                id: id,
                personId: personId,
                companyId: companyId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> personId = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
              }) => ContributorsCompanion.insert(
                id: id,
                personId: personId,
                companyId: companyId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContributorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                personId = false,
                companyId = false,
                gameDevelopersRefs = false,
                gamePublishersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gameDevelopersRefs) db.gameDevelopers,
                    if (gamePublishersRefs) db.gamePublishers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (personId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.personId,
                            referencedTable: $$ContributorsTableReferences
                                ._personIdTable(db),
                            referencedColumn: $$ContributorsTableReferences
                                ._personIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (companyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.companyId,
                            referencedTable: $$ContributorsTableReferences
                                ._companyIdTable(db),
                            referencedColumn: $$ContributorsTableReferences
                                ._companyIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gameDevelopersRefs)
                        await $_getPrefetchedData<
                          Contributor,
                          $ContributorsTable,
                          GameDeveloper
                        >(
                          currentTable: table,
                          referencedTable: $$ContributorsTableReferences
                              ._gameDevelopersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContributorsTableReferences(
                                db,
                                table,
                                p0,
                              ).gameDevelopersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contributorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamePublishersRefs)
                        await $_getPrefetchedData<
                          Contributor,
                          $ContributorsTable,
                          GamePublisher
                        >(
                          currentTable: table,
                          referencedTable: $$ContributorsTableReferences
                              ._gamePublishersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContributorsTableReferences(
                                db,
                                table,
                                p0,
                              ).gamePublishersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contributorId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContributorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContributorsTable,
      Contributor,
      $$ContributorsTableFilterComposer,
      $$ContributorsTableOrderingComposer,
      $$ContributorsTableAnnotationComposer,
      $$ContributorsTableCreateCompanionBuilder,
      $$ContributorsTableUpdateCompanionBuilder,
      (Contributor, $$ContributorsTableReferences),
      Contributor,
      PrefetchHooks Function({
        bool personId,
        bool companyId,
        bool gameDevelopersRefs,
        bool gamePublishersRefs,
      })
    >;
typedef $$GameDevelopersTableCreateCompanionBuilder =
    GameDevelopersCompanion Function({
      required int mediaId,
      required int contributorId,
      Value<int> rowid,
    });
typedef $$GameDevelopersTableUpdateCompanionBuilder =
    GameDevelopersCompanion Function({
      Value<int> mediaId,
      Value<int> contributorId,
      Value<int> rowid,
    });

final class $$GameDevelopersTableReferences
    extends BaseReferences<_$AppDatabase, $GameDevelopersTable, GameDeveloper> {
  $$GameDevelopersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContributorsTable _contributorIdTable(_$AppDatabase db) => db
      .contributors
      .createAlias('game_developers__contributor_id__contributors__id');

  $$ContributorsTableProcessedTableManager get contributorId {
    final $_column = $_itemColumn<int>('contributor_id')!;

    final manager = $$ContributorsTableTableManager(
      $_db,
      $_db.contributors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contributorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GameDevelopersTableFilterComposer
    extends Composer<_$AppDatabase, $GameDevelopersTable> {
  $$GameDevelopersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContributorsTableFilterComposer get contributorId {
    final $$ContributorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contributorId,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableFilterComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameDevelopersTableOrderingComposer
    extends Composer<_$AppDatabase, $GameDevelopersTable> {
  $$GameDevelopersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContributorsTableOrderingComposer get contributorId {
    final $$ContributorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contributorId,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableOrderingComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameDevelopersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameDevelopersTable> {
  $$GameDevelopersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContributorsTableAnnotationComposer get contributorId {
    final $$ContributorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contributorId,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableAnnotationComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameDevelopersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameDevelopersTable,
          GameDeveloper,
          $$GameDevelopersTableFilterComposer,
          $$GameDevelopersTableOrderingComposer,
          $$GameDevelopersTableAnnotationComposer,
          $$GameDevelopersTableCreateCompanionBuilder,
          $$GameDevelopersTableUpdateCompanionBuilder,
          (GameDeveloper, $$GameDevelopersTableReferences),
          GameDeveloper,
          PrefetchHooks Function({bool contributorId})
        > {
  $$GameDevelopersTableTableManager(
    _$AppDatabase db,
    $GameDevelopersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameDevelopersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameDevelopersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameDevelopersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<int> contributorId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameDevelopersCompanion(
                mediaId: mediaId,
                contributorId: contributorId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required int contributorId,
                Value<int> rowid = const Value.absent(),
              }) => GameDevelopersCompanion.insert(
                mediaId: mediaId,
                contributorId: contributorId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GameDevelopersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contributorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contributorId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contributorId,
                        referencedTable: $$GameDevelopersTableReferences
                            ._contributorIdTable(db),
                        referencedColumn: $$GameDevelopersTableReferences
                            ._contributorIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GameDevelopersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameDevelopersTable,
      GameDeveloper,
      $$GameDevelopersTableFilterComposer,
      $$GameDevelopersTableOrderingComposer,
      $$GameDevelopersTableAnnotationComposer,
      $$GameDevelopersTableCreateCompanionBuilder,
      $$GameDevelopersTableUpdateCompanionBuilder,
      (GameDeveloper, $$GameDevelopersTableReferences),
      GameDeveloper,
      PrefetchHooks Function({bool contributorId})
    >;
typedef $$GamePublishersTableCreateCompanionBuilder =
    GamePublishersCompanion Function({
      required int mediaId,
      required int contributorId,
      Value<int> rowid,
    });
typedef $$GamePublishersTableUpdateCompanionBuilder =
    GamePublishersCompanion Function({
      Value<int> mediaId,
      Value<int> contributorId,
      Value<int> rowid,
    });

final class $$GamePublishersTableReferences
    extends BaseReferences<_$AppDatabase, $GamePublishersTable, GamePublisher> {
  $$GamePublishersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContributorsTable _contributorIdTable(_$AppDatabase db) => db
      .contributors
      .createAlias('game_publishers__contributor_id__contributors__id');

  $$ContributorsTableProcessedTableManager get contributorId {
    final $_column = $_itemColumn<int>('contributor_id')!;

    final manager = $$ContributorsTableTableManager(
      $_db,
      $_db.contributors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contributorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamePublishersTableFilterComposer
    extends Composer<_$AppDatabase, $GamePublishersTable> {
  $$GamePublishersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContributorsTableFilterComposer get contributorId {
    final $$ContributorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contributorId,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableFilterComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePublishersTableOrderingComposer
    extends Composer<_$AppDatabase, $GamePublishersTable> {
  $$GamePublishersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContributorsTableOrderingComposer get contributorId {
    final $$ContributorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contributorId,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableOrderingComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePublishersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamePublishersTable> {
  $$GamePublishersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContributorsTableAnnotationComposer get contributorId {
    final $$ContributorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contributorId,
      referencedTable: $db.contributors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributorsTableAnnotationComposer(
            $db: $db,
            $table: $db.contributors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePublishersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamePublishersTable,
          GamePublisher,
          $$GamePublishersTableFilterComposer,
          $$GamePublishersTableOrderingComposer,
          $$GamePublishersTableAnnotationComposer,
          $$GamePublishersTableCreateCompanionBuilder,
          $$GamePublishersTableUpdateCompanionBuilder,
          (GamePublisher, $$GamePublishersTableReferences),
          GamePublisher,
          PrefetchHooks Function({bool contributorId})
        > {
  $$GamePublishersTableTableManager(
    _$AppDatabase db,
    $GamePublishersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamePublishersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamePublishersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamePublishersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<int> contributorId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamePublishersCompanion(
                mediaId: mediaId,
                contributorId: contributorId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required int contributorId,
                Value<int> rowid = const Value.absent(),
              }) => GamePublishersCompanion.insert(
                mediaId: mediaId,
                contributorId: contributorId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamePublishersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contributorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contributorId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contributorId,
                        referencedTable: $$GamePublishersTableReferences
                            ._contributorIdTable(db),
                        referencedColumn: $$GamePublishersTableReferences
                            ._contributorIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamePublishersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamePublishersTable,
      GamePublisher,
      $$GamePublishersTableFilterComposer,
      $$GamePublishersTableOrderingComposer,
      $$GamePublishersTableAnnotationComposer,
      $$GamePublishersTableCreateCompanionBuilder,
      $$GamePublishersTableUpdateCompanionBuilder,
      (GamePublisher, $$GamePublishersTableReferences),
      GamePublisher,
      PrefetchHooks Function({bool contributorId})
    >;
typedef $$ThemesTableCreateCompanionBuilder = ThemesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$ThemesTableUpdateCompanionBuilder = ThemesCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$ThemesTableReferences
    extends BaseReferences<_$AppDatabase, $ThemesTable, Theme> {
  $$ThemesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaThemesTable, List<MediaTheme>>
  _mediaThemesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaThemes,
    aliasName: 'themes__id__media_themes__theme_id',
  );

  $$MediaThemesTableProcessedTableManager get mediaThemesRefs {
    final manager = $$MediaThemesTableTableManager(
      $_db,
      $_db.mediaThemes,
    ).filter((f) => f.themeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaThemesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ThemesTableFilterComposer
    extends Composer<_$AppDatabase, $ThemesTable> {
  $$ThemesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaThemesRefs(
    Expression<bool> Function($$MediaThemesTableFilterComposer f) f,
  ) {
    final $$MediaThemesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaThemes,
      getReferencedColumn: (t) => t.themeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaThemesTableFilterComposer(
            $db: $db,
            $table: $db.mediaThemes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ThemesTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemesTable> {
  $$ThemesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemesTable> {
  $$ThemesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> mediaThemesRefs<T extends Object>(
    Expression<T> Function($$MediaThemesTableAnnotationComposer a) f,
  ) {
    final $$MediaThemesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaThemes,
      getReferencedColumn: (t) => t.themeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaThemesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaThemes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ThemesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThemesTable,
          Theme,
          $$ThemesTableFilterComposer,
          $$ThemesTableOrderingComposer,
          $$ThemesTableAnnotationComposer,
          $$ThemesTableCreateCompanionBuilder,
          $$ThemesTableUpdateCompanionBuilder,
          (Theme, $$ThemesTableReferences),
          Theme,
          PrefetchHooks Function({bool mediaThemesRefs})
        > {
  $$ThemesTableTableManager(_$AppDatabase db, $ThemesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => ThemesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => ThemesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ThemesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({mediaThemesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaThemesRefs) db.mediaThemes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaThemesRefs)
                    await $_getPrefetchedData<Theme, $ThemesTable, MediaTheme>(
                      currentTable: table,
                      referencedTable: $$ThemesTableReferences
                          ._mediaThemesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ThemesTableReferences(
                        db,
                        table,
                        p0,
                      ).mediaThemesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.themeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ThemesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThemesTable,
      Theme,
      $$ThemesTableFilterComposer,
      $$ThemesTableOrderingComposer,
      $$ThemesTableAnnotationComposer,
      $$ThemesTableCreateCompanionBuilder,
      $$ThemesTableUpdateCompanionBuilder,
      (Theme, $$ThemesTableReferences),
      Theme,
      PrefetchHooks Function({bool mediaThemesRefs})
    >;
typedef $$MediaThemesTableCreateCompanionBuilder =
    MediaThemesCompanion Function({
      required int mediaId,
      required int themeId,
      Value<int> rowid,
    });
typedef $$MediaThemesTableUpdateCompanionBuilder =
    MediaThemesCompanion Function({
      Value<int> mediaId,
      Value<int> themeId,
      Value<int> rowid,
    });

final class $$MediaThemesTableReferences
    extends BaseReferences<_$AppDatabase, $MediaThemesTable, MediaTheme> {
  $$MediaThemesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaTable _mediaIdTable(_$AppDatabase db) =>
      db.media.createAlias('media_themes__media_id__media__id');

  $$MediaTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaTableTableManager(
      $_db,
      $_db.media,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ThemesTable _themeIdTable(_$AppDatabase db) =>
      db.themes.createAlias('media_themes__theme_id__themes__id');

  $$ThemesTableProcessedTableManager get themeId {
    final $_column = $_itemColumn<int>('theme_id')!;

    final manager = $$ThemesTableTableManager(
      $_db,
      $_db.themes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_themeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaThemesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaThemesTable> {
  $$MediaThemesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableFilterComposer get mediaId {
    final $$MediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableFilterComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ThemesTableFilterComposer get themeId {
    final $$ThemesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.themeId,
      referencedTable: $db.themes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThemesTableFilterComposer(
            $db: $db,
            $table: $db.themes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaThemesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaThemesTable> {
  $$MediaThemesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableOrderingComposer get mediaId {
    final $$MediaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableOrderingComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ThemesTableOrderingComposer get themeId {
    final $$ThemesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.themeId,
      referencedTable: $db.themes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThemesTableOrderingComposer(
            $db: $db,
            $table: $db.themes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaThemesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaThemesTable> {
  $$MediaThemesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MediaTableAnnotationComposer get mediaId {
    final $$MediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.media,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTableAnnotationComposer(
            $db: $db,
            $table: $db.media,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ThemesTableAnnotationComposer get themeId {
    final $$ThemesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.themeId,
      referencedTable: $db.themes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThemesTableAnnotationComposer(
            $db: $db,
            $table: $db.themes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaThemesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaThemesTable,
          MediaTheme,
          $$MediaThemesTableFilterComposer,
          $$MediaThemesTableOrderingComposer,
          $$MediaThemesTableAnnotationComposer,
          $$MediaThemesTableCreateCompanionBuilder,
          $$MediaThemesTableUpdateCompanionBuilder,
          (MediaTheme, $$MediaThemesTableReferences),
          MediaTheme,
          PrefetchHooks Function({bool mediaId, bool themeId})
        > {
  $$MediaThemesTableTableManager(_$AppDatabase db, $MediaThemesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaThemesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaThemesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaThemesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<int> themeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaThemesCompanion(
                mediaId: mediaId,
                themeId: themeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int mediaId,
                required int themeId,
                Value<int> rowid = const Value.absent(),
              }) => MediaThemesCompanion.insert(
                mediaId: mediaId,
                themeId: themeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaThemesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaId = false, themeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mediaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mediaId,
                        referencedTable: $$MediaThemesTableReferences
                            ._mediaIdTable(db),
                        referencedColumn: $$MediaThemesTableReferences
                            ._mediaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (themeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.themeId,
                        referencedTable: $$MediaThemesTableReferences
                            ._themeIdTable(db),
                        referencedColumn: $$MediaThemesTableReferences
                            ._themeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaThemesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaThemesTable,
      MediaTheme,
      $$MediaThemesTableFilterComposer,
      $$MediaThemesTableOrderingComposer,
      $$MediaThemesTableAnnotationComposer,
      $$MediaThemesTableCreateCompanionBuilder,
      $$MediaThemesTableUpdateCompanionBuilder,
      (MediaTheme, $$MediaThemesTableReferences),
      MediaTheme,
      PrefetchHooks Function({bool mediaId, bool themeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MediaTableTableManager get media =>
      $$MediaTableTableManager(_db, _db.media);
  $$MediaMetadataTableTableManager get mediaMetadata =>
      $$MediaMetadataTableTableManager(_db, _db.mediaMetadata);
  $$MediaUserDataTableTableManager get mediaUserData =>
      $$MediaUserDataTableTableManager(_db, _db.mediaUserData);
  $$GenresTableTableManager get genres =>
      $$GenresTableTableManager(_db, _db.genres);
  $$MediaGenresTableTableManager get mediaGenres =>
      $$MediaGenresTableTableManager(_db, _db.mediaGenres);
  $$ExternalIdsTableTableManager get externalIds =>
      $$ExternalIdsTableTableManager(_db, _db.externalIds);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$MediaTagsTableTableManager get mediaTags =>
      $$MediaTagsTableTableManager(_db, _db.mediaTags);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$GameAvailableModesTableTableManager get gameAvailableModes =>
      $$GameAvailableModesTableTableManager(_db, _db.gameAvailableModes);
  $$GamePlayedModesTableTableManager get gamePlayedModes =>
      $$GamePlayedModesTableTableManager(_db, _db.gamePlayedModes);
  $$GamePlayedPlatformsTableTableManager get gamePlayedPlatforms =>
      $$GamePlayedPlatformsTableTableManager(_db, _db.gamePlayedPlatforms);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$ContributorsTableTableManager get contributors =>
      $$ContributorsTableTableManager(_db, _db.contributors);
  $$GameDevelopersTableTableManager get gameDevelopers =>
      $$GameDevelopersTableTableManager(_db, _db.gameDevelopers);
  $$GamePublishersTableTableManager get gamePublishers =>
      $$GamePublishersTableTableManager(_db, _db.gamePublishers);
  $$ThemesTableTableManager get themes =>
      $$ThemesTableTableManager(_db, _db.themes);
  $$MediaThemesTableTableManager get mediaThemes =>
      $$MediaThemesTableTableManager(_db, _db.mediaThemes);
}
