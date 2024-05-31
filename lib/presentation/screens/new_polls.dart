import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/Providers/home_provider.dart';
import '../widgets/textfield.dart';

// ignore: must_be_immutable
class NewPolls extends ConsumerWidget {
  NewPolls({
    required this.question,
    required this.choice1,
    required this.choice2,
    required this.choice3,
    required this.choice4,
    required this.choice5,
    required this.questionError,
  });

  TextEditingController question;
  TextEditingController choice1;
  TextEditingController choice2;
  TextEditingController choice3;
  TextEditingController choice4;
  TextEditingController choice5;

  String questionError = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> answers() {
      List<String> answer = [];

      if (choice1.text != '') {
        answer.add(choice1.text);
      }
      if (choice2.text != '') {
        answer.add(choice2.text);
      }
      if (choice3.text != '') {
        answer.add(choice3.text);
      }
      if (choice4.text != '') {
        answer.add(choice4.text);
      }
      if (choice5.text != '') {
        answer.add(choice5.text);
      }

      choice1.clear();
      choice2.clear();
      choice3.clear();
      choice4.clear();
      choice5.clear();
      question.clear();
      return answer;
    }

    final homeNotifier = ref.read(homeProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 34, 82),
          title: const Text(
            "POLLS",
            style: TextStyle(color: Colors.white, letterSpacing: 2.0),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Please enter the poll information. Make sure to include a question for the poll, as well as three answer choices. All fields are required, so ensure you provide a question and three choices to complete the poll entry.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Enter Poll Information",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 2, 34, 82),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: "Question",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: ' *', style: TextStyle(color: Colors.red))
                          ]),
                        ),
                        MyTextField(
                            hintText: 'Enter the question......',
                            controller: question,
                            lines: 3),
                        Text(
                          questionError,
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "Choice 1",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red))
                            ]),
                          ),
                          MyTextField(
                              hintText: 'Enter the choice1......',
                              controller: choice1,
                              lines: 1),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "Choice 2",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red))
                            ]),
                          ),
                          MyTextField(
                              hintText: 'Enter the choice2......',
                              controller: choice2,
                              lines: 1),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "Choice 3",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red))
                            ]),
                          ),
                          MyTextField(
                              hintText: 'Enter the choice3......',
                              controller: choice3,
                              lines: 1),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Choice 4",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              MyTextField(
                                  hintText: 'Enter the choice4......',
                                  controller: choice4,
                                  lines: 1),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Choice 5",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              MyTextField(
                                  hintText: 'Enter the choice5......',
                                  controller: choice5,
                                  lines: 1),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.go('/home');
                              homeNotifier.addPoll(question.text, answers());
                            },
                            child: const Text('Add Pole'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ]),
                  ]),
            ),
          ),
        ));
  }
}
