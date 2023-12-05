import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      Response response = await _dio.post(
        'http://127.0.0.1:81/api/auth/register',
        data: data,
        // queryParameters: {'apikey': ApiSecret.apiKey},
        // options: Options(headers: {'X-LoginRadius-Sott': ApiSecret.sott})
      );
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://127.0.0.1:81/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        // queryParameters: {'apikey': ApiSecret.apiKey},
      );
      if (response.data == null) {
        return response.data['accessToken'] = null;
      }
      return response.data;
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<dynamic> getUserProfileData(String accessToken) async {
    try {
      Response response = await _dio.get(
        'http://127.0.0.1:81/api/auth/me',
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> updateUserProfile({
    required String accessToken,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await _dio.put(
        'http://127.0.0.1:81/api/auth/user-profile',
        data: data,
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> logout(String accessToken) async {
    try {
      Response response = await _dio.get(
        'http://127.0.0.1:81/api/auth/logout',
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> getRuanganData(String accessToken) async {
    try {
      Response response = await _dio.get(
        'http://127.0.0.1:81/api/ruangans/all',
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
