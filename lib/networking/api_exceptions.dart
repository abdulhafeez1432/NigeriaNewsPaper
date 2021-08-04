import 'dart:convert';

import 'package:NewsApp/services/utils.dart';

class AppException implements Exception {
  final String _message;
  final String _prefix;
  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }

  String formatError(String error) {
    final Map<String, dynamic> responseError =
        json.decode(error) as Map<String, dynamic>;

    if (responseError['errors'] is String) {
      return responseError['errors'] as String;
    }

    if (responseError['errors'] is List) {
      return (responseError['errors'] as List).join('\n');
    }

    String returnData = "";
    if (responseError != null && responseError['errors'] is Map) {
      (responseError['errors']).forEach((String key, value) {
        returnData +=
            '${Utils.capitalizeFirstLetter(key)} \n\t\t ${value.toString()}\n\n';
      });
      return returnData.trim();
    }

    return error.trim();
  }

  String get message => formatError(_message);
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([String message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String message]) : super(message, "Unauthorised: ");
}

class TokenExpiredException extends AppException {
  TokenExpiredException([String message]) : super(message, "Token Expired: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
