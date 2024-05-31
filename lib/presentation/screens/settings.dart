import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/Providers/home_provider.dart';
import '../../application/Providers/settings_provider.dart';
import 'package:go_router/go_router.dart';
import '../states/settings_state.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings();

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadSettings();
    });
    super.initState();
  }

  void updateUsername(context) {
    showDialog(
        context: context,
        builder: (context) {
          final settingNotifier = ref.watch(settingsProvider.notifier);

          TextEditingController newPassword = TextEditingController();

          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text(
              "Update Password",
              style: TextStyle(color: Colors.black),
            ),
            content: Container(
              height: 50,
              child: TextField(
                controller: newPassword,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter new Password',
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                  settingNotifier.changePassword(newPassword.text);
                },
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);
    final homeNotifier = ref.watch(homeProvider.notifier);

    ref.listen<SettingsState>(settingsProvider, (previous, next) {
      if (next is NavigateToUpdatePasswordState) {
        updateUsername(context);
      }

      if (next is ChangePasswordSuccessState) {
        const snackBar = SnackBar(
          content: Text("Password Updated Successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        settingsNotifier.loadSettings();
      }
      if (next is DeleteAccountState) {
        context.go('/');
      }

      if (next is ChangePasswordErrorState) {
        const snackBar = SnackBar(
          content: Text("New Password is not strong"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        settingsNotifier.loadSettings();
      }
    });
    return Builder(
      builder: (context) {
        if (settingsState is SettingsLoadingState) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (settingsState is SettingsLoadedState) {
          final settingState = settingsState as SettingsLoadedState;

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      GoRouter.of(context).pop();
                      homeNotifier.loadHome();
                    }),
                backgroundColor: const Color.fromARGB(255, 2, 34, 82),
                title: const Text(
                  "SETTINGS",
                  style: TextStyle(color: Colors.white, letterSpacing: 2.0),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                centerTitle: true,
              ),
              body: Container(
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 250, 250),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/vote.jpg',
                      width: 230,
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("username"),
                      subtitle: Text(settingState.username.toString()),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white),
                            onPressed: () {
                              settingsNotifier.navigateToChangePassword();
                            },
                            child: const Text("Update Password")),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white),
                            onPressed: () {
                              context.go('/');
                              settingsNotifier.deleteAccount();
                            },
                            child: Text("DeleteAccount")),
                      ],
                    )
                  ],
                ),
              ));
        }
        return Container();
      },
    );
  }
}
