// settings_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/states/settings_state.dart';
import '../../infrastructure/repositories/settings_repository.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsInitial());

  Future<void> loadSettings() async {
    state = SettingsLoadingState();
    final res = await SettingsRepository.loadSetting();
    state = SettingsLoadedState(username: res["username"], email: res["email"]);
  }

  void navigateToChangePassword() {
    state = NavigateToUpdatePasswordState();
  }

  Future<void> changePassword(String newPassword) async {
    state = SettingsLoadingState();
    final res = await SettingsRepository.changePassword(newPassword);
    if (res == "success") {
      state = ChangePasswordSuccessState();
    } else {
      state = ChangePasswordErrorState(error: res);
    }
  }

  Future<void> deleteAccount() async {
    state = SettingsLoadingState();
    final res = await SettingsRepository.deleteAccount();
    if (res) {
      state = DeleteAccountState();
    } else {
      state = ChangePasswordErrorState(error: "Cannot delete the account now");
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
