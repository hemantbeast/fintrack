import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_model.g.dart';

@JsonSerializable()
class BudgetModel extends HiveObject {
  BudgetModel({
    required this.id,
    required this.category,
    required this.emoji,
    required this.spent,
    required this.limit,
  });

  factory BudgetModel.fromEntity(Budget entity) {
    return BudgetModel(
      id: entity.id,
      category: entity.category,
      emoji: entity.emoji,
      spent: entity.spent,
      limit: entity.limit,
    );
  }

  factory BudgetModel.fromJson(JSON json) => _$BudgetModelFromJson(json);

  JSON toJson() => _$BudgetModelToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'emoji')
  final String emoji;

  @JsonKey(name: 'spent')
  final double spent;

  @JsonKey(name: 'limit')
  final double limit;

  Budget toEntity() {
    return Budget(
      id: id,
      category: category,
      emoji: emoji,
      spent: spent,
      limit: limit,
    );
  }
}
