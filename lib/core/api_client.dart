import 'dart:convert';
import 'package:appssimaru/model/ruangan.dart';
import 'package:http/http.dart' show Client;
import '../model/booking.dart';

class ApiClient {
  Client client = Client();

  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      final response = await client.post(
        Uri.parse("https://simaru.amisbudi.cloud/api/auth/register"),
        body: data,
      );

      if (response.statusCode == 200) {
        // Parse response.body ke dalam bentuk Map
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Periksa apakah server mengembalikan status sukses
        if (responseBody['ErrorCode'] == null) {
          // Registrasi berhasil
          return responseBody;
        } else {
          // Registrasi gagal, kembalikan pesan error
          throw Exception('Registration failed: ${responseBody['Message']}');
        }
      } else {
        // Registrasi gagal karena status code bukan 200
        throw Exception(
            'Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani kesalahan lain yang mungkin terjadi
      throw Exception('Error during registration: $e');
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('https://simaru.amisbudi.cloud/api/auth/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<dynamic> getUserProfileData(String accessToken) async {
    try {
      final response = await client.get(
        Uri.parse('https://simaru.amisbudi.cloud/api/auth/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> logout(String accessToken) async {
    try {
      final response = await client.get(
        Uri.parse('https://simaru.amisbudi.cloud/api/auth/logout'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return ruanganFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Ruangan>> getRuanganData(String accessToken) async {
    try {
      final response = await client.get(
        Uri.parse('https://simaru.amisbudi.cloud/api/ruangans/all'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        return ruanganFromJson(response
            .body); // Menggunakan fungsi ruanganFromJson dari model ruangan.dart
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> addRuangan(
      String accessToken, Map<String, dynamic>? data) async {
    try {
      final response = await client.post(
        Uri.parse("https://simaru.amisbudi.cloud/api/ruangans/create"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json'
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> delRuangan(String accessToken, dynamic id) async {
    try {
      final response = await client.delete(
        Uri.parse("https://simaru.amisbudi.cloud/api/ruangans/$id/delete"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> updateRuangan(
      String accessToken, Map<String, dynamic>? data, dynamic id) async {
    try {
      final response = await client.post(
        Uri.parse("https://simaru.amisbudi.cloud/api/ruangans/$id/update"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json'
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Booking>> getBookingData(String accessToken) async {
    try {
      final response = await client.get(
        Uri.parse('https://simaru.amisbudi.cloud/api/bookings/all'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return bookingFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> addBooking(
      String accessToken, Map<String, dynamic>? data) async {
    try {
      final response = await client.post(
        Uri.parse("https://simaru.amisbudi.cloud/api/bookings/create"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> delBooking(String accessToken, dynamic id) async {
    try {
      final response = await client.delete(
        Uri.parse("https://simaru.amisbudi.cloud/api/bookings/$id/delete"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> updateBooking(
      String accessToken, Map<String, dynamic>? data, dynamic id) async {
    try {
      final response = await client.post(
        Uri.parse("https://simaru.amisbudi.cloud/api/bookings/$id/update"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Object>> getRuangans(String accessToken) async {
    try {
      final response = await client.get(
        Uri.parse('https://simaru.amisbudi.cloud/api/ruangans/all'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ruanganFromJson(response
            .body); // Menggunakan fungsi ruanganFromJson dari model ruangan.dart
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
