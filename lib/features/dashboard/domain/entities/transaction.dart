enum TransactionType { income, expense }

class Transaction {
  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    required this.emoji,
    this.isRecurring = false,
    this.frequency,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  final String emoji;
  final bool isRecurring;
  final String? frequency;
}
