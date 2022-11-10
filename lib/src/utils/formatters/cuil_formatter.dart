import 'package:flutter/services.dart';

class CuilFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int selectionIndex;

    String oldText = oldValue.text;
    String newText = newValue.text;

    int newTextLength = newText.length;
    int oldTextLength = oldText.length;

    if (newText.isNotEmpty) {
      if (newText.substring(newText.length - 1, newText.length) == ".") {
        newText = oldText;
      }
    }

    if (newTextLength == 2 && oldTextLength == 1) {
      newText += '-';
    } else if (newTextLength == 11 && oldTextLength == 10) {
      newText += '-';
    } else if ((newTextLength == 3 && oldTextLength == 4) ||
        (newTextLength == 12 && oldTextLength == 13)) {
      newText = newText.substring(0, newText.length - 1);
    } else if ((newTextLength == 3 && oldTextLength == 2) ||
        (newTextLength == 12 && oldTextLength == 11)) {
      newText =
          '${newText.substring(0, oldTextLength)}-${newText.substring(oldTextLength, oldTextLength + 1)}';
    }

    selectionIndex = newText.length;
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
