import 'dart:convert';
import 'dart:io';

import 'package:NewsApp/networking/api_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  // final String _baseUrl = kReleaseMode ? 'api.studybeta.com.ng' : 'ec2-3-136-159-35.us-east-2.compute.amazonaws.com';
  static const String _baseUrl = 'api.allnigerianewspapers.com.ng';

  static String getBaseURL() => _baseUrl;

  Map<String, String> configHeader({String token}) {
    if (token != null) {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    } else {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };
    }
  }

  Future<dynamic> get({
    String url,
    Map<String, String> headers,
    Map<String, String> queryParameters,
    bool useUrlParamOnly = false,
  }) async {
    dynamic responseJson;
    // final uri = Uri.https(_baseUrl, '/api/$url', queryParameters);
    final uri = useUrlParamOnly
        ? url
        : Uri.https(_baseUrl, '/api/$url', queryParameters);
    try {
      final response = await http.get(
        uri,
        headers: headers,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('{"errors": "No Internet connection"}');
    }
    return responseJson;
  }

  Future<dynamic> post(
      {String url,
      Map<String, dynamic> body,
      Map<String, String> headers}) async {
    dynamic responseJson;
    // final uri = Uri.https(_baseUrl, '/api/$url');
    final uri = Uri.https(_baseUrl, '/api/$url');
    try {
      final response =
          await http.post(uri, body: jsonEncode(body), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('{"errors": "No Internet connection"}');
    }
    return responseJson;
  }

  Future<dynamic> put(
      {String url,
      Map<String, dynamic> body,
      Map<String, String> headers}) async {
    dynamic responseJson;
    final uri = Uri.https(_baseUrl, '/api/$url');
    try {
      final response =
          await http.put(uri, body: jsonEncode(body), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('{"errors": "No Internet connection"}');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw TokenExpiredException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(response.body.toString());
    }
  }
}
