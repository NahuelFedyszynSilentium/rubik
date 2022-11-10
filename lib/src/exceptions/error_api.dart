import '../enums/exception_type_enum.dart';

class ErrorApi implements Exception {
  final String msg;
  final ExceptionType? type;

  const ErrorApi({this.msg = "", this.type});
  @override
  String toString() => 'Error: $msg';
}
