class Txn {
  final String id;
  final DateTime time;
  final String category;
  final int amount; // âm = chi, dương = thu
  final String? note;

  Txn({
    required this.id,
    required this.time,
    required this.category,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time.toIso8601String(),
        "category": category,
        "amount": amount,
        "note": note,
      };

  factory Txn.fromMap(Map map) => Txn(
        id: map["id"],
        time: DateTime.parse(map["time"]),
        category: map["category"],
        amount: map["amount"],
        note: map["note"],
      );
}
