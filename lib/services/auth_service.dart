import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new2/services/secure_storage_service.dart';

class AuthService {
  final String baseUrl;
  final secureStorage = SecureStorage().secureStorage;

  AuthService(this.baseUrl);

  Future<void> signUp(String email, String username, String password, String role) async {
    try {

      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        await secureStorage.write(key: "role", value: responseBody["role"]);
        await secureStorage.write(key: "token", value: responseBody["accessToken"]);
        await secureStorage.write(key: "username", value: responseBody["username"]);
        await secureStorage.write(key: "group", value: responseBody["groupID"]);
        return responseBody["role"];
        print('Sign up successful');
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception('Conflict: ${response.body}');
      } else {
        throw Exception('Failed to sign up. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }
}
