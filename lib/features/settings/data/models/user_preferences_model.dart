import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_preferences_model.g.dart';

@JsonSerializable()
class UserPreferencesModel extends HiveObject {
  UserPreferencesModel({
    this.currency,
    this.theme,
    this.notificationsEnabled,
    this.budgetAlertsEnabled,
    this.recurringExpenseAlertsEnabled,
    this.weeklySummaryEnabled,
  });

  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      currency: entity.currency,
      theme: entity.theme.name,
      notificationsEnabled: entity.notificationsEnabled,
      budgetAlertsEnabled: entity.budgetAlertsEnabled,
      recurringExpenseAlertsEnabled: entity.recurringExpenseAlertsEnabled,
      weeklySummaryEnabled: entity.weeklySummaryEnabled,
    );
  }

  factory UserPreferencesModel.fromJson(JSON json) => _$UserPreferencesModelFromJson(json);

  JSON toJson() => _$UserPreferencesModelToJson(this);

  @JsonKey(name: 'currency')
  String? currency;

  @JsonKey(name: 'theme')
  String? theme;

  @JsonKey(name: 'notifications_enabled')
  bool? notificationsEnabled;

  @JsonKey(name: 'budget_alerts_enabled')
  bool? budgetAlertsEnabled;

  @JsonKey(name: 'recurring_expense_alerts_enabled')
  bool? recurringExpenseAlertsEnabled;

  @JsonKey(name: 'weekly_summary_enabled')
  bool? weeklySummaryEnabled;

  ThemeOption get themeEnum {
    switch (theme) {
      case 'light':
        return ThemeOption.light;
      case 'dark':
        return ThemeOption.dark;
      default:
        return ThemeOption.system;
    }
  }

  UserPreferences toEntity() {
    return UserPreferences(
      currency: currency ?? 'INR',
      theme: themeEnum,
      notificationsEnabled: notificationsEnabled ?? true,
      budgetAlertsEnabled: budgetAlertsEnabled ?? true,
      recurringExpenseAlertsEnabled: recurringExpenseAlertsEnabled ?? true,
      weeklySummaryEnabled: weeklySummaryEnabled ?? true,
    );
  }
}
