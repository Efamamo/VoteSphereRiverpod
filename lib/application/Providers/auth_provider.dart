import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/states/auth_state.dart';
import '../../infrastructure/repositories/auth_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthInitial());

  void navigateToSignup() {
    state = LoginNavigateToSignupState();
  }

  void navigateToLogin() {
    state = SignupNavigateToLoginState();
  }

  Future<void> logIn(String username, String password) async {
    String res = await AuthRepository.login(username, password);
    if (res == "success") {
      state = LogInSuccessState();
    } else {
      state = LogInErrorState(error: res);
    }
  }

  Future<void> signUp(
      String username, String password, String email, String role) async {
    String res = await AuthRepository.signUp(username, password, email, role);
    if (res == "success") {
      state = SignUpSuccessState();
    } else {
      state = SignupError(error: res);
    }
  }

  Future<void> signout() async {
    await AuthRepository.signout();
    state = SignoutState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
