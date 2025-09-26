import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/money.dart';
import '../../data/repositories/txn_repository.dart';

// ==== Bảng màu rực rỡ + hàm lấy màu theo danh mục ====
const _vibrantPalette = <Color>[
  Color(0xFFE91E63), // pink
  Color(0xFFFF5722), // deep orange
  Color(0xFFFFC107), // amber
  Color(0xFF4CAF50), // green
  Color(0xFF00BCD4), // cyan
  Color(0xFF2196F3), // blue
  Color(0xFF3F51B5), // indigo
  Color(0xFF9C27B0), // purple
  Color(0xFFFF9800), // orange
  Color(0xFF8BC34A), // light green
  Color(0xFF009688), // teal
  Color(0xFF795548), // brown
];

Color _colorForCategory(String cat) {
  final code = cat.runes.fold<int>(0, (p, c) => (p + c) & 0x7fffffff);
  return _vibrantPalette[code % _vibrantPalette.length];
}

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
                      height: 240,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          // ==== KHỐI sections ĐÃ SỬA CHUẨN ====
                          sections: [
                            for (final e in entries)
                              PieChartSectionData(
                                value: e.value.abs().toDouble(),
                                title: e.key,
                                color: _colorForCategory(e.key),
                                radius: 64,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                titlePositionPercentageOffset: .6,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Legend gọn gàng khớp màu
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final e in entries)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                          _colorForCategory(e.key).withOpacity(.12),
                          borderRadius: BorderRadius.circular(999),
                          border:
                          Border.all(color: _colorForCategory(e.key)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _colorForCategory(e.key),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              e.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Danh sách chi tiết theo danh mục
                Expanded(
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (c, i) {
                      final e = entries[i];
                      final isOut = e.value < 0;
                      return Card(
                        child: ListTile(
                          title: Text(
                            e.key,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: Text(
                            (isOut ? '-' : '+') + e.value.abs().vnd(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color:
                              isOut ? Colors.red : Colors.green,
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
