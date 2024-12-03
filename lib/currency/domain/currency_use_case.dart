import 'package:currency_converter/currency/data/currency_repository.dart';
import 'package:currency_converter/currency/domain/conversion_rates.dart';
import 'package:currency_converter/currency/domain/currency_entity.dart';

class CurrencyUseCase {
  Future<void> getCurrency() async {}

  Future<List<Currency>> getAllCurrencies() async {
    final currencyEntity = await CurrencyRepository().getCurrencies();

    return currencyEntity.currencies;
  }

  Future<List<ConversionRate>> convertCurrency(
      {required String from, required String to}) async {
    final conversionRate =
        await CurrencyRepository().convertCurrency(from: from, to: to);

    return conversionRate;
  }

  Future<void> getCurrencyPair() async {}

  Future<void> getCurrencyHistory() async {}
}
