import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/core/extensions/widget_extensions.dart';
import 'package:fintrack/features/budget/ui/providers/add_budget_provider.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:fintrack/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({this.budget, super.key});

  final Budget? budget;

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  final _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize for edit mode if budget is provided
    if (widget.budget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(addBudgetProvider.notifier).initForEdit(widget.budget!);
        _limitController.text = widget.budget!.limit.toStringAsFixed(2);
      });
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addBudgetProvider);
    final notifier = ref.read(addBudgetProvider.notifier);
    final l10n = S.of(context);

    ref.listen(addBudgetProvider, (previous, next) {
      if (next.isSaved) {
        AppRouter.pop(true);
      }
    });

    final isEditing = state.editingBudget != null;
    final title = isEditing ? l10n.editBudget : l10n.addBudget;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: context.navigationTitleStyle,
        ),
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
                  onChanged: isEditing ? null : notifier.onCategoryChanged,
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

            const SizedBox(height: 24),

            // Monthly Budget Limit
            Text(
              l10n.monthlyBudgetLimit,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _limitController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              onChanged: notifier.onLimitChanged,
              decoration: InputDecoration(
                hintText: l10n.enterAmount,
                prefixText: r'$ ',
              ),
            ),

            const SizedBox(height: 24),

            // Current Spending (if editing)
            if (isEditing) ...[
              _InfoRow(
                label: l10n.currentSpending,
                value: '\$${state.editingBudget!.spent.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 24),
            ],

            // Alert Settings
            Text(
              l10n.alertSettings,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: state.alertAt75,
                    onChanged: (value) => notifier.onAlertAt75Changed(value: value ?? true),
                    title: Text(l10n.alertAt75),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: state.alertAt90,
                    onChanged: (value) => notifier.onAlertAt90Changed(value: value ?? true),
                    title: Text(l10n.alertAt90),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: state.alertWhenExceeded,
                    onChanged: (value) => notifier.onAlertWhenExceededChanged(value: value ?? true),
                    title: Text(l10n.alertWhenExceeded),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
            onPressed: state.isLoading ? null : notifier.saveBudget,
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
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
