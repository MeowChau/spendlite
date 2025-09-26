import 'package:flutter/material.dart';
Row(children: [
Expanded(child: Text('Thời gian: ' + DateFormat('dd/MM/yyyy HH:mm').format(_time))),
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
icon: const Icon(Icons.schedule_outlined), label: const Text('Chọn'),
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
child: Text('Lưu'),
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