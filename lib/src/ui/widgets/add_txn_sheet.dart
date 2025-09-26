import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "../../state/txn_provider.dart";
import '../../state/cat_provider.dart';

class AddTxnSheet extends StatefulWidget {
  const AddTxnSheet({super.key});
  @override
  State<AddTxnSheet> createState() => _AddTxnSheetState();
}

class _AddTxnSheetState extends State<AddTxnSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtl = TextEditingController();
  final _noteCtl = TextEditingController();
  DateTime _time = DateTime.now();
  String _cat = "Ăn uống";

  @override
  void dispose() {
    _amountCtl.dispose();
    _noteCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4)),
              ),
              const Text("Thêm giao dịch", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _cat,
                    items: const [
                      DropdownMenuItem(value: "Ăn uống", child: Text("Ăn uống")),
                      DropdownMenuItem(value: "Di chuyển", child: Text("Di chuyển")),
                      DropdownMenuItem(value: "Hóa đơn", child: Text("Hóa đơn")),
                      DropdownMenuItem(value: "Thu nhập", child: Text("Thu nhập")),
                    ],
                    onChanged: (v) => setState(() => _cat = v ?? _cat),
                    decoration: const InputDecoration(labelText: "Danh mục"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _amountCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Số tiền (âm = chi, dương = thu)"),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Nhập số tiền";
                      if (int.tryParse(v.trim()) == null) return "Số không hợp lệ";
                      return null;
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtl,
                decoration: const InputDecoration(labelText: "Ghi chú (không bắt buộc)"),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Text("Thời gian: ${DateFormat('dd/MM/yyyy HH:mm').format(_time)}")),
                TextButton.icon(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _time,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (d == null) return;
                    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_time));
                    final dt = DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0);
                    setState(() => _time = dt);
                  },
                  icon: const Icon(Icons.schedule_outlined), label: const Text("Chọn"),
                ),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final amount = int.parse(_amountCtl.text.trim());
                    await context.read<TxnProvider>().add(
                      time: _time,
                      category: _cat,
                      amount: amount,
                      note: _noteCtl.text.trim().isEmpty ? null : _noteCtl.text.trim(),
                    );
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Lưu"),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
