// home_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/repositories/home_repository.dart';
import '../../presentation/states/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeInitial());

  Future<void> loadHome() async {
    state = LoadingState();
    final res = await HomeRespository.loadHome();
    if (res['token'] == null) {
      state = UnloggedState();
    } else if (res["group"] == null) {
      state = NoGroupState(
        group: res["group"],
        role: res["role"],
        token: res["token"],
        username: res["username"],
        email: res["email"],
      );
    } else if (res.containsKey("polls")) {
      state = HomeWithPollState(
        group: res["group"],
        username: res["username"],
        polls: res["polls"],
        role: res["role"],
        email: res["email"],
        token: res["token"],
      );
    }
  }

  Future<void> createGroup(String groupName) async {
    final res = await HomeRespository.createGroup(groupName);
    if (res) {
      print("created");
      loadHome();
    }
  }

  Future<void> addPoll(String question, List<String> options) async {
    final res = await HomeRespository.addPole(question, options);
    if (res) {
      loadHome();
    }
  }

  Future<void> deletePoll(String pollId) async {
    final res = await HomeRespository.deletePoll(pollId);
    if (res) {
      loadHome();
    } else {
      state = DeletePollErrorState(
          error: "Admin can't delete the poll that is already voted on");
    }
  }

  Future<void> vote(String pollId, String optionId) async {
    final res = await HomeRespository.vote(pollId, optionId);
    if (res) {
      loadHome();
    } else {
      state = VoteError(error: "You already voted on the poll");
    }
  }

  Future<void> sendComment(String pollId, String comment) async {
    final res = await HomeRespository.addComment(pollId, comment);
    if (res) {
      loadHome();
    }
  }

  Future<void> updateComment(
      String pollId, String commentId, String comment) async {
    final res = await HomeRespository.updateComment(comment, commentId);
    if (res) {
      loadHome();
    } else {
      state = DeletePollErrorState(error: "The comment doesn't belong to you");
    }
  }

  Future<void> deleteComment(String pollId, String commentId) async {
    final res = await HomeRespository.deleteComment(commentId);
    if (res) {
      loadHome();
    } else {
      state =
          DeletePollErrorState(error: "Can't delete other people's comment");
    }
  }

  Future<void> addMember(String username) async {
    final res = await HomeRespository.addMember(username);

    if (res) {
      loadMembers();
    } else {
      state = AddMemberErrorState(error: "You can't add $username");
    }
  }

  Future<void> deleteMember(String username) async {
    final res = await HomeRespository.deleteMember(username);

    if (res) {
      loadMembers();
    } else {
      state = DeleteMemberErrorState(error: "You can't add $username");
    }
  }

  Future<void> loadMembers() async {
    final res = await HomeRespository.getMembers();
    if (res.containsKey("error")) {
      loadHome();
    } else {
      state = MembersLoadedState(
        members: res["members"],
        role: res["role"],
      );
    }
  }

  void openDialogToCreateGroup() {
    state = NavigateToCreateGroupState();
  }

  void navigateToSettings() {
    state = NavigateToSettingState();
  }

  void navigateToAddPoll() {
    state = NavigateToAddPoles();
  }

  void navigateToMembers() {
    state = NavigateToMembersState();
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
