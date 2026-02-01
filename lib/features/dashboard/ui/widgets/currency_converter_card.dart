import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterCard extends StatefulWidget {
  const CurrencyConverterCard({
    required this.exchangeRates,
    super.key,
  });

  final ExchangeRates? exchangeRates;

  @override
  State<CurrencyConverterCard> createState() => _CurrencyConverterCardState();
}

class _CurrencyConverterCardState extends State<CurrencyConverterCard> {
  final _amountController = TextEditingController(text: '100');
  String _toCurrency = 'USD';

  // Common currencies to show at the top of the dropdown
  static const _popularCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'AED'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0;

  double get _rate => widget.exchangeRates?.getRate(_toCurrency) ?? 1.0;

  String get _baseCurrency => widget.exchangeRates?.baseCurrency ?? 'INR';

  List<String> get _availableCurrencies {
    final currencies = widget.exchangeRates?.availableCurrencies ?? [];
    if (currencies.isEmpty) return _popularCurrencies;

    // Sort with popular currencies first
    final sorted = List<String>.from(currencies);
    sorted.sort((a, b) {
      final aPopular = _popularCurrencies.contains(a);
      final bPopular = _popularCurrencies.contains(b);

      if (aPopular && !bPopular) return -1;
      if (!aPopular && bPopular) return 1;
      return a.compareTo(b);
    });
    return sorted;
  }

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
                child: _CurrencyInputField(
                  label: _baseCurrency,
                  controller: _amountController,
                  onChanged: (_) => setState(() {}),
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
                child: _CurrencyOutputWidget(
                  currency: _toCurrency,
                  value: (_amount * _rate).toStringAsFixed(2),
                  availableCurrencies: _availableCurrencies,
                  onCurrencyChanged: (currency) {
                    setState(() => _toCurrency = currency);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencyInputField extends StatelessWidget {
  const _CurrencyInputField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: grayF9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(
            height: 20,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: semiboldTextStyle(
                color: gray33,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyOutputWidget extends StatelessWidget {
  const _CurrencyOutputWidget({
    required this.currency,
    required this.value,
    required this.availableCurrencies,
    required this.onCurrencyChanged,
  });

  final String currency;
  final String value;
  final List<String> availableCurrencies;
  final ValueChanged<String> onCurrencyChanged;

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
          GestureDetector(
            onTap: () => _showCurrencyPicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currency,
                  style: defaultTextStyle(
                    color: gray98,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: gray98,
                  size: 16,
                ),
              ],
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
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _CurrencyPickerSheet(
        currencies: availableCurrencies,
        selectedCurrency: currency,
        onSelected: (selected) {
          onCurrencyChanged(selected);
          AppRouter.pop();
        },
      ),
    );
  }
}

class _CurrencyPickerSheet extends StatelessWidget {
  const _CurrencyPickerSheet({
    required this.currencies,
    required this.selectedCurrency,
    required this.onSelected,
  });

  final List<String> currencies;
  final String selectedCurrency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  S.of(context).selectCurrency,
                  style: semiboldTextStyle(
                    color: gray33,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                const IconButton(
                  icon: Icon(Icons.close),
                  onPressed: AppRouter.pop,
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = currency == selectedCurrency;

                return ListTile(
                  title: Text(
                    currency,
                    style: defaultTextStyle(
                      fontSize: 16,
                      color: isSelected ? primaryColor : gray33,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: primaryColor) : null,
                  onTap: () => onSelected(currency),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
