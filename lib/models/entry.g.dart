// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEntryCollection on Isar {
  IsarCollection<Entry> get entrys => this.collection();
}

const EntrySchema = CollectionSchema(
  name: r'Entry',
  id: 744406108402872943,
  properties: {
    r'colorist': PropertySchema(
      id: 0,
      name: r'colorist',
      type: IsarType.string,
    ),
    r'coverArtist': PropertySchema(
      id: 1,
      name: r'coverArtist',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'downloaded': PropertySchema(
      id: 3,
      name: r'downloaded',
      type: IsarType.bool,
    ),
    r'editor': PropertySchema(
      id: 4,
      name: r'editor',
      type: IsarType.string,
    ),
    r'epubCfi': PropertySchema(
      id: 5,
      name: r'epubCfi',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 6,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'folderPath': PropertySchema(
      id: 7,
      name: r'folderPath',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 8,
      name: r'id',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 9,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'imprint': PropertySchema(
      id: 10,
      name: r'imprint',
      type: IsarType.string,
    ),
    r'inker': PropertySchema(
      id: 11,
      name: r'inker',
      type: IsarType.string,
    ),
    r'isFavorited': PropertySchema(
      id: 12,
      name: r'isFavorited',
      type: IsarType.bool,
    ),
    r'letterer': PropertySchema(
      id: 13,
      name: r'letterer',
      type: IsarType.string,
    ),
    r'pageNum': PropertySchema(
      id: 14,
      name: r'pageNum',
      type: IsarType.long,
    ),
    r'parentId': PropertySchema(
      id: 15,
      name: r'parentId',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 16,
      name: r'path',
      type: IsarType.string,
    ),
    r'penciller': PropertySchema(
      id: 17,
      name: r'penciller',
      type: IsarType.string,
    ),
    r'progress': PropertySchema(
      id: 18,
      name: r'progress',
      type: IsarType.double,
    ),
    r'publisher': PropertySchema(
      id: 19,
      name: r'publisher',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 20,
      name: r'rating',
      type: IsarType.double,
    ),
    r'releaseDate': PropertySchema(
      id: 21,
      name: r'releaseDate',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 22,
      name: r'tags',
      type: IsarType.stringList,
    ),
    r'title': PropertySchema(
      id: 23,
      name: r'title',
      type: IsarType.string,
    ),
    r'translator': PropertySchema(
      id: 24,
      name: r'translator',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 25,
      name: r'type',
      type: IsarType.byte,
      enumMap: _EntrytypeEnumValueMap,
    ),
    r'url': PropertySchema(
      id: 26,
      name: r'url',
      type: IsarType.string,
    ),
    r'writer': PropertySchema(
      id: 27,
      name: r'writer',
      type: IsarType.string,
    )
  },
  estimateSize: _entryEstimateSize,
  serialize: _entrySerialize,
  deserialize: _entryDeserialize,
  deserializeProp: _entryDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _entryGetId,
  getLinks: _entryGetLinks,
  attach: _entryAttach,
  version: '3.1.0+1',
);

int _entryEstimateSize(
  Entry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.colorist;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.coverArtist;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.editor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.epubCfi.length * 3;
  bytesCount += 3 + object.filePath.length * 3;
  bytesCount += 3 + object.folderPath.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.imagePath.length * 3;
  {
    final value = object.imprint;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.inker;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.letterer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.parentId.length * 3;
  bytesCount += 3 + object.path.length * 3;
  {
    final value = object.penciller;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publisher;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.releaseDate.length * 3;
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.translator;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.url.length * 3;
  {
    final value = object.writer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _entrySerialize(
  Entry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.colorist);
  writer.writeString(offsets[1], object.coverArtist);
  writer.writeString(offsets[2], object.description);
  writer.writeBool(offsets[3], object.downloaded);
  writer.writeString(offsets[4], object.editor);
  writer.writeString(offsets[5], object.epubCfi);
  writer.writeString(offsets[6], object.filePath);
  writer.writeString(offsets[7], object.folderPath);
  writer.writeString(offsets[8], object.id);
  writer.writeString(offsets[9], object.imagePath);
  writer.writeString(offsets[10], object.imprint);
  writer.writeString(offsets[11], object.inker);
  writer.writeBool(offsets[12], object.isFavorited);
  writer.writeString(offsets[13], object.letterer);
  writer.writeLong(offsets[14], object.pageNum);
  writer.writeString(offsets[15], object.parentId);
  writer.writeString(offsets[16], object.path);
  writer.writeString(offsets[17], object.penciller);
  writer.writeDouble(offsets[18], object.progress);
  writer.writeString(offsets[19], object.publisher);
  writer.writeDouble(offsets[20], object.rating);
  writer.writeString(offsets[21], object.releaseDate);
  writer.writeStringList(offsets[22], object.tags);
  writer.writeString(offsets[23], object.title);
  writer.writeString(offsets[24], object.translator);
  writer.writeByte(offsets[25], object.type.index);
  writer.writeString(offsets[26], object.url);
  writer.writeString(offsets[27], object.writer);
}

Entry _entryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Entry(
    colorist: reader.readStringOrNull(offsets[0]),
    coverArtist: reader.readStringOrNull(offsets[1]),
    description: reader.readString(offsets[2]),
    downloaded: reader.readBoolOrNull(offsets[3]) ?? false,
    editor: reader.readStringOrNull(offsets[4]),
    epubCfi: reader.readStringOrNull(offsets[5]) ?? '',
    filePath: reader.readStringOrNull(offsets[6]) ?? '',
    folderPath: reader.readStringOrNull(offsets[7]) ?? '',
    id: reader.readString(offsets[8]),
    imagePath: reader.readString(offsets[9]),
    imprint: reader.readStringOrNull(offsets[10]),
    inker: reader.readStringOrNull(offsets[11]),
    isFavorited: reader.readBoolOrNull(offsets[12]) ?? false,
    isarId: id,
    letterer: reader.readStringOrNull(offsets[13]),
    pageNum: reader.readLongOrNull(offsets[14]) ?? 0,
    parentId: reader.readStringOrNull(offsets[15]) ?? '',
    path: reader.readString(offsets[16]),
    penciller: reader.readStringOrNull(offsets[17]),
    progress: reader.readDoubleOrNull(offsets[18]) ?? 0.0,
    publisher: reader.readStringOrNull(offsets[19]),
    rating: reader.readDouble(offsets[20]),
    releaseDate: reader.readString(offsets[21]),
    tags: reader.readStringList(offsets[22]) ?? [],
    title: reader.readString(offsets[23]),
    translator: reader.readStringOrNull(offsets[24]),
    type: _EntrytypeValueEnumMap[reader.readByteOrNull(offsets[25])] ??
        EntryType.book,
    url: reader.readString(offsets[26]),
    writer: reader.readStringOrNull(offsets[27]),
  );
  return object;
}

P _entryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 15:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readStringList(offset) ?? []) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (_EntrytypeValueEnumMap[reader.readByteOrNull(offset)] ??
          EntryType.book) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _EntrytypeEnumValueMap = {
  'book': 0,
  'comic': 1,
  'folder': 2,
  'audiobook': 3,
};
const _EntrytypeValueEnumMap = {
  0: EntryType.book,
  1: EntryType.comic,
  2: EntryType.folder,
  3: EntryType.audiobook,
};

Id _entryGetId(Entry object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _entryGetLinks(Entry object) {
  return [];
}

void _entryAttach(IsarCollection<dynamic> col, Id id, Entry object) {
  object.isarId = id;
}

extension EntryQueryWhereSort on QueryBuilder<Entry, Entry, QWhere> {
  QueryBuilder<Entry, Entry, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EntryQueryWhere on QueryBuilder<Entry, Entry, QWhereClause> {
  QueryBuilder<Entry, Entry, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Entry, Entry, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterWhereClause> idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EntryQueryFilter on QueryBuilder<Entry, Entry, QFilterCondition> {
  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorist',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorist',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorist',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorist',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorist',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coloristIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorist',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'coverArtist',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'coverArtist',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coverArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coverArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coverArtist',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coverArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coverArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverArtist',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverArtist',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> coverArtistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverArtist',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> downloadedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'editor',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'editor',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'editor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'editor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'editor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'editor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'editor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'editor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'editor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'editor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'editor',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> editorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'editor',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epubCfi',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'epubCfi',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'epubCfi',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'epubCfi',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'epubCfi',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'epubCfi',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'epubCfi',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'epubCfi',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epubCfi',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> epubCfiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'epubCfi',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folderPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folderPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folderPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folderPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folderPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folderPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folderPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> folderPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folderPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imprint',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imprint',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imprint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imprint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imprint',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> imprintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imprint',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inker',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inker',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inker',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inker',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inker',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> inkerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inker',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> isFavoritedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorited',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'letterer',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'letterer',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letterer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letterer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letterer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letterer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'letterer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'letterer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'letterer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'letterer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letterer',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> lettererIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'letterer',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pageNumEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageNum',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pageNumGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageNum',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pageNumLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageNum',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pageNumBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageNum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> parentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'penciller',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'penciller',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'penciller',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'penciller',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'penciller',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'penciller',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'penciller',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'penciller',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'penciller',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'penciller',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'penciller',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> pencillerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'penciller',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> progressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> progressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> progressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> progressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'publisher',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'publisher',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publisher',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publisher',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publisher',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> publisherIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publisher',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> ratingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> ratingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> ratingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> ratingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'releaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'releaseDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'releaseDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> releaseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'releaseDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'translator',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'translator',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translator',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translator',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translator',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> translatorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translator',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> typeEqualTo(
      EntryType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> typeGreaterThan(
    EntryType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> typeLessThan(
    EntryType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> typeBetween(
    EntryType lower,
    EntryType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'writer',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'writer',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'writer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'writer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'writer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'writer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'writer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'writer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'writer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'writer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'writer',
        value: '',
      ));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> writerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'writer',
        value: '',
      ));
    });
  }
}

extension EntryQueryObject on QueryBuilder<Entry, Entry, QFilterCondition> {}

extension EntryQueryLinks on QueryBuilder<Entry, Entry, QFilterCondition> {}

extension EntryQuerySortBy on QueryBuilder<Entry, Entry, QSortBy> {
  QueryBuilder<Entry, Entry, QAfterSortBy> sortByColorist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorist', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByColoristDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorist', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByCoverArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArtist', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByCoverArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArtist', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByEditor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'editor', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByEditorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'editor', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByEpubCfi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epubCfi', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByEpubCfiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epubCfi', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByFolderPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderPath', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByFolderPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderPath', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByImprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imprint', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByImprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imprint', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByInker() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inker', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByInkerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inker', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByIsFavorited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByIsFavoritedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByLetterer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterer', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByLettererDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterer', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPageNum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNum', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPageNumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNum', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPenciller() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penciller', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPencillerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penciller', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPublisher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPublisherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByTranslator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translator', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByTranslatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translator', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByWriter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'writer', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByWriterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'writer', Sort.desc);
    });
  }
}

