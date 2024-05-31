import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/local_storage/secure_storage.dart';
import '../../../application/Providers/home_provider.dart';
import '../../states/home_state.dart';
import '../../widgets/alertdialog.dart';

class NoGroup extends ConsumerWidget {
  NoGroup({super.key, required this.role});

  final secureStorage = SecureStorage().secureStorage;
  final role;

  void createGroup(context) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog();
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    ref.listen<HomeState>(homeProvider, (previous, next) {
      if (next is NavigateToCreateGroupState) {
        createGroup(context);
      }
    });
    return Builder(
        builder: (context) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/vote.jpg',
                    width: 230,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  const Padding(
                      padding: EdgeInsets.only(left: 25, right: 80),
                      child: Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: 'Votesphere',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 2, 34, 82),
                            ),
                          ),
                          TextSpan(
                            text:
                                " is a dynamic voting platform that makes group decision-making a breeze. Whether you're planning a trip with friends, organizing an event, or seeking opinions on important topics, Votesphere has you covered. ",
                          ),
                        ],
                        style: TextStyle(fontSize: 16),
                      ))),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    role == "Admin"
                        ? "Create A Group to get Started"
                        : 'You Are Not Assigned To Any Group Yet',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 2, 34, 82),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 140.0),
                    child: role != "User"
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Create group'),
                            onPressed: () {
                              homeNotifier.openDialogToCreateGroup();
                            },
                          )
                        : const SizedBox(
                            height: 10,
                          ),
                  )
                ],
              ),
            ));
  }
}
