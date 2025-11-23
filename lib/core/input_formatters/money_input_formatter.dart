import 'package:flutter/services.dart';

class MoneyInputFormatter extends TextInputFormatter {
  const MoneyInputFormatter();

  // Permite digitação sequencial sem formatação prematura.
  // Regras: somente dígitos e um ponto, máximo 2 casas após ponto.
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String text = newValue.text;
    final RegExp allowed = RegExp(r'^[0-9.]*$');
    if (!allowed.hasMatch(text)) {
      return oldValue;
    }
    final int dots = '.'.allMatches(text).length;
    if (dots > 1) {
      return oldValue;
    }
    final int dotIndex = text.indexOf('.');
    if (dotIndex != -1) {
      final int decimals = text.length - dotIndex - 1;
      if (decimals > 2) {
        return oldValue;
      }
    }
    int sel = newValue.selection.baseOffset;
    if (sel < 0) sel = 0;
    if (sel > text.length) sel = text.length;
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: sel));
  }

  static String formatFinal(String input) {
    final String t = input.trim();
    if (t.isEmpty || t == '.') return '';
    final double? val = double.tryParse(t);
    if (val == null) return input;
    return val.toStringAsFixed(2);
  }
}