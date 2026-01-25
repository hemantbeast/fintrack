import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class ExpenseCategoryModel extends HiveObject {
  ExpenseCategoryModel({
    this.id,
    this.name,
    this.icon,
    this.color,
  });

  factory ExpenseCategoryModel.fromEntity(ExpenseCategory entity) {
    return ExpenseCategoryModel(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      color: entity.color,
    );
  }

  factory ExpenseCategoryModel.fromJson(JSON json) => _$ExpenseCategoryModelFromJson(json);

  JSON toJson() => _$ExpenseCategoryModelToJson(this);

  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'icon')
  String? icon;

  @JsonKey(name: 'color')
  String? color;

  ExpenseCategory toEntity() {
    return ExpenseCategory(
      id: id ?? '',
      name: name ?? '',
      icon: icon ?? '',
      color: color ?? '',
    );
  }
}
