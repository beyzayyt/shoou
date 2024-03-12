// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedUserModelAdapter extends TypeAdapter<SavedUserModel> {
  @override
  final int typeId = 1;

  @override
  SavedUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedUserModel(
      userName: fields[0] as String,
      userLastName: fields[1] as String,
      userMobilePhone: fields[3] as String,
      userBirthDate: fields[4] as String,
      userNickname: fields[2] as String,
      errorMessage: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedUserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.userLastName)
      ..writeByte(2)
      ..write(obj.userNickname)
      ..writeByte(3)
      ..write(obj.userMobilePhone)
      ..writeByte(4)
      ..write(obj.userBirthDate)
      ..writeByte(5)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
