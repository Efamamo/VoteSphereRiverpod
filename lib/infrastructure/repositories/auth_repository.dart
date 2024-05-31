import '../data_provider/auth_dataprovider.dart';
import '../local_storage/secure_storage.dart';

class AuthRepository {
  // Login
  static Future<String> login(String username, String password) async {
    Map response = await AuthDataProvider.login(username, password);

    if (response.containsKey('message')) {
      var error = response["message"];
      if (error is! String) {
        error = error[0];
      }
      return error;
    } else {
      final secureStorage = SecureStorage().secureStorage;
      await secureStorage.write(key: "role", value: response["role"]);
      await secureStorage.write(key: "token", value: response["accessToken"]);
      await secureStorage.write(key: "username", value: response["username"]);
      await secureStorage.write(key: "group", value: response["groupID"]);
      await secureStorage.write(key: "email", value: response["email"]);
      return "success";
    }
  }

  // Registration
  static Future<String> signUp(
      String username, String password, String email, String role) async {
    Map response =
        await AuthDataProvider.signUp(username, password, email, role);

    if (response.containsKey('message')) {
      var error = response["message"];
      if (error is! String) {
        error = error[0];
      }
      return error;
    } else {
      final secureStorage = SecureStorage().secureStorage;
      await secureStorage.write(key: "role", value: response["role"]);
      await secureStorage.write(key: "token", value: response["accessToken"]);
      await secureStorage.write(key: "username", value: response["username"]);
      await secureStorage.write(key: "group", value: response["groupID"]);
      await secureStorage.write(key: "email", value: response["email"]);
      return "success";
    }
  }

  // Signout
  static Future<void> signout() async {
    final secureStorage = SecureStorage().secureStorage;
    await secureStorage.deleteAll();
  }
}
