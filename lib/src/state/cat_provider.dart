import 'package:flutter/material.dart';
import '../data/repositories/cat_repository.dart';

class CatProvider extends ChangeNotifier {
  final CatRepository repo;
  CatProvider(this.repo);

  final List<String> _cats = [];
  List<String> get cats => List.unmodifiable(_cats);

  Future<void> load() async {
    final list = await repo.loadAll();
    _cats..clear()..addAll(list);
    notifyListeners();
  }

  Future<void> add(String name) async {
    if (name.trim().isEmpty) return;
    await repo.add(name.trim());
    await load();
  }

  Future<void> rename(String oldName, String newName) async {
    if (newName.trim().isEmpty) return;
    await repo.rename(oldName, newName.trim());
    await load();
  }

  Future<void> remove(String name) async {
    await repo.remove(name);
    await load();
  }
}
