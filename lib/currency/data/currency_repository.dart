import 'package:currency_converter/auth/secrets.dart';
import 'package:currency_converter/currency/domain/conversion_rates.dart';
import 'package:currency_converter/currency/domain/currency_entity.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class CurrencyRepository {
  final _dio = Dio();

  Future<CurrencyEntity> getCurrencies() async {
    final box = await Hive.openBox<CurrencyEntity>('currencies');
    if (box.isNotEmpty) {
      return box.getAt(0)!;
    }

    final response = await _dio.get(
        'https://free.currconv.com/api/v7/countries?apiKey=$currencyConversionApiKey');

    final currencyEntity = CurrencyEntity.fromJson(response.data);
    await box.put(0, currencyEntity);

    return currencyEntity;
  }

  Future<List<ConversionRate>> convertCurrency(
      {required String from, required String to}) async {
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(const Duration(days: 6));
    final response = await _dio.get(
        'https://free.currconv.com/api/v7/convert?q=${from}_$to&date=${weekAgo.toIso8601String().split('T').first}&endDate=${now.toIso8601String().split('T').first}&compact=ultra&apiKey=$currencyConversionApiKey');

    return (response.data['${from}_$to'] as Map<String, dynamic>)
        .entries
        .map((entry) => ConversionRate(date: entry.key, value: entry.value))
        .toList();
  }
}
