class CurrencyEvent {}

class GetCurrencyEvent extends CurrencyEvent {}

class GetCurrencyPairEvent extends CurrencyEvent {}

class GetCurrenciesEvent extends CurrencyEvent {}

class ConvertCurrencyEvent extends CurrencyEvent {
  final String from;
  final String to;

  ConvertCurrencyEvent({required this.from, required this.to});
}
