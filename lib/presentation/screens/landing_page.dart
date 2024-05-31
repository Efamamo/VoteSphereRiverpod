import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/Providers/landing_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends ConsumerWidget {
  LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landingNotifier = ref.watch(landingProvider.notifier);
    ref.listen<LandingState>(landingProvider, (previous, next) {
      if (next is LandingNavigateToLogin) {
        context.push('/login');
      } else if (next is LandingNavigateToSignup) {
        context.push('/signup');
      }
    });
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(children: <Widget>[
                      const Text("Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 200,
                          child: TextLiquidFill(
                            text: 'Votosphere',
                            waveColor: Colors.blueAccent,
                            boxBackgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            boxHeight: 80,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                              "The most competitive vote app. Vote anything that you want!",
                              textStyle: const TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                        isRepeatingAnimation: true,
                      )
                    ]),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images.png"))),
                    ),
                    Column(
                      children: <Widget>[
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            landingNotifier.navigateToLogin();
                          },
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            landingNotifier.navigateToSignup();
                          },
                          color: const Color(0xff0095FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
