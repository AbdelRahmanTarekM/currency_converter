import 'package:currency_converter/currency/domain/conversion_rates.dart';
import 'package:currency_converter/currency/domain/currency_use_case.dart';
import 'package:currency_converter/currency/presentation/bloc/currency_event.dart';
import 'package:currency_converter/currency/presentation/bloc/currency_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyUseCase _currencyUseCase;

  CurrencyBloc(this._currencyUseCase) : super(CurrencyState()) {
    on<GetCurrenciesEvent>(_onGetCurrenciesEvent);
    on<ConvertCurrencyEvent>(_onConvertCurrencyEvent);
  }

  _onGetCurrenciesEvent(
      GetCurrenciesEvent event, Emitter<CurrencyState> emit) async {
    emit(LoadingState());
    final result = await _currencyUseCase.getAllCurrencies();
    emit(GetCurrenciesSuccessState(currencies: result));
  }

  _onConvertCurrencyEvent(
      ConvertCurrencyEvent event, Emitter<CurrencyState> emit) async {
    final List<ConversionRate> conversionRate =
        await _currencyUseCase.convertCurrency(from: event.from, to: event.to);

    emit(ConvertCurrencySuccessState(conversionRate: conversionRate));
  }
}
