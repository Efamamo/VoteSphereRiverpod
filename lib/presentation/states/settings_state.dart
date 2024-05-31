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
