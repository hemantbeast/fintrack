import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/settings/domain/entities/currency.dart';
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0;

  double get _rate => widget.exchangeRates?.getRate(_toCurrency) ?? 1.0;

  String get _baseCurrency => widget.exchangeRates?.baseCurrency ?? 'INR';

  List<Currency> get _availableCurrencies {
    final availableCodes = widget.exchangeRates?.availableCurrencies ?? [];
    if (availableCodes.isEmpty) {
      // Return major currencies if no exchange rates available
      return Currency.majorCodes.map(Currency.fromCode).toList();
    }

    // Filter currencies that are available in exchange rates
    return availableCodes.map(Currency.maybeFromCode).whereType<Currency>().toList()..sort((a, b) => a.code.compareTo(b.code));
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
  final List<Currency> availableCurrencies;
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
      isScrollControlled: true,
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

  final List<Currency> currencies;
  final String selectedCurrency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  S.of(context).selectCurrency,
                  style: semiboldTextStyle(
                    color: context.theme.textTheme.bodyLarge?.color,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected = currency.code == selectedCurrency;

                    return ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor.withValues(alpha: 0.1) : grayF5,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            currency.symbol,
                            style: semiboldTextStyle(
                              color: isSelected ? primaryColor : gray98,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Text(currency.code),
                      subtitle: Text(currency.name),
                      trailing: isSelected ? const Icon(Icons.check, color: primaryColor) : null,
                      onTap: () => onSelected(currency.code),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
