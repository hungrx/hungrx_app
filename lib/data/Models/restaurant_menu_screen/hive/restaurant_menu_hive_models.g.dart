// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_menu_hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantMenuHiveAdapter extends TypeAdapter<RestaurantMenuHive> {
  @override
  final int typeId = 1;

  @override
  RestaurantMenuHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantMenuHive(
      id: fields[0] as String,
      restaurantId: fields[1] as String,
      jsonData: fields[2] as String,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantMenuHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.restaurantId)
      ..writeByte(2)
      ..write(obj.jsonData)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantMenuHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
