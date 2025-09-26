import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "../../core/utils/money.dart";
import "../../state/txn_provider.dart";
import "../widgets/add_txn_sheet.dart";
import "categories_page.dart";

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TxnProvider>();
    final today = DateTime.now();
    final totalToday = p.totalForDay(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpendLite'),
        centerTitle: true, // <--- Đặt ĐÚNG ở trong AppBar
        actions: [
          IconButton(
            tooltip: 'Danh mục',
            icon: const Icon(Icons.folder_open_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoriesPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _TodayCard(total: totalToday),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: p.items.isEmpty
                ? _EmptyView(onAdd: () => _openAdd(context))
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (c, i) => _TxnTile(i: i),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: p.items.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAdd(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm'),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTxnSheet(),
    );
  }
}

class _TxnTile extends StatelessWidget {
  final int i;
  const _TxnTile({required this.i});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<TxnProvider>();
    final e = p.items[i];
    final fDate = DateFormat('dd/MM, HH:mm').format(e.time);
    final isOut = e.amount < 0;

    return Dismissible(
      key: ValueKey(e.id),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.1),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.1),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => p.remove(e.id),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(radius: 22, child: Icon(_iconFor(e.category))),
          title: Text(e.category, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(fDate),
          trailing: Text(
            (isOut ? '-' : '+') + e.amount.abs().vnd(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isOut ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String cat) {
    switch (cat) {
      case 'Ăn uống':
        return Icons.restaurant_outlined;
      case 'Di chuyển':
        return Icons.directions_bus_outlined;
      case 'Hóa đơn':
        return Icons.receipt_long_outlined;
      case 'Thu nhập':
        return Icons.savings_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}

class _TodayCard extends StatelessWidget {
  final int total;
  const _TodayCard({required this.total});
  @override
  Widget build(BuildContext context) {
    final isNeg = total < 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.today_outlined),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Tổng hôm nay',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              (isNeg ? '-' : '+') + total.abs().vnd(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isNeg ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyView({required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 64),
          const SizedBox(height: 12),
          const Text('Chưa có giao dịch', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Nhấn nút Thêm để tạo giao dịch đầu tiên'),
          const SizedBox(height: 16),
          FilledButton.tonal(onPressed: onAdd, child: const Text('Thêm ngay')),
        ],
      ),
    );
  }
}
