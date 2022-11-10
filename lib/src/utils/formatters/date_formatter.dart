import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int selectionIndex;

    String oldText = oldValue.text;
    String newText = newValue.text;

    int newTextLength = newText.length;
    int oldTextLength = oldText.length;

    if (newTextLength == 2 && oldTextLength == 1) {
      newText += '/';
    } else if (newTextLength == 5 && oldTextLength == 4) {
      newText += '/';
    } else if ((newTextLength == 3 && oldTextLength == 4) ||
        (newTextLength == 6 && oldTextLength == 7)) {
      newText = newText.substring(0, newText.length - 1);
    } else if ((newTextLength == 3 && oldTextLength == 2) ||
        (newTextLength == 6 && oldTextLength == 5)) {
      newText =
          '${newText.substring(0, oldTextLength)}/${newText.substring(oldTextLength, oldTextLength + 1)}';
    }

    selectionIndex = newText.length;
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
