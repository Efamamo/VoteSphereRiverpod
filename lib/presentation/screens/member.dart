import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/Providers/home_provider.dart';
import '../states/home_state.dart';

void main() {
  runApp(ProviderScope(child: Members()));
}

class Members extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.watch(homeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 34, 82),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).pop();
              homeNotifier.loadHome();
            }),
        title: const Text(
          'Members',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: MemberPage(),
    );
  }
}

class MemberPage extends ConsumerStatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends ConsumerState<MemberPage> {
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).loadMembers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.watch(homeProvider.notifier);

    ref.listen<HomeState>(homeProvider, (previous, next) {
      if (next is AddMemberErrorState) {
        final snackBar = SnackBar(
          content: Text(next.error),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        homeNotifier.loadMembers();
      }
      if (next is DeleteMemberErrorState) {
        final snackBar = SnackBar(
          content: Text(next.error),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        homeNotifier.loadMembers();
      }
    });

    return Builder(builder: (context) {
      if (homeState is MembersLoadingState) {
        _usernameController.clear();
        return const Center(child: CircularProgressIndicator());
      }
      if (homeState is MembersLoadedState) {
        final memberstate = homeState as MembersLoadedState;

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10.0), // Added x-direction padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              memberstate.role == "Admin"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width:
                                7), // Added padding to the left of the circular avatar
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color.fromARGB(255, 2, 34, 82),
                          child: Icon(Icons.people,
                              size: 25,
                              color:
                                  Colors.white), // Changed the icon to 'people'
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _usernameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Username',
                                        labelStyle: TextStyle(
                                            color: Colors.black), // Text color
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.blue), // Border color
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors
                                                  .blue), // Focused border color
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a username';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        homeNotifier.addMember(
                                            _usernameController.text);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[500],
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Increased the border radius
                                        ),
                                      ),
                                      child: const Text('Add Member',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              memberstate.members.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No Member Added Yet',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: memberstate.members.length,
                  itemBuilder: (context, index) {
                    return MemberListItem(
                        member: memberstate.members[index],
                        role: memberstate.role);
                  },
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}

class MemberListItem extends ConsumerWidget {
  final Map<String, dynamic> member;
  final String role;

  const MemberListItem({Key? key, required this.member, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Color.fromARGB(255, 2, 34, 82)),
                  SizedBox(width: 10),
                  Text(member["username"],
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
              role == "Admin"
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        homeNotifier.deleteMember(member["username"]);
                      },
                      color: Colors.red,
                    )
                  : const SizedBox(
                      width: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
