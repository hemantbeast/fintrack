import 'package:fintrack/core/extensions/date_time_extension.dart';
import 'package:fintrack/core/extensions/widget_extensions.dart';
import 'package:fintrack/features/expenses/ui/providers/add_expense_provider.dart';
import 'package:fintrack/features/expenses/ui/states/add_expense_state.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  const AddExpensePage({super.key});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(addExpenseProvider);
    _dateController.text = state.selectedDate.toFormattedString('dd MMM yyyy');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addExpenseProvider);
    final notifier = ref.read(addExpenseProvider.notifier);
    final l10n = S.of(context);

    ref.listen<AddExpenseState>(addExpenseProvider, (previous, next) {
      if (next.isSaved) {
        AppRouter.pop(true);
      }

      // Sync date controller when date changes
      if (previous?.selectedDate != next.selectedDate) {
        _dateController.text = next.selectedDate.toFormattedString('dd MMM yyyy');
      }

      // Set title when category changes
      if (_titleController.text.trim().isEmpty && next.selectedCategory != null && previous?.selectedCategory == null) {
        _titleController.text = next.selectedCategory!.name;
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n.addExpense),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Dropdown
            state.categories.when(
              data: (categories) {
                return DropdownButtonFormField(
                  initialValue: state.selectedCategory,
                  onChanged: notifier.onCategoryChanged,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Text(
                            category.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    hintText: l10n.selectCategory,
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) {
                return NoDataWidget(text: l10n.noDataFound);
              },
            ),

            const SizedBox(height: 20),

            // Amount Input
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              onChanged: notifier.onAmountChanged,
              decoration: InputDecoration(
                labelText: l10n.amount,
                hintText: l10n.enterAmount,
                prefixText: r'$ ',
              ),
            ),

            const SizedBox(height: 20),

            // Title Input
            TextFormField(
              controller: _titleController,
              onChanged: notifier.onTitleChanged,
              decoration: InputDecoration(
                labelText: l10n.title,
                hintText: l10n.enterTitle,
              ),
            ),

            const SizedBox(height: 20),

            // Description Input
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              onChanged: notifier.onDescriptionChanged,
              decoration: InputDecoration(
                labelText: l10n.description,
                hintText: l10n.enterDescription,
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 20),

            // Date Picker
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                );
                notifier.onDateChanged(date);
              },
              decoration: InputDecoration(
                labelText: l10n.date,
                hintText: l10n.selectDate,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),

            const SizedBox(height: 20),

            // Recurring Toggle
            SwitchListTile(
              value: state.isRecurring,
              onChanged: (value) {
                notifier.onRecurringChanged(value: value);
              },
              title: Text(l10n.recurring),
              contentPadding: EdgeInsets.zero,
            ),

            // Frequency Dropdown (visible only when recurring)
            if (state.isRecurring) ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<ExpenseFrequency>(
                initialValue: state.frequency,
                onChanged: notifier.onFrequencyChanged,
                items: ExpenseFrequency.values.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(_getFrequencyLabel(frequency, l10n)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: l10n.frequency,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Error Message
            if (state.errorMessage?.isNotEmpty ?? false) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      // Save Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : notifier.saveExpense,
            child: state.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ),
      ).applySafeArea(),
    );
  }

  String _getFrequencyLabel(ExpenseFrequency frequency, S l10n) {
    switch (frequency) {
      case ExpenseFrequency.daily:
        return l10n.daily;
      case ExpenseFrequency.weekly:
        return l10n.weekly;
      case ExpenseFrequency.monthly:
        return l10n.monthly;
      case ExpenseFrequency.yearly:
        return l10n.yearly;
    }
  }
}
