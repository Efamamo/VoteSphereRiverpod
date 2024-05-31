import 'dart:convert';

import 'package:http/http.dart%20';
import '../data_provider/settings_dataprovider.dart';
import '../local_storage/secure_storage.dart';

class SettingsRepository {
  static Future<Map> loadSetting() async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final email = await secureStorage.read(key: "email");

    return {"username": username, "email": email};
  }

  static Future<String> changePassword(newPassword) async {
    final res =
        await SettingsDataProvider.changePassword(newPassword) as Response;
    print(res.statusCode);
    if (res.statusCode == 200) {
      return "success";
    } else {
      final decodedBody = jsonDecode(res.body);
      var error = decodedBody["message"];
      if (decodedBody["message"] is! String) {
        error = decodedBody["message"][0];
      }
      return error;
    }
  }

  static Future<bool> deleteAccount() async {
    final secureStorage = SecureStorage().secureStorage;

    final res = await SettingsDataProvider.deleteAccount() as Response;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      await secureStorage.deleteAll();
      return true;
    } else {
      return false;
    }
  }
}
