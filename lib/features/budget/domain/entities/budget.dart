class Budget {
  Budget({
    required this.id,
    required this.category,
    required this.emoji,
    required this.spent,
    required this.limit,
  });

  final String id;
  final String category;
  final String emoji;
  final double spent;
  final double limit;

  double get percentage => (spent / limit * 100).clamp(0, 100);
  double get remaining => (limit - spent).clamp(0, limit);
}
