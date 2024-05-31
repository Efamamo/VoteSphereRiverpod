import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/landing_page.dart';
import 'presentation/screens/home/home.dart';
import 'presentation/screens/auth/login.dart';
import 'presentation/screens/settings.dart';
import 'presentation/screens/auth/signUp.dart';
import 'presentation/screens/member.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/new_polls.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: "/",
    name: 'landing',
    builder: (context, state) => LandingPage(),
  ),
  GoRoute(
    path: "/home",
    name: 'home',
    builder: (context, state) => const Home(),
  ),
  GoRoute(
    path: "/login",
    name: 'login',
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: "/signup",
    name: 'signup',
    builder: (context, state) => SignUpPage(),
  ),
  GoRoute(
    path: "/settings",
    name: 'settings',
    builder: (context, state) => const Settings(),
  ),
  GoRoute(
    path: "/members",
    name: 'members',
    builder: (context, state) => Members(),
  ),
  GoRoute(
    path: '/new_polls',
    builder: (context, state) {
      final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
      return NewPolls(
        question: params['question'],
        choice1: params['choice1'],
        choice2: params['choice2'],
        choice3: params['choice3'],
        choice4: params['choice4'],
        choice5: params['choice5'],
        questionError: params['questionError'],
      );
    },
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
