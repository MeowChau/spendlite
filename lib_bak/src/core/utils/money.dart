import 'package:intl/intl.dart';
extension MoneyFmt on num {
  String vnd() => NumberFormat.decimalPattern().format(this) + ' ₫';
}