import '../local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeDataProvider {
  static Future<Object> loadHome() async {
    final group = await SecureStorage().secureStorage.read(key: "group");
    final token = await SecureStorage().secureStorage.read(key: "token");

    String uri = 'http://10.0.2.2:9000/polls?groupId=$group';

    final url = Uri.parse(uri);
    final res =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    return res;
  }

  static Future<Object> createGroup(groupName) async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/groups';
    final url = Uri.parse(uri);
    final body = {"adminUsername": username, "groupName": groupName};
    print(body);
    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: jsonBody);

    return res;
  }

  static Future<Object> addPole(question, options) async {
    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: 'group');
    final token = await secureStorage.read(key: 'token');

    if (group == null || token == null) {
      return false;
    }

    String uri = 'http://10.0.2.2:9000/polls';
    final url = Uri.parse(uri);
    final body = {
      "poll": {"question": question, "options": options},
      "groupID": group
    };

    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: jsonBody);
    return res;
  }

  static Future<Object> deletePoll(pollId) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls/${pollId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);
    return res;
  }

  static Future<Object> vote(pollId, optionId) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri =
        'http://10.0.2.2:9000/polls/${pollId}/vote?optionId=${optionId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers);
    return res;
  }

  static Future<Object> addComment(pollId, comment) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri = 'http://10.0.2.2:9000/polls/comments';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final body = {"pollId": pollId, "commentText": comment};
    final jsonBody = jsonEncode(body);
    final res = await http.post(url, headers: headers, body: jsonBody);
    return res;
  }

  static Future<Object> updateComment(comment, comId) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls/comments/${comId}';
    final url = Uri.parse(uri);
    final body = {"commentText": comment};

    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers, body: jsonBody);

    return res;
  }

  static Future<Object> deleteComment(String comId) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls/comments/${comId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);
    return res;
  }

  static Future<Object> getMembers() async {
    final secureStorage = SecureStorage().secureStorage;

    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');
    final role = await secureStorage.read(key: 'role');

    String uri = 'http://10.0.2.2:9000/groups/${group}/members';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.get(url, headers: headers);
    return res;
  }

  static Future<Object> addMember(String username) async {
    // Retrieve the token and group from secure storage
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://10.0.2.2:9000/groups/$group/members';
    final url = Uri.parse(uri);

    final body = {"username": username};
    final encodedBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: encodedBody);
    return res;
  }

  static Future<Object> deleteMember(String username) async {
    final secureStorage = SecureStorage().secureStorage;

    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://10.0.2.2:9000/groups/${group}/members';

    final body = {"username": username};
    final encodedBody = jsonEncode(body);
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers, body: encodedBody);

    return res;
  }
}
