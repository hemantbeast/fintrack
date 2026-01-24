import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.emoji,
  });

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
      type: entity.type,
      emoji: entity.emoji,
    );
  }

  factory TransactionModel.fromJson(JSON json) => _$TransactionModelFromJson(json);

  JSON toJson() => _$TransactionModelToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'date')
  final DateTime date;

  @JsonKey(name: 'type')
  final TransactionType type;

  @JsonKey(name: 'emoji')
  final String emoji;

  Transaction toEntity() {
    return Transaction(
      id: id,
      title: title,
      category: category,
      amount: amount,
      date: date,
      type: type,
      emoji: emoji,
    );
  }
}
