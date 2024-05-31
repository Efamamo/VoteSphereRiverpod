import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/landingpage.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: 'landing',
      routes: {
        'landing': (context) => LandingPage(),
        // 'home': (context) => Home(),
        'signUp': (context) => SignUpPage(),
        'home': (context) => HomePage(
              role: "user",
            ),

        // 'login': (context) => LoginPage(),
        // 'feedBack': (context) => FeedBackForm(),
        // 'settings': (context) => Settings(),
        // 'members': (context) => Members(),
      },
    );
  }
}
