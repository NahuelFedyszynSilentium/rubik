import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../values/k_strings.dart';
import '../managers/page_manager.dart';
import '../support/network/network.dart';

String currencyFormat(num? price) {
  return price != null ? NumberFormat("#,##0.00", "en_US").format(price) : "";
}

String currencyFormatNoDecimal(num? price) {
  return price != null ? NumberFormat("#,##0", "en_US").format(price) : "";
}

String phoneCodeZoneFormat(String? phone, {String separator = "-"}) {
  var list = phone?.split(separator);
  if (list != null && list.isNotEmpty) {
    return list[0];
  }
  return "-";
}

String phoneNumberFormat(String? phone, {String separator = "-"}) {
  var list = phone?.split(separator);
  if (list != null && list.length == 2) {
    return list[1];
  }
  return "-";
}

String dateFormat(DateTime? date) {
  return date != null ? DateFormat("dd/MM/yyyy").format(date) : "";
}

String dateFormatNoDay(DateTime? date) {
  return date != null ? DateFormat("MM/yyyy").format(date) : "";
}

String dateTextFormatNoDay(String? date) {
  return date != null
      ? "${date.substring(0, 4)}/${date.substring(4, date.length)}"
      : "";
}

String dateTextFormatNoDayMonthFirst(String? date) {
  return date != null
      ? "${date.substring(4, date.length)}/${date.substring(0, 4)}"
      : "";
}

String dateFormatYearFirst(DateTime? date) {
  return date != null ? DateFormat("yyyy-MM-dd").format(date) : "";
}

String dateFormatForCSVFilesNames() {
  return "${DateFormat("d-M-y_H").format(DateTime.now())}h${DateFormat("m").format(DateTime.now())}m";
}

onErrorLoadingPopUp({required HttpResult? error, onRetry}) {
  switch (error?.type) {
    case HttpCodesEnum.e401_Unauthorized:
      return PageManager().doLogout();
    case HttpCodesEnum.s204_NoContent:
      return PageManager()
          .openDefaultErrorAlert(KDefaultErrorMessage, onRetry: onRetry);
    case HttpCodesEnum.e500_InternalServerError:
      return PageManager().openDefaultErrorAlert(KDefaultErrorServerConnection,
          onRetry: onRetry);
    case HttpCodesEnum.NoInternetConnection:
      return PageManager().openDefaultErrorAlert(KDefaultNoInternetConnection,
          onRetry: onRetry);
    default:
      return PageManager()
          .openDefaultErrorAlert(KDefaultErrorMessage, onRetry: onRetry);
  }
}

onErrorFunction(
    {required BuildContext context, required HttpResult? error, onRetry}) {
  switch (error!.type) {
    case HttpCodesEnum.e401_Unauthorized:
      return PageManager().doLogout();
    case HttpCodesEnum.s204_NoContent:
      return PageManager()
          .openDefaultErrorAlert(KDefaultErrorMessage, onRetry: onRetry);
    case HttpCodesEnum.e422_UnprocessableEntity:
      return PageManager().openDefaultErrorAlert(error.msg, onRetry: onRetry);
    case HttpCodesEnum.e500_InternalServerError:
      return PageManager().goMaintenancePage();
    case HttpCodesEnum.NoInternetConnection:
      return PageManager().openDefaultErrorAlert(KDefaultNoInternetConnection,
          onRetry: onRetry);
    default:
      return PageManager()
          .openDefaultErrorAlert(KDefaultErrorMessage, onRetry: onRetry);
  }
}

String? getStringAfterLastSlash(String? input) {
  if (input != null) {
    return RegExp(r'[^\/]+$').stringMatch(input);
  } else {
    return null;
  }
}

String stripHtmlIfNeeded(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
}

bool isNumericUsingRegularExpression(String string) {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}

num? getYearFromDDMMYYYY(String input) {
  // FORMATO: DD/MM/YYYY
  if (input.length == 10) {
    String temp = input.substring(6, 10);
    try {
      return num.parse(temp);
    } catch (e) {
      return null;
    }
  } else {
    return null;
  }
}

num? getYearFromMMYYYY(String input) {
  // FORMATO: MM/YYYY
  if (input.length == 7) {
    String temp = input.substring(3, 7);
    try {
      return num.parse(temp);
    } catch (e) {
      return null;
    }
  } else {
    return null;
  }
}

num? getMonthFromMMYYYY(String input) {
  // FORMATO: MM/YYYY
  if (input.length == 7) {
    String temp = input.substring(0, 2);
    try {
      return num.parse(temp);
    } catch (e) {
      return null;
    }
  } else {
    return null;
  }
}

String periodFormatter(String? input) {
  if (input == null || input.length != 6) {
    return input.toString();
  } else {
    String result = "";
    for (int i = 0; i < input.length; i++) {
      result += input[i];
      if (i == 3) {
        result += "/";
      }
    }
    return result;
  }
}
