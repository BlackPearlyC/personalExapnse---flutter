
class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime date;

  Transaction(
      {required this.amount,
      required this.date,
      required this.id,
      required this.title});
}
