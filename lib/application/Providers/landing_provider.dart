import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
part '../../presentation/states/landing_state.dart';

class LandingNotifier extends StateNotifier<LandingState> {
  LandingNotifier() : super(LandingInitial());

  // Navigate to signup
  void navigateToSignup() {
    state = LandingNavigateToSignup();
  }

  // Navigate to login
  void navigateToLogin() {
    state = LandingNavigateToLogin();
  }
}

// Provider
final landingProvider =
    StateNotifierProvider<LandingNotifier, LandingState>((ref) {
  return LandingNotifier();
});
