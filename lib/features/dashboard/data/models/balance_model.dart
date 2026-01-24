import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_model.g.dart';

@JsonSerializable()
class BalanceModel extends HiveObject {
  BalanceModel({
    this.current,
    this.income,
    this.expenses,
  });

  factory BalanceModel.fromEntity(Balance entity) {
    return BalanceModel(
      current: entity.currentBalance,
      income: entity.income,
      expenses: entity.expenses,
    );
  }

  factory BalanceModel.fromJson(JSON json) => _$BalanceModelFromJson(json);

  JSON toJson() => _$BalanceModelToJson(this);

  @JsonKey(name: 'current')
  double? current;

  @JsonKey(name: 'income')
  double? income;

  @JsonKey(name: 'expenses')
  double? expenses;

  Balance toEntity() {
    return Balance(
      currentBalance: current ?? 0,
      income: income ?? 0,
      expenses: expenses ?? 0,
    );
  }
}
