import 'package:app_core/app_core.dart';
import 'package:flutter/services.dart';

extension NumFormatter on num {
  String formatNumberWithDots() {
    final formatter = NumberFormat('#,###', 'vi');
    return formatter.format(this);
  }

  String formatNumberClean() {
    if (this == roundToDouble()) {
      return toInt().toString();
    }

    return toStringAsFixed(
      10,
    ).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  int toPercentage(num total) {
    if (total == 0) return 0;

    final value = (this / total) * 100;
    if (value > 0 && value < 1) return 1;

    final decimal = value - value.floor();
    return decimal >= 0.51 ? value.ceil() : value.floor();
  }
}

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll('.', '').replaceAll(',', '');
    if (newText.isEmpty) return newValue;

    final number = int.tryParse(newText);
    if (number == null) return oldValue;

    final formatted = _formatter.format(number).replaceAll(',', '.');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
