import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/money.dart';
import '../../state/txn_provider.dart';
import '../../data/repositories/txn_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<TxnRepository>();
    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê')),
      body: FutureBuilder<Map<String, int>>(
        future: repo.byCategory(),
        builder: (context, snap) {
          final map = snap.data ?? {};
          final entries = map.entries.where((e) => e.value != 0).toList();

          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (entries.isEmpty) {
            return const _Empty();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: [
                            for (final e in entries)
                              PieChartSectionData(
                                value: e.value.abs().toDouble(),
                                title: e.key,
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (c, i) {
                      final e = entries[i];
                      final isOut = e.value < 0;
                      return Card(
                        child: ListTile(
                          title: Text(e.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          trailing: Text(
                            (isOut ? '-' : '+') + e.value.abs().vnd(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isOut ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pie_chart_outline, size: 64),
          SizedBox(height: 8),
          Text('Chưa có số liệu để vẽ biểu đồ'),
        ],
      ),
    );
  }
}
