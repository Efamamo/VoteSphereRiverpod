import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/Providers/auth_provider.dart';
import '../../application/Providers/home_provider.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/states/home_state.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key, required this.group});
  final group;

  @override
  Widget build(BuildContext context, ref) {
    final homeNotifier = ref.watch(homeProvider.notifier);

    ref.listen<HomeState>(homeProvider, (previous, next) {
      if (next is NavigateToSettingState) {
        context.push('/settings');
      }

      if (next is NavigateToMembersState) {
        context.push('/members');
      }
    });
    return Builder(
      builder: (context) {
        return Drawer(
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    DrawerHeader(child: Image.asset('assets/vote.jpg')),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.home),
                          SizedBox(
                            width: 12,
                          ),
                          Text("HOME")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        homeNotifier.navigateToSettings();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 12,
                          ),
                          Text("SETTINGS")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    group != null
                        ? GestureDetector(
                            onTap: () {
                              homeNotifier.navigateToMembers();
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.people),
                                SizedBox(
                                  width: 12,
                                ),
                                Text("MEMBERS")
                              ],
                            ),
                          )
                        : const Text(''),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/');
                    ref.read(authProvider.notifier).signout();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 12,
                      ),
                      Text("LOGOUT")
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
