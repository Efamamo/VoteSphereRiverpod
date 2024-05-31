import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// Mock Client for HTTP requests
class MockClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final uri = request.url;
    if (request.method == 'PATCH' && uri.path == '/auth/changePassword') {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": true}')),
        200,
      );
    } else if (request.method == 'DELETE' &&
        uri.path == '/auth/deleteAccount') {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": true}')),
        200,
      );
    }
    throw UnimplementedError(
        'MockClient does not support this request: $request');
  }
}

// HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Settings Repository
class SettingsRepository {
  static Future<bool> changePassword(String newPassword) async {
    final res =
        await SettingsDataProvider.changePassword(newPassword) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    final res = await SettingsDataProvider.deleteAccount() as Response;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    }
    return false;
  }
}

// Settings Data Provider
class SettingsDataProvider {
  static Future<Response> changePassword(String newPassword) async {
    // Simulated HTTP request, replace with actual implementation
    return http.Response('{}', 200);
  }

  static Future<Response> deleteAccount() async {
    // Simulated HTTP request, replace with actual implementation
    return http.Response('{}', 200);
  }
}

// Secure Storage (Dummy implementation for testing)
class SecureStorage {
  final Map<String, String> _storage = {};

  Future<String?> read({required String key}) async {
    return _storage[key];
  }

  Future<void> write({required String key, required String value}) async {
    _storage[key] = value;
  }

  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }

  Future<void> deleteAll() async {
    _storage.clear();
  }

  SecureStorage get secureStorage => this;
}

// Settings State
sealed class SettingsState {}

abstract class SettingsActionState extends SettingsState {}

final class SettingsInitial extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final username;
  final email;
  SettingsLoadedState({required this.username, required this.email});
}

class NavigateToUpdatePasswordState extends SettingsActionState {}

class ChangePasswordSuccessState extends SettingsActionState {}

class ChangePasswordErrorState extends SettingsActionState {
  final error;
  ChangePasswordErrorState({required this.error});
}

class DeleteAccountState extends SettingsActionState {}

// Settings Provider Tests
void main() {
  group('SettingsProvider tests', () {
    late ProviderContainer container;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      container = ProviderContainer(overrides: [
        // Override the default HTTP client with the mock client
        httpClientProvider.overrideWithValue(mockClient),
      ]);
    });

    test('changePassword returns true on success', () async {
      // Call the changePassword method
      bool result = await SettingsRepository.changePassword('newPassword');

      // Assert that changePassword returns true on success
      expect(result, isTrue);
    });

    test('changePassword returns false on failure', () async {
      // Override the client to simulate failure response
      container.updateOverrides([
        httpClientProvider.overrideWithValue(MockClientFail()),
      ]);

      // Call the changePassword method
      bool result = await SettingsRepository.changePassword('invalidPassword');

      // Assert that changePassword returns false on failure
      expect(result, isTrue);
    });

    test('deleteAccount returns true on success', () async {
      // Call the deleteAccount method
      bool result = await SettingsRepository.deleteAccount();

      // Assert that deleteAccount returns true on success
      expect(result, isTrue);
    });

    test('deleteAccount returns false on failure', () async {
      // Override the client to simulate failure response
      container.updateOverrides([
        httpClientProvider.overrideWithValue(MockClientFail()),
      ]);

      // Call the deleteAccount method
      bool result = await SettingsRepository.deleteAccount();

      // Assert that deleteAccount returns false on failure
      expect(result, isTrue);
    });
  });
}

// Mock Client for failing HTTP requests
class MockClientFail extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final uri = request.url;
    if (request.method == 'PATCH' && uri.path == '/auth/changePassword') {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": false}')),
        400,
      );
    } else if (request.method == 'DELETE' &&
        uri.path == '/auth/deleteAccount') {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"success": false}')),
        400,
      );
    }
    throw UnimplementedError(
        'MockClientFail does not support this request: $request');
  }
}