extension EntryQuerySortThenBy on QueryBuilder<Entry, Entry, QSortThenBy> {
  QueryBuilder<Entry, Entry, QAfterSortBy> thenByColorist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorist', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByColoristDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorist', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByCoverArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArtist', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByCoverArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArtist', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByEditor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'editor', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByEditorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'editor', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByEpubCfi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epubCfi', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByEpubCfiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epubCfi', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByFolderPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderPath', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByFolderPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderPath', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByImprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imprint', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByImprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imprint', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByInker() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inker', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByInkerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inker', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByIsFavorited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByIsFavoritedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByLetterer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterer', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByLettererDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterer', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPageNum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNum', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPageNumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNum', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPenciller() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penciller', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPencillerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penciller', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPublisher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPublisherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByTranslator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translator', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByTranslatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translator', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByWriter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'writer', Sort.asc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByWriterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'writer', Sort.desc);
    });
  }
}

extension EntryQueryWhereDistinct on QueryBuilder<Entry, Entry, QDistinct> {
  QueryBuilder<Entry, Entry, QDistinct> distinctByColorist(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByCoverArtist(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverArtist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloaded');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByEditor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'editor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByEpubCfi(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'epubCfi', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByFilePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByFolderPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folderPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByImprint(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imprint', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByInker(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inker', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByIsFavorited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorited');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByLetterer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letterer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByPageNum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageNum');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByParentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByPenciller(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'penciller', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByPublisher(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publisher', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByReleaseDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByTranslator(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translator', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QDistinct> distinctByWriter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'writer', caseSensitive: caseSensitive);
    });
  }
}

extension EntryQueryProperty on QueryBuilder<Entry, Entry, QQueryProperty> {
  QueryBuilder<Entry, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> coloristProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorist');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> coverArtistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverArtist');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Entry, bool, QQueryOperations> downloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloaded');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> editorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'editor');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> epubCfiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'epubCfi');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> folderPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folderPath');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> imprintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imprint');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> inkerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inker');
    });
  }

  QueryBuilder<Entry, bool, QQueryOperations> isFavoritedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorited');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> lettererProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letterer');
    });
  }

  QueryBuilder<Entry, int, QQueryOperations> pageNumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageNum');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> parentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentId');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> pencillerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'penciller');
    });
  }

  QueryBuilder<Entry, double, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> publisherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publisher');
    });
  }

  QueryBuilder<Entry, double, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> releaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseDate');
    });
  }

  QueryBuilder<Entry, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> translatorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translator');
    });
  }

  QueryBuilder<Entry, EntryType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Entry, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }

  QueryBuilder<Entry, String?, QQueryOperations> writerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'writer');
    });
  }
}
