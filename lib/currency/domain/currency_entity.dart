import 'package:hive/hive.dart';

class CurrencyEntity extends HiveObject {
  @HiveField(0)
  List<Currency> currencies;

  CurrencyEntity({
    required this.currencies,
  });

  factory CurrencyEntity.fromJson(Map<String, dynamic> json) => CurrencyEntity(
        currencies: (json["results"] as Map<String, dynamic>)
            .values
            .map((v) => Currency.fromJson(v))
            .toList(),
      );
}

class Currency extends HiveObject {
  @HiveField(0)
  String alpha3;
  @HiveField(1)
  String currencyId;
  @HiveField(2)
  String currencyName;
  @HiveField(3)
  String currencySymbol;
  @HiveField(4)
  String id;
  @HiveField(5)
  String name;

  Currency({
    required this.alpha3,
    required this.currencyId,
    required this.currencyName,
    required this.currencySymbol,
    required this.id,
    required this.name,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        alpha3: json["alpha3"],
        currencyId: json["currencyId"],
        currencyName: json["currencyName"],
        currencySymbol: json["currencySymbol"],
        id: json["id"],
        name: json["name"],
      );

  factory Currency.fromDynamic(dynamic obj) => Currency(
        alpha3: obj.alpha3,
        currencyId: obj.currencyId,
        currencyName: obj.currencyName,
        currencySymbol: obj.currencySymbol,
        id: obj.id,
        name: obj.name,
      );

  Map<String, dynamic> toJson() => {
        "alpha3": alpha3,
        "currencyId": currencyId,
        "currencyName": currencyName,
        "currencySymbol": currencySymbol,
        "id": id,
        "name": name,
      };
}
