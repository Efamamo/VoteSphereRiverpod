import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/Providers/home_provider.dart';
import '../../states/home_state.dart';
import 'package:go_router/go_router.dart';
import './no_group.dart';
import './my_polls.dart';
import './no_polls.dart';
import '../../widgets/my_drawer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  TextEditingController groupName = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).loadHome();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.watch(homeProvider.notifier);

    ref.listen<HomeState>(homeProvider, (previous, next) {
      if (next is UnloggedState) {
        context.go('/');
      }
      if (next is DeletePollErrorState) {
        final snackBar = SnackBar(
          content: Text(next.error),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        homeNotifier.loadHome();
      }
      if (next is VoteError) {
        final snackBar = SnackBar(
          content: Text(next.error),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        homeNotifier.loadHome();
      }
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 34, 82),
          title: const Text(
            "VOTESPHERE",
            style: TextStyle(color: Colors.white, letterSpacing: 2.0),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(
            group: homeState is HomeWithPollState ? homeState.group : null),
        body: MyBody());
  }
}

class MyBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Builder(
      builder: (context) {
        if (homeState is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (homeState is NoGroupState) {
          return NoGroup(
            role: homeState.role,
          );
        } else if (homeState is HomeWithPollState) {
          if (homeState.polls.isEmpty) {
            return Center(
              child: NoPoll(
                role: homeState.role,
              ),
            );
          } else {
            return Center(
              child: MyPolls(
                polls: homeState.polls,
                role: homeState.role,
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
