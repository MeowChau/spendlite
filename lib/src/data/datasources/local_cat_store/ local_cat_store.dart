import 'package:hive_flutter/hive_flutter.dart';

class LocalCatStore {
  static const boxName = 'cats';

  static Future<void> ensureOpened() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  Box get _box => Hive.box(boxName);

  List<String> readAll() {
    final list = _box.get('list', defaultValue: <String>[])!.cast<String>();
    return List<String>.from(list);
  }

  Future<void> writeAll(List<String> cats) async {
    await _box.put('list', cats);
  }

  bool get isEmpty => readAll().isEmpty;
}
