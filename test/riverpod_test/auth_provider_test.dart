import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:new2/application/providers/auth_provider.dart';
import 'package:new2/presentation/states/auth_state.dart';
import 'package:riverpod/riverpod.dart';
import 'auth_provider_test.mocks.dart';

@GenerateMocks([])
void main() {
  late ProviderContainer container;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    container = ProviderContainer(overrides: [
      authProvider.overrideWithProvider(
        StateNotifierProvider<AuthNotifier, AuthState>(
          (ref) => FakeAuthNotifier(),
        ),
      ),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthProvider Tests', () {
    test('initial state is AuthInitial', () {
      expect(container.read(authProvider), isA<AuthInitial>());
    });

    test('navigateToSignup changes state to LoginNavigateToSignupState', () {
      container.read(authProvider.notifier).navigateToSignup();
      expect(container.read(authProvider), isA<LoginNavigateToSignupState>());
    });

    test('navigateToLogin changes state to SignupNavigateToLoginState', () {
      container.read(authProvider.notifier).navigateToLogin();
      expect(container.read(authProvider), isA<SignupNavigateToLoginState>());
    });

    test('logIn sets state to LogInSuccessState on success', () async {
      await container.read(authProvider.notifier).logIn('username', 'password');
      await Future.delayed(Duration.zero); // Allow state change to propagate
      expect(container.read(authProvider), isA<LogInSuccessState>());
    });

    test('logIn sets state to LogInErrorState on failure', () async {
      await container
          .read(authProvider.notifier)
          .logIn('wrongusername', 'wrongpassword');
      await Future.delayed(Duration.zero); // Allow state change to propagate
      expect(container.read(authProvider), isA<LogInErrorState>());
    });

    test('signUp sets state to SignUpSuccessState on success', () async {
      await container
          .read(authProvider.notifier)
          .signUp('username', 'password', 'email', 'role');
      await Future.delayed(Duration.zero); // Allow state change to propagate
      expect(container.read(authProvider), isA<SignUpSuccessState>());
    });

    test('signUp sets state to SignupError on failure', () async {
      await container
          .read(authProvider.notifier)
          .signUp('wrongusername', 'wrongpassword', 'wrongemail', 'wrongrole');
      await Future.delayed(Duration.zero); // Allow state change to propagate
      expect(container.read(authProvider), isA<SignupError>());
    });

    test('signout sets state to SignoutState', () async {
      await container.read(authProvider.notifier).signout();
      await Future.delayed(Duration.zero); // Allow state change to propagate
      expect(container.read(authProvider), isA<SignoutState>());
    });
  });
}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier() : super();

  @override
  Future<void> logIn(String username, String password) async {
    if (username == 'username' && password == 'password') {
      state = LogInSuccessState();
    } else {
      state = LogInErrorState(error: 'error');
    }
  }

  @override
  Future<void> signUp(
      String username, String password, String email, String role) async {
    if (username == 'username' &&
        password == 'password' &&
        email == 'email' &&
        role == 'role') {
      state = SignUpSuccessState();
    } else {
      state = SignupError(error: 'error');
    }
  }

  @override
  Future<void> signout() async {
    state = SignoutState();
  }

  @override
  void navigateToSignup() {
    state = LoginNavigateToSignupState();
  }

  @override
  void navigateToLogin() {
    state = SignupNavigateToLoginState();
  }
}
