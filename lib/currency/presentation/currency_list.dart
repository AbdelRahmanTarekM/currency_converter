import 'package:currency_converter/currency/domain/conversion_rates.dart';
import 'package:currency_converter/currency/domain/currency_entity.dart';
import 'package:currency_converter/currency/domain/currency_use_case.dart';
import 'package:currency_converter/currency/presentation/bloc/currency_bloc.dart';
import 'package:currency_converter/currency/presentation/bloc/currency_event.dart';
import 'package:currency_converter/currency/presentation/bloc/currency_state.dart';
import 'package:currency_converter/currency/presentation/widgets/currency_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyList extends StatefulWidget {
  const CurrencyList({super.key});

  @override
  CurrencyListState createState() => CurrencyListState();
}

class CurrencyListState extends State<CurrencyList> {
  final CurrencyBloc _bloc = CurrencyBloc(CurrencyUseCase());
  Currency? firstCurrency, secondCurrency;
  TextEditingController amountController = TextEditingController(text: '1');
  TextEditingController resultController = TextEditingController();
  List<ConversionRate> conversionRates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Market Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: BlocBuilder<CurrencyBloc, CurrencyState>(
                bloc: _bloc,
                buildWhen: (previous, current) =>
                    (current is GetCurrenciesSuccessState ||
                        current is LoadingState),
                builder: (context, state) {
                  if (state is GetCurrenciesSuccessState) {
                    return Row(
                      children: [
                        CurrencyDropdown(
                            currencies: state.currencies,
                            onChanged: (currency) {
                              setState(() {
                                firstCurrency = currency;
                              });
                            }),
                        CurrencyDropdown(
                            currencies: state.currencies,
                            onChanged: (currency) {
                              setState(() {
                                secondCurrency = currency;
                              });
                            }),
                      ],
                    );
                  } else if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocListener<CurrencyBloc, CurrencyState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is ConvertCurrencySuccessState) {
                    setState(() {
                      conversionRates = state.conversionRate;
                      resultController.text =
                          (state.conversionRate.first.value *
                                  double.parse(amountController.text))
                              .toStringAsFixed(2);
                    });
                  }
                },
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter amount',
                            prefix: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(firstCurrency?.currencySymbol ?? ''),
                            ),
                            labelText: 'Amount',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }

                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }

                            if (double.parse(value) <= 0) {
                              return 'Please enter a positive number';
                            }

                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              resultController.text =
                                  (conversionRates.first.value *
                                          double.parse(value))
                                      .toStringAsFixed(2);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: resultController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            prefix: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(secondCurrency?.currencySymbol ?? ''),
                            ),
                            labelText: 'Result',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (conversionRates.isNotEmpty)
              DataTable(
                columns: [
                  const DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text(
                        '${firstCurrency?.currencyId}->${secondCurrency?.currencyId}'),
                  ),
                  DataColumn(
                    label: Text(
                        '${secondCurrency?.currencyId}->${firstCurrency?.currencyId}'),
                  ),
                ],
                rows: conversionRates
                    .map(
                      (conversionRate) => DataRow(
                        cells: [
                          DataCell(Text(conversionRate.date)),
                          DataCell(Text(conversionRate.value.toString())),
                          DataCell(Text(
                              (1 / conversionRate.value).toStringAsFixed(6))),
                        ],
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (firstCurrency == null ||
              secondCurrency == null ||
              amountController.text.isEmpty ||
              double.tryParse(amountController.text) == null ||
              double.parse(amountController.text) <= 0) {
            return;
          }
          _bloc.add(
            ConvertCurrencyEvent(
              from: firstCurrency!.currencyId,
              to: secondCurrency!.currencyId,
            ),
          );
        },
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(GetCurrenciesEvent());
  }
}
