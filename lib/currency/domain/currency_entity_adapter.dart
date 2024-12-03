import 'package:currency_converter/currency/domain/currency_entity.dart';
import 'package:hive/hive.dart';

class CurrencyEntityAdapter extends TypeAdapter<CurrencyEntity> {
  @override
  read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    List<Currency> currencies = [];
    for (int i = 0; i < fields[1].length; i++) {
      currencies.add(Currency.fromDynamic(fields[1][i]));
    }

    return CurrencyEntity(
      currencies: currencies,
    );
  }

  @override
  final int typeId = 1;

  @override
  void write(BinaryWriter writer, obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.currencies)
      ..writeByte(0);
  }
}
