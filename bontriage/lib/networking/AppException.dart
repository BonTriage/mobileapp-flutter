import 'package:mobile/util/constant.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message ?? Constant.blankString, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message ?? Constant.blankString, "Unauthorized Client Error");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message ?? Constant.blankString, "Invalid Input: ");
}

class ServerResponseException extends AppException{
  ServerResponseException([String message]) : super(message ?? Constant.blankString, "Server Error");
}

class NoInternetConnection extends AppException{
  NoInternetConnection([String message]) : super(message ?? Constant.blankString, "No Internet Connection: ");
}

