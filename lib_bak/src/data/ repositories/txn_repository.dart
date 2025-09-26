import 'package:uuid/uuid.dart';
import '../models/txn.dart';
import '../datasources/local_txn_store.dart';

abstract class TxnRepository {
  Future<List<Txn>> loadAll();
  Future<Txn> add({
    required DateTime time,
    required String category,
    required int amount,
    String? note,
  });
  Future<void> remove(String id);
  Future<Map<String, int>> byCategory({DateTime? from, DateTime? to});
}

class TxnRepositoryImpl implements TxnRepository {
  final LocalTxnStore store;
  final _uuid = const Uuid();
  TxnRepositoryImpl(this.store);

  @override
  Future<List<Txn>> loadAll() async {
    // seed data lần đầu
    if (store.isEmpty) {
      final now = DateTime.now();
      await add(time: now.subtract(const Duration(hours: 1)), category: 'Ăn uống', amount: -55000, note: 'Cà phê');
      await add(time: now.subtract(const Duration(hours: 3)), category: 'Di chuyển', amount: -22000, note: 'Bus');
      await add(time: now.subtract(const Duration(days: 1)), category: 'Thu nhập', amount: 200000, note: 'Freelance');
    }
    final list = store.readAll().map((e) => Txn.fromMap(e)).toList()
      ..sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  @override
  Future<Txn> add({
    required DateTime time,
    required String category,
    required int amount,
    String? note,
  }) async {
    final txn = Txn(id: _uuid.v4(), time: time, category: category, amount: amount, note: note);
    await store.put(txn.id, txn.toMap());
    return txn;
  }

  @override
  Future<void> remove(String id) async => store.delete(id);

  @override
  Future<Map<String, int>> byCategory({DateTime? from, DateTime? to}) async {
    final out = <String, int>{};
    for (final e in store.readAll().map((e) => Txn.fromMap(e))) {
      if (from != null && e.time.isBefore(from)) continue;
      if (to != null && e.time.isAfter(to)) continue;
      out.update(e.category, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    return out;
  }
}
