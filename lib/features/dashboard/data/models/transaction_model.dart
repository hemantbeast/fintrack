import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends HiveObject {
  TransactionModel({
    this.id,
    this.title,
    this.category,
    this.amount,
    this.description,
    this.date,
    this.type,
    this.emoji,
    this.isRecurring,
    this.frequency,
  });

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      amount: entity.amount,
      description: entity.description,
      date: entity.date,
      type: entity.type == TransactionType.income ? 'income' : 'expense',
      emoji: entity.emoji,
      isRecurring: entity.isRecurring,
      frequency: entity.frequency,
    );
  }

  factory TransactionModel.fromJson(JSON json) => _$TransactionModelFromJson(json);

  JSON toJson() => _$TransactionModelToJson(this);

  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'category')
  String? category;

  @JsonKey(name: 'amount')
  double? amount;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'date')
  DateTime? date;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'emoji')
  String? emoji;

  @JsonKey(name: 'is_recurring')
  bool? isRecurring;

  @JsonKey(name: 'frequency')
  String? frequency;

  TransactionType get typeEnum => type == 'income' ? TransactionType.income : TransactionType.expense;

  Transaction toEntity() {
    return Transaction(
      id: id ?? '',
      title: title ?? '',
      category: category ?? '',
      amount: amount ?? 0,
      description: description ?? '',
      date: date ?? DateTime(1970),
      type: typeEnum,
      emoji: emoji ?? '',
      isRecurring: isRecurring ?? false,
      frequency: frequency,
    );
  }
}
