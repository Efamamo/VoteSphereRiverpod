import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
part '../../presentation/states/landing_state.dart';

class LandingNotifier extends StateNotifier<LandingState> {
  LandingNotifier() : super(LandingInitial());

  void navigateToSignup() {
    state = LandingNavigateToSignup();
  }

  void navigateToLogin() {
    state = LandingNavigateToLogin();
  }
}

final landingProvider =
    StateNotifierProvider<LandingNotifier, LandingState>((ref) {
  return LandingNotifier();
});
