import 'package:flutter/material.dart';
import '../data/models/txn.dart';
import '../data/repositories/txn_repository.dart';


class TxnProvider extends ChangeNotifier {
  final TxnRepository repo;
  TxnProvider(this.repo);


  final List<Txn> _items = [];
  List<Txn> get items => List.unmodifiable(_items);


  Future<void> load() async {
    final list = await repo.loadAll();
    _items
      ..clear()
      ..addAll(list);
    notifyListeners();
  }


  Future<void> add({required DateTime time, required String category, required int amount, String? note}) async {
    final txn = await repo.add(time: time, category: category, amount: amount, note: note);
    _items.insert(0, txn);
    notifyListeners();
  }


  Future<void> remove(String id) async {
    await repo.remove(id);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }


  int totalForDay(DateTime day) {
    final d0 = DateTime(day.year, day.month, day.day);
    final d1 = d0.add(const Duration(days: 1));
    return _items
        .where((e) => !e.time.isBefore(d0) && e.time.isBefore(d1))
        .fold(0, (p, e) => p + e.amount);
  }
}