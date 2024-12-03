import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_converter/currency/domain/currency_entity.dart';
import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<Currency> currencies;
  final Function(Currency?) onChanged;

  const CurrencyDropdown(
      {super.key, required this.currencies, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField(
          items: currencies
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      CachedNetworkImage(
                          imageUrl:
                              'https://flagcdn.com/32x24/${e.id.toLowerCase()}.png'),
                      const SizedBox(width: 10),
                      Text(e.alpha3),
                    ],
                  )))
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'Please select a currency';
            }
            return null;
          },
        ),
      ),
    );
  }
}
