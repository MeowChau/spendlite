import 'package:hive_flutter/hive_flutter.dart';

class LocalTxnStore {
  static const boxName = "txns";
  static Future<void> ensureOpened() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  Box get _box => Hive.box(boxName);

  Iterable<Map<String, dynamic>> readAll() sync* {
    for (final v in _box.values) {
      yield Map<String, dynamic>.from(v);
    }
  }

  Future<void> put(String id, Map<String, dynamic> map) async => _box.put(id, map);
  Future<void> delete(String id) async => _box.delete(id);
  bool get isEmpty => _box.isEmpty;
}
