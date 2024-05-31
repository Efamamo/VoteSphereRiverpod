import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/Providers/home_provider.dart';
import 'package:go_router/go_router.dart';

class MyAlertDialog extends ConsumerWidget {
  MyAlertDialog({super.key});
  final TextEditingController groupName = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.watch(homeProvider.notifier);
    return Builder(
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text(
            "Create Group",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: groupName,
            decoration: const InputDecoration(
                hintText: 'Enter Group Name',
                hintStyle: TextStyle(color: Colors.black)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (groupName.text != '') {
                  GoRouter.of(context).pop();
                  homeNotifier.createGroup(groupName.text);
                }
              },
              child: const Text(
                "Create Group",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }
}
