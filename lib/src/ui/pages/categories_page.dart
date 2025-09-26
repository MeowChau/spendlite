import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/cat_provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: p.cats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (c, i) {
          final name = p.cats[i];
          return Dismissible(
            key: ValueKey(name),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.1),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete_outline),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => p.remove(name),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final newName = await _promptName(context, hint: 'Sửa danh mục', initial: name);
                  if (newName != null) await p.rename(name, newName);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final name = await _promptName(context, hint: 'Tên danh mục mới');
          if (name != null) await p.add(name);
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm'),
      ),
    );
  }

  Future<String?> _promptName(BuildContext context, {required String hint, String? initial}) async {
    final ctl = TextEditingController(text: initial ?? '');
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(hint),
        content: TextField(
          controller: ctl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tên'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(c, ctl.text.trim()), child: const Text('Lưu')),
        ],
      ),
    );
  }
}
