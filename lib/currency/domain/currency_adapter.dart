import 'package:currency_converter/currency/domain/currency_entity.dart';
import 'package:hive/hive.dart';

class CurrencyAdapter extends TypeAdapter<Currency> {
  @override
  read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Currency(
      alpha3: fields[0],
      currencyId: fields[1],
      currencyName: fields[2],
      currencySymbol: fields[3],
      id: fields[4],
      name: fields[5],
    );
  }

  @override
  final int typeId = 0;

  @override
  void write(BinaryWriter writer, obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.alpha3)
      ..writeByte(1)
      ..write(obj.currencyId)
      ..writeByte(2)
      ..write(obj.currencyName)
      ..writeByte(3)
      ..write(obj.currencySymbol)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name);
  }
}
