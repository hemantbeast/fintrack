import 'package:fintrack/features/dashboard/ui/providers/dashboard_provider.dart';
import 'package:fintrack/features/dashboard/ui/widgets/balance_card.dart';
import 'package:fintrack/features/dashboard/ui/widgets/budget_overview.dart';
import 'package:fintrack/features/dashboard/ui/widgets/currency_converter_card.dart';
import 'package:fintrack/features/dashboard/ui/widgets/quick_actions.dart';
import 'package:fintrack/features/dashboard/ui/widgets/recent_transactions.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:fintrack/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.current.appName,
          style: context.navigationTitleStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.screenData.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              await notifier.refresh();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  BalanceCard(balance: data.balance),

                  // Currency Converter
                  CurrencyConverterCard(exchangeRates: data.exchangeRates),

                  // Quick Actions
                  const QuickActions(),

                  // Budget Overview
                  if (data.budgets.isEmpty) ...{
                    const NoDataWidget(text: 'No budgets found'),
                  } else ...{
                    BudgetOverview(budgets: data.budgets),
                  },

                  // Recent Transactions
                  if (data.recentTransactions.isEmpty) ...{
                    const NoDataWidget(text: 'No recent transactions found'),
                  } else ...{
                    RecentTransactions(transactions: data.recentTransactions),
                  },
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return NoDataWidget(text: S.of(context).noDataFound);
        },
        loading: LoadingWidget.new,
      ),
    );
  }
}
