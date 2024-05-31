import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local_storage/secure_storage.dart';

class AuthDataProvider {
  static Future<Map> login(String username, String password) async {
    String uri = 'http://10.0.2.2:9000/auth/signin';
    final url = Uri.parse(uri);

    final body = {"username": username, "password": password};
    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);
    return response;
  }

  static Future<Map> signUp(
      String username, String password, String email, String role) async {
    String uri = 'http://10.0.2.2:9000/auth/signup';
    final url = Uri.parse(uri);

    final body = {
      "username": username,
      "role": role,
      "email": email,
      "password": password
    };

    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);
    return response;
  }

  static Future<void> signout() async {
    final secureStorage = SecureStorage().secureStorage;
    await secureStorage.deleteAll();
  }
}
