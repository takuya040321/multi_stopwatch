// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stopwatch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopwatchModelAdapter extends TypeAdapter<StopwatchModel> {
  @override
  final int typeId = 0;

  @override
  StopwatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopwatchModel(
      id: fields[0] as String,
      name: fields[1] as String,
      elapsedSeconds: fields[2] as int,
      isRunning: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StopwatchModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.elapsedSeconds)
      ..writeByte(3)
      ..write(obj.isRunning)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopwatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
