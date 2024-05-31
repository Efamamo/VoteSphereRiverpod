import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/Providers/auth_provider.dart';
import '../../states/auth_state.dart';
import '../../Utils/extensions.dart';
import '../../widgets/forms.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  static final formkey = new GlobalKey<FormState>();

  int? index = 3;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authProvider.notifier);
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is SignupNavigateToLoginState) {
        context.push('/login');
      } else if (next is SignUpSuccessState) {
        print("signedUp");
        context.push('/home');
      } else if (next is SignupError) {

        final snackBar = SnackBar(
          content: Text(next.error),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create a new account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        )
                      ],
                    ),
                    Container(
                        child: Form(
                            key: formkey,
                            child: Column(children: <Widget>[
                              CustomForm(
                                controller: usernameController,
                                hintText: "Username",
                                validator: (val) {
                                  if (!val!.isValidUsername) {
                                    return "Please enter the valid username";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              CustomForm(
                                  controller: emailController,
                                  hintText: "Email",
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
                            ]))),
                    Column(
                      children: <Widget>[
                        const Text(
                          "Signup As",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: index,
                                    onChanged: (value) {
                                      setState(() {
                                        index = value;
                                      });
                                    }),
                                const Text("User")
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: index,
                                    onChanged: (value) {
                                      setState(() {
                                        index = value;
                                      });
                                    }),
                                const Text("Admin")
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 1, left: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: const Border(
                              bottom: BorderSide(color: Colors.amberAccent),
                              top: BorderSide(color: Colors.amberAccent),
                              right: BorderSide(color: Colors.amberAccent),
                              left: BorderSide(color: Colors.amberAccent))),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Colors.lightBlue,
                        onPressed: () {
                          String role = index == 1
                              ? 'User'
                              : index == 2
                                  ? "Admin"
                                  : "";
                          if (formkey.currentState!.validate()) {
                            authNotifier.signUp(
                                usernameController.text,
                                passwordController.text,
                                emailController.text,
                                role);
                          }
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account"),
                        GestureDetector(
                          onTap: () {
                            authNotifier.navigateToLogin();
                          },
                          child: const Text(
                            ' Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            )),
          ),
        );
      },
    );
  }
}
