import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class CurrencyConverterCard extends StatefulWidget {
  const CurrencyConverterCard({super.key});

  @override
  State<CurrencyConverterCard> createState() => _CurrencyConverterCardState();
}

class _CurrencyConverterCardState extends State<CurrencyConverterCard> {
  double amount = 100;
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double rate = 0.92;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayF5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).currencyConverter,
            style: semiboldTextStyle(
              color: context.theme.textTheme.bodyLarge?.color,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CurrencyInputWidget(
                  label: fromCurrency,
                  value: amount.toStringAsFixed(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  color: gray98,
                  size: 20,
                ),
              ),
              Expanded(
                child: _CurrencyInputWidget(
                  label: toCurrency,
                  value: (amount * rate).toStringAsFixed(2),
                  isReadOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencyInputWidget extends StatelessWidget {
  const _CurrencyInputWidget({
    required this.label,
    required this.value,
    this.isReadOnly = false,
  });

  final String label;

  final String value;

  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: grayF9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: defaultTextStyle(
              color: gray98,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: semiboldTextStyle(
              color: gray33,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
    ;
  }
}
