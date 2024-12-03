import 'package:currency_converter/currency/domain/conversion_rates.dart';
import 'package:currency_converter/currency/domain/currency_entity.dart';

class CurrencyState {}

class LoadingState extends CurrencyState {}

class GetCurrenciesSuccessState extends CurrencyState {
  final List<Currency> currencies;
  GetCurrenciesSuccessState({required this.currencies});
}

class ConvertCurrencySuccessState extends CurrencyState {
  final List<ConversionRate> conversionRate;
  ConvertCurrencySuccessState({required this.conversionRate});
}
