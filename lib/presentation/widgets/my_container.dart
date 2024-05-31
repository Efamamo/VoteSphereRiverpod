import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/Providers/home_provider.dart';

// ignore: must_be_immutable
class MyContainer extends ConsumerWidget {
  MyContainer({required this.poll, required this.role});
  TextEditingController commentController = TextEditingController();
  var selected = '0';
  var poll;
  var role;
  void updateComment(context, data, poll, com, HomeNotifier homeNotifier) {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController comment = TextEditingController();
          comment.text = data;

          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text(
              "Update Comment",
              style: TextStyle(color: Colors.black),
            ),
            content: Container(
              height: 60,
              child: TextField(
                controller: comment,
                decoration: const InputDecoration(
                    hintText: 'Enter new Password',
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                  homeNotifier.updateComment(poll, com, comment.text);
                },
                child: const Text(
                  "Change Comment",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.watch(homeProvider.notifier);

    final pollId = poll["id"];

    List pollOptions = poll["options"];
    pollOptions.sort((a, b) => a["id"]!.compareTo(b["id"]!));

    num calculateTotal(List options) {
      num total = 0;
      for (var option in options) {
        total += option["numberOfVotes"];
      }
      return total;
    }

    final total =
        calculateTotal(pollOptions) != 0 ? calculateTotal(pollOptions) : 1;

    return Material(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(poll["question"],
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                role == "Admin"
                    ? IconButton(
                        onPressed: () {
                          homeNotifier.deletePoll(pollId);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ))
                    : const SizedBox()
              ],
            ),
          ),
          const Divider(
            height: 20,
          ),
          ...pollOptions
              .map((option) => RadioListTile(
                  fillColor: MaterialStateColor.resolveWith((states) {
                    return Colors.blue.shade700;
                  }),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(((option["numberOfVotes"] / total) * 100)
                              .toStringAsFixed(2) +
                          "%"),
                      LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.blue.shade700,
                          value: option["numberOfVotes"] / total),
                    ],
                  ),
                  title: Text(option["optionText"]),
                  value: option["id"],
                  groupValue: selected,
                  onChanged: (value) {
                    selected = value;
                    homeNotifier.vote(pollId, option['id']);
                  }))
              .toList(),
          const Divider(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Text("Comments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...poll["comments"].map((com) {
            final comId = com["id"];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(com["commentText"]),
                    ],
                  ),
                  PopupMenuButton(onSelected: (value) {
                    if (value == "update") {
                      updateComment(context, com["commentText"], pollId, comId,
                          homeNotifier);
                    } else if (value == "delete") {
                      homeNotifier.deleteComment(pollId, comId);
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                      const PopupMenuItem(
                        value: 'update',
                        child: Text("Update"),
                      ),
                    ];
                  })
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        homeNotifier.sendComment(
                            pollId, commentController.text);
                      }
                    },
                  ),
                  hintText: 'Write comment...'),
            ),
          )
        ]),
      ),
    );
  }
}
