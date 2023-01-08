// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adv_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdvModelAdapter extends TypeAdapter<AdvModel> {
  @override
  final int typeId = 1;

  @override
  AdvModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdvModel(
      fields[13] as String,
      fields[14] as String,
      fields[15] as String,
      fields[16] as String,
      fields[17] as String,
      fields[18] as String,
      fields[19] as String,
      fields[21] as String,
      fields[22] as String,
      fields[20] as String,
      fields[24] as bool,
      fields[25] as bool,
      fields[26] as bool,
      fields[27] as bool,
      fields[28] as bool,
      fields[29] as bool,
      fields[30] as bool,
      fields[31] as bool,
      fields[32] as bool,
      fields[33] as bool,
      fields[11] as String,
      fields[12] as String,
      fields[23] as String,
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      (fields[34] as List).cast<dynamic>(),
      fields[35] as String,
      fields[36] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdvModel obj) {
    writer
      ..writeByte(37)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.advertizerId)
      ..writeByte(2)
      ..write(obj.adType)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.descs)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.workType)
      ..writeByte(9)
      ..write(obj.workTime)
      ..writeByte(10)
      ..write(obj.payMethod)
      ..writeByte(11)
      ..write(obj.profission)
      ..writeByte(12)
      ..write(obj.price)
      ..writeByte(13)
      ..write(obj.callNumber)
      ..writeByte(14)
      ..write(obj.smsNumber)
      ..writeByte(15)
      ..write(obj.emailAddress)
      ..writeByte(16)
      ..write(obj.websiteAddress)
      ..writeByte(17)
      ..write(obj.instagramid)
      ..writeByte(18)
      ..write(obj.telegramId)
      ..writeByte(19)
      ..write(obj.whatsappNumber)
      ..writeByte(20)
      ..write(obj.time)
      ..writeByte(21)
      ..write(obj.lat)
      ..writeByte(22)
      ..write(obj.lon)
      ..writeByte(23)
      ..write(obj.address)
      ..writeByte(24)
      ..write(obj.resumeBool)
      ..writeByte(25)
      ..write(obj.callBool)
      ..writeByte(26)
      ..write(obj.smsBool)
      ..writeByte(27)
      ..write(obj.chatBool)
      ..writeByte(28)
      ..write(obj.emailBool)
      ..writeByte(29)
      ..write(obj.websiteBool)
      ..writeByte(30)
      ..write(obj.instagramBool)
      ..writeByte(31)
      ..write(obj.telegramBool)
      ..writeByte(32)
      ..write(obj.whatsappBool)
      ..writeByte(33)
      ..write(obj.locationBool)
      ..writeByte(34)
      ..write(obj.images)
      ..writeByte(35)
      ..write(obj.mazaya)
      ..writeByte(36)
      ..write(obj.sharayet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
