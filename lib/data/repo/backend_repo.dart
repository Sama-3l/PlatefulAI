import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:platefulai/utils/backend_connection.dart';

String domain = BackendConnection.baseUrl;

class BackendRepo {
  Future<http.Response> signInUser(String apiUrl) async {
    try {
      String url = domain + apiUrl;
      Map<String, String> header = {
        'Content-Type': 'application/json'
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> callUserGetMethod(String apiUrl, String token) async {
    try {
      String url = domain + apiUrl;
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      http.Response response = await http.get(Uri.parse(url), headers: header);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> callPostMethod(String apiUrl, Map<String, dynamic> body) async {
    try {
      String url = domain + apiUrl;
      Map<String, String> header = {
        'Content-Type': 'application/json'
      };

      http.Response response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: header);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> callUserPostMethod(String apiUrl, Map<String, dynamic> body, String token) async {
    try {
      String url = domain + apiUrl;
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      http.Response response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: header);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> callUserPutMethod(String apiUrl, Map<String, dynamic> body, String token) async {
    try {
      String url = domain + apiUrl;
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      http.Response response = await http.put(Uri.parse(url), body: jsonEncode(body), headers: header);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
