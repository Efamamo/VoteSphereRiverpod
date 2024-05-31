import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/Providers/auth_provider.dart';
import '../../states/auth_state.dart';
import '../../Utils/extensions.dart';
import '../../widgets/forms.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static final formkey = new GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authProvider.notifier);
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is LogInErrorState) {
        const snackBar = SnackBar(
          content: Text("Cant login"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (next is LogInSuccessState) {
        context.push('/home');
      }
      if (next is LoginNavigateToSignupState) {
        context.push('/signup');
      }
    });
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          Column(
                            children: <Widget>[
                              const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Login to your account",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700]),
                              )
                            ],
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: <Widget>[
                                  Form(
                                      key: formkey,
                                      child: Column(children: <Widget>[
                                        CustomForm(
                                            controller: usernameController,
                                            hintText: "Username",
                                            validator: (val) {
                                              if (!val!.isValidEmail) {
                                                return "Please enter the valid email";
                                              } else {
                                                return null;
                                              }
                                            }),
                                        CustomForm(
                                            controller: passwordController,
                                            hintText: "Password",
                                            obsecuretext: true,
                                            validator: (val) {
                                              if (!val!.isValidPassword) {
                                                return "Please enter the valid password";
                                              } else {
                                                return null;
                                              }
                                            }),
                                      ])),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              padding: const EdgeInsets.only(top: 1, left: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: const Border(
                                      bottom:
                                          BorderSide(color: Colors.amberAccent),
                                      top:
                                          BorderSide(color: Colors.amberAccent),
                                      right:
                                          BorderSide(color: Colors.amberAccent),
                                      left: BorderSide(
                                          color: Colors.amberAccent))),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                color: Colors.lightBlue,
                                onPressed: () {
                                  authNotifier.logIn(usernameController.text,
                                      passwordController.text);
                                },
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Don't you have an account"),
                              GestureDetector(
                                onTap: () {
                                  authNotifier.navigateToSignup();
                                },
                                child: const Text(
                                  ' Sign up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 100),
                            height: 200,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/key.png"),
                                    fit: BoxFit.fitHeight)),
                          ),
                        ]))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
