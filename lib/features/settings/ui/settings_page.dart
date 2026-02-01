import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/settings/domain/entities/currency.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:fintrack/features/settings/ui/providers/settings_provider.dart';
import 'package:fintrack/features/settings/ui/widgets/profile_card.dart';
import 'package:fintrack/features/settings/ui/widgets/settings_section.dart';
import 'package:fintrack/features/settings/ui/widgets/settings_tile.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:fintrack/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.settings,
          style: context.navigationTitleStyle,
        ),
      ),
      body: provider.screenData.when(
        data: (data) => RefreshIndicator(
          onRefresh: notifier.refresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Section
                ProfileCard(
                  profile: data.profile,
                  onTap: () => _showEditProfileDialog(context, data.profile, notifier),
                ),

                const SizedBox(height: 24),

                // Preferences Section
                SettingsSection(
                  title: l10n.preferences,
                  children: [
                    SettingsTile(
                      icon: Icons.currency_exchange,
                      iconColor: primaryColor,
                      title: l10n.defaultCurrency,
                      subtitle: _getCurrencyDisplay(data.preferences.currency),
                      onTap: () => _showCurrencySelector(context, data.preferences, notifier),
                    ),
                    SettingsTile(
                      icon: Icons.dark_mode,
                      iconColor: const Color(0xFF6C63FF),
                      title: l10n.theme,
                      subtitle: _getThemeLabel(context, data.preferences.theme),
                      onTap: () => _showThemeSelector(context, data.preferences, notifier),
                    ),
                    SettingsTile(
                      icon: Icons.notifications,
                      iconColor: const Color(0xFF4CAF50),
                      title: l10n.notifications,
                      subtitle: data.preferences.notificationsEnabled ? l10n.enabled : l10n.disabled,
                      trailing: Switch.adaptive(
                        value: data.preferences.notificationsEnabled,
                        onChanged: (value) {
                          notifier.updatePreferences(
                            data.preferences.copyWith(notificationsEnabled: value),
                          );
                        },
                      ),
                      onTap: () {
                        notifier.updatePreferences(
                          data.preferences.copyWith(
                            notificationsEnabled: !data.preferences.notificationsEnabled,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Notification Settings Section
                SettingsSection(
                  title: l10n.notificationSettings,
                  children: [
                    SettingsTile(
                      icon: Icons.account_balance_wallet,
                      iconColor: warningColor,
                      title: l10n.budgetAlerts,
                      subtitle: l10n.budgetAlertsDescription,
                      trailing: Switch.adaptive(
                        value: data.preferences.budgetAlertsEnabled,
                        onChanged: data.preferences.notificationsEnabled
                            ? (value) {
                                notifier.updatePreferences(
                                  data.preferences.copyWith(budgetAlertsEnabled: value),
                                );
                              }
                            : null,
                      ),
                      onTap: data.preferences.notificationsEnabled
                          ? () {
                              notifier.updatePreferences(
                                data.preferences.copyWith(
                                  budgetAlertsEnabled: !data.preferences.budgetAlertsEnabled,
                                ),
                              );
                            }
                          : () {},
                    ),
                    SettingsTile(
                      icon: Icons.repeat,
                      iconColor: secondaryColor,
                      title: l10n.recurringExpenseAlerts,
                      subtitle: l10n.recurringExpenseAlertsDescription,
                      trailing: Switch.adaptive(
                        value: data.preferences.recurringExpenseAlertsEnabled,
                        onChanged: data.preferences.notificationsEnabled
                            ? (value) {
                                notifier.updatePreferences(
                                  data.preferences.copyWith(
                                    recurringExpenseAlertsEnabled: value,
                                  ),
                                );
                              }
                            : null,
                      ),
                      onTap: data.preferences.notificationsEnabled
                          ? () {
                              notifier.updatePreferences(
                                data.preferences.copyWith(
                                  recurringExpenseAlertsEnabled: !data.preferences.recurringExpenseAlertsEnabled,
                                ),
                              );
                            }
                          : () {},
                    ),
                    SettingsTile(
                      icon: Icons.summarize,
                      iconColor: const Color(0xFF9C27B0),
                      title: l10n.weeklySummary,
                      subtitle: l10n.weeklySummaryDescription,
                      trailing: Switch.adaptive(
                        value: data.preferences.weeklySummaryEnabled,
                        onChanged: data.preferences.notificationsEnabled
                            ? (value) {
                                notifier.updatePreferences(
                                  data.preferences.copyWith(weeklySummaryEnabled: value),
                                );
                              }
                            : null,
                      ),
                      onTap: data.preferences.notificationsEnabled
                          ? () {
                              notifier.updatePreferences(
                                data.preferences.copyWith(
                                  weeklySummaryEnabled: !data.preferences.weeklySummaryEnabled,
                                ),
                              );
                            }
                          : () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Data Management Section
                SettingsSection(
                  title: l10n.dataManagement,
                  children: [
                    SettingsTile(
                      icon: Icons.upload,
                      iconColor: const Color(0xFF2196F3),
                      title: l10n.exportData,
                      subtitle: l10n.exportDataDescription,
                      onTap: () => _showExportDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.download,
                      iconColor: const Color(0xFF2196F3),
                      title: l10n.importData,
                      subtitle: l10n.importDataDescription,
                      onTap: () => _showImportDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.backup,
                      iconColor: const Color(0xFF795548),
                      title: l10n.backupRestore,
                      subtitle: l10n.backupRestoreDescription,
                      onTap: () => _showBackupDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.delete_forever,
                      iconColor: accentColor,
                      title: l10n.clearAllData,
                      subtitle: l10n.clearAllDataDescription,
                      onTap: () => _confirmClearData(context, notifier),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // About Section
                SettingsSection(
                  title: l10n.about,
                  children: [
                    SettingsTile(
                      icon: Icons.info,
                      iconColor: gray98,
                      title: l10n.appVersion,
                      subtitle: provider.version,
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.description,
                      iconColor: gray98,
                      title: l10n.termsPrivacy,
                      onTap: () => _showTermsPrivacy(context),
                    ),
                    SettingsTile(
                      icon: Icons.star,
                      iconColor: const Color(0xFFFFC107),
                      title: l10n.rateApp,
                      onTap: () => _showRateAppDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: NoDataWidget(text: l10n.noDataFound),
        ),
      ),
    );
  }

  String _getThemeLabel(BuildContext context, ThemeOption theme) {
    final l10n = S.of(context);
    switch (theme) {
      case ThemeOption.light:
        return l10n.lightTheme;
      case ThemeOption.dark:
        return l10n.darkTheme;
      case ThemeOption.system:
        return l10n.systemTheme;
    }
  }

  String _getCurrencyDisplay(String currencyCode) {
    final currency = Currency.maybeFromCode(currencyCode);
    if (currency != null) {
      return '${currency.code} (${currency.symbol})';
    }
    return currencyCode;
  }

  void _showEditProfileDialog(
    BuildContext context,
    UserProfile profile,
    SettingsNotifier notifier,
  ) {
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    final l10n = S.of(context);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.editProfile),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  hintText: l10n.enterYourName,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  hintText: l10n.enterYourEmail,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: AppRouter.pop,
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                notifier.updateProfile(
                  profile.copyWith(
                    name: nameController.text,
                    email: emailController.text,
                  ),
                );
                AppRouter.pop();
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencySelector(
    BuildContext context,
    UserPreferences preferences,
    SettingsNotifier notifier,
  ) {
    final currencies = notifier.availableCurrencies;
    final l10n = S.of(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                      l10n.selectCurrency,
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
                        final isSelected = preferences.currency == currency.code;

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
                          onTap: () {
                            notifier.updatePreferences(
                              preferences.copyWith(currency: currency.code),
                            );
                            AppRouter.pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showThemeSelector(
    BuildContext context,
    UserPreferences preferences,
    SettingsNotifier notifier,
  ) {
    final l10n = S.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.selectTheme,
                  style: semiboldTextStyle(
                    color: context.theme.textTheme.bodyLarge?.color,
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: Text(l10n.lightTheme),
                trailing: preferences.theme == ThemeOption.light ? const Icon(Icons.check, color: primaryColor) : null,
                onTap: () {
                  notifier.updatePreferences(
                    preferences.copyWith(theme: ThemeOption.light),
                  );
                  AppRouter.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(l10n.darkTheme),
                trailing: preferences.theme == ThemeOption.dark ? const Icon(Icons.check, color: primaryColor) : null,
                onTap: () {
                  notifier.updatePreferences(
                    preferences.copyWith(theme: ThemeOption.dark),
                  );
                  AppRouter.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest),
                title: Text(l10n.systemTheme),
                trailing: preferences.theme == ThemeOption.system ? const Icon(Icons.check, color: primaryColor) : null,
                onTap: () {
                  notifier.updatePreferences(
                    preferences.copyWith(theme: ThemeOption.system),
                  );
                  AppRouter.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmClearData(BuildContext context, SettingsNotifier notifier) {
    final l10n = S.of(context);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.clearAllData),
          content: Text(l10n.clearAllDataConfirmation),
          actions: [
            TextButton(
              onPressed: AppRouter.pop,
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                await AppRouter.pop();
                await notifier.clearAllData();

                if (context.mounted) {
                  AppRouter.popUntilRoot();
                }
              },
              child: Text(
                l10n.yes,
                style: const TextStyle(color: accentColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showExportDialog(BuildContext context) {
    final l10n = S.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportData),
        content: Text(l10n.exportDataComingSoon),
        actions: [
          TextButton(
            onPressed: AppRouter.pop,
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final l10n = S.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importData),
        content: Text(l10n.importDataComingSoon),
        actions: [
          TextButton(
            onPressed: AppRouter.pop,
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    final l10n = S.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.backupRestore),
        content: Text(l10n.backupRestoreComingSoon),
        actions: [
          TextButton(
            onPressed: AppRouter.pop,
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showTermsPrivacy(BuildContext context) {
    final l10n = S.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.termsPrivacy),
        content: Text(l10n.termsPrivacyComingSoon),
        actions: [
          TextButton(
            onPressed: AppRouter.pop,
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    final l10n = S.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rateApp),
        content: Text(l10n.rateAppDescription),
        actions: [
          TextButton(
            onPressed: AppRouter.pop,
            child: Text(l10n.maybeLater),
          ),
          TextButton(
            onPressed: AppRouter.pop,
            child: Text(l10n.rateNow),
          ),
        ],
      ),
    );
  }
}
