import '../datasources/local_cat_store.dart';

abstract class CatRepository {
  Future<List<String>> loadAll();
  Future<void> add(String name);
  Future<void> rename(String oldName, String newName);
  Future<void> remove(String name);
}

class CatRepositoryImpl implements CatRepository {
  final LocalCatStore store;
  CatRepositoryImpl(this.store);

  @override
  Future<List<String>> loadAll() async {
    if (store.isEmpty) {
      await store.writeAll(const ['Ăn uống', 'Di chuyển', 'Hóa đơn', 'Thu nhập']);
    }
    final list = store.readAll()..sort();
    return list;
  }

  @override
  Future<void> add(String name) async {
    final list = store.readAll();
    if (!list.contains(name)) {
      list.add(name);
      list.sort();
      await store.writeAll(list);
    }
  }

  @override
  Future<void> rename(String oldName, String newName) async {
    final list = store.readAll();
    final idx = list.indexOf(oldName);
    if (idx != -1) {
      list[idx] = newName;
      list.sort();
      await store.writeAll(list);
    }
  }

  @override
  Future<void> remove(String name) async {
    final list = store.readAll()..remove(name);
    await store.writeAll(list);
  }
}
