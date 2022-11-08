// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 0;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entry(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      imagePath: fields[3] as String,
      releaseDate: fields[4] as String,
      downloaded: fields[5] as bool,
      path: fields[6] as String,
      url: fields[7] as String,
      tags: (fields[8] as List).cast<dynamic>(),
      rating: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.releaseDate)
      ..writeByte(5)
      ..write(obj.downloaded)
      ..writeByte(6)
      ..write(obj.path)
      ..writeByte(7)
      ..write(obj.url)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
