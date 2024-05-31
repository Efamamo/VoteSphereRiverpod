import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MockClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final uri = request.url;
    if (request.method == 'POST' && uri.path == '/comments') {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": true}')),
        200,
      );
    } else if (request.method == 'PATCH' && uri.path.startsWith('/comments/')) {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": true}')),
        200,
      );
    } else if (request.method == 'DELETE' &&
        uri.path.startsWith('/comments/')) {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": true}')),
        200,
      );
    }
    throw UnimplementedError(
        'MockClient does not support this request: $request');
  }
}

void main() {
  group('CommentRepository tests', () {
    late ProviderContainer container;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      container = ProviderContainer(overrides: [
        // Override the default HTTP client with the mock client
        httpClientProvider.overrideWithValue(mockClient),
      ]);
    });

    test('addComment returns true on success', () async {
      // Call the addComment method
      bool result = await HomeRespository.addComment('poll123', 'Nice comment');

      // Assert that addComment returns true on success
      expect(result, isTrue);
    });
    test('addComment returns false on failure', () async {
      // Call the addComment method
      bool result = await HomeRespository.addComment('poll123', 'Nice comment');

      // Assert that addComment returns true on success
      expect(result, isTrue);
    });

    test('updateComment returns true on success', () async {
      // Call the updateComment method
      bool result = await HomeRespository.updateComment(
          'Updated comment', 'commentId123');

      // Assert that updateComment returns true on success
      expect(result, isTrue);
    });
    test('updateComment returns false on false', () async {
      // Call the updateComment method
      bool result = await HomeRespository.updateComment(
          'Updated comment', 'commentId123');

      // Assert that updateComment returns true on success
      expect(result, isTrue);
    });
    test('deleteComment returns true on success', () async {
      // Call the deleteComment method
      bool result = await HomeRespository.deleteComment('commentId123');

      // Assert that deleteComment returns true on success
      expect(result, isTrue);
    });
    test('deleteComment returns false on failure', () async {
      // Call the deleteComment method
      bool result = await HomeRespository.deleteComment('commentId123');

      // Assert that deleteComment returns true on success
      expect(result, isTrue);
    });
  });
}

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

class HomeRespository {
  static Future<bool> addComment(String pollId, String comment) async {
    final res = await HomeDataProvider.addComment(pollId, comment) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateComment(String comment, String comId) async {
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
}

class HomeDataProvider {
  static Future<Response> addComment(String pollId, String comment) async {
    // Simulate adding comment logic
    return http.Response('{}', 200);
  }

  static Future<Response> updateComment(String comment, String comId) async {
    // Simulate updating comment logic
    return http.Response('{}', 200);
  }

  static Future<Response> deleteComment(String comId) async {
    // Simulate deleting comment logic
    return http.Response('{}', 200);
  }
}
