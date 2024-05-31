import 'package:http/http.dart%20';
import '../data_provider/home_dataprovider.dart';

import '../local_storage/secure_storage.dart';

import 'dart:convert';

class HomeRespository {
  static Future<Map> loadHome() async {
    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: "group");
    final role = await secureStorage.read(key: 'role');
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');
    final email = await secureStorage.read(key: 'email');

    if (group == null) {
      return {
        "group": group,
        "role": role,
        "username": username,
        "token": token,
        "email": email
      };
    } else {
      final res = await HomeDataProvider.loadHome() as Response;
      final jsonBody = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final polls = jsonBody;

        return {
          "group": group,
          "role": role,
          "username": username,
          "token": token,
          "polls": polls,
          "email": email
        };
      } else {
        return {
          "group": group,
          "role": role,
          "username": username,
          "token": token,
          "email": email
        };
      }
    }
  }

  static Future<bool> createGroup(groupName) async {
    try {
      final secureStorage = SecureStorage().secureStorage;

      final res = await HomeDataProvider.createGroup(groupName) as Response;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        Map response = jsonDecode(res.body);

        await secureStorage.write(key: 'group', value: response["groupID"]);
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> addPole(question, options) async {
    try {
      final secureStorage = SecureStorage().secureStorage;
      final group = await secureStorage.read(key: 'group');
      final token = await secureStorage.read(key: 'token');

      if (group == null || token == null) {
        return false;
      }

      final res = await HomeDataProvider.addPole(question, options) as Response;

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> deletePoll(pollId) async {
    final res = await HomeDataProvider.deletePoll(pollId) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> vote(pollId, optionId) async {
    final res = await HomeDataProvider.vote(pollId, optionId) as Response;

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addComment(pollId, comment) async {
    final res = await HomeDataProvider.addComment(pollId, comment) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateComment(comment, comId) async {
    ;

    final res =
        await HomeDataProvider.updateComment(comment, comId) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteComment(String comId) async {
    final res = await HomeDataProvider.deleteComment(comId) as Response;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    }
    return false;
  }

  static Future<Map> getMembers() async {
    final secureStorage = SecureStorage().secureStorage;

    final role = await secureStorage.read(key: 'role');

    final res = await HomeDataProvider.getMembers() as Response;
    print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decodedBody = jsonDecode(res.body);
      return {"members": decodedBody, "role": role};
    }
    return {"error": "error"};
  }

  static Future<bool> addMember(String username) async {
    try {
      // Retrieve the token and group from secure storage

      final res = await HomeRespository.addMember(username) as Response;
      print(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<bool> deleteMember(String username) async {
    final res = await HomeDataProvider.deleteMember(username) as Response;

    try {
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
