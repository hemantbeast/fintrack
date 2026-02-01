enum ThemeOption { light, dark, system }

class UserPreferences {
  const UserPreferences({
    this.currency = 'INR',
    this.theme = ThemeOption.system,
    this.notificationsEnabled = true,
    this.budgetAlertsEnabled = true,
    this.recurringExpenseAlertsEnabled = true,
    this.weeklySummaryEnabled = true,
  });

  final String currency;
  final ThemeOption theme;
  final bool notificationsEnabled;
  final bool budgetAlertsEnabled;
  final bool recurringExpenseAlertsEnabled;
  final bool weeklySummaryEnabled;

  UserPreferences copyWith({
    String? currency,
    ThemeOption? theme,
    bool? notificationsEnabled,
    bool? budgetAlertsEnabled,
    bool? recurringExpenseAlertsEnabled,
    bool? weeklySummaryEnabled,
  }) {
    return UserPreferences(
      currency: currency ?? this.currency,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
      recurringExpenseAlertsEnabled:
          recurringExpenseAlertsEnabled ?? this.recurringExpenseAlertsEnabled,
      weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
    );
  }
}
