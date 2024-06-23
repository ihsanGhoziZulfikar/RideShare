import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ride_share/components/my_button.dart';
import 'package:ride_share/components/my_textfield.dart';
import 'package:ride_share/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool rememberMe = false;

  void login() async {
    // show loading
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // pop loading
      if (context.mounted) Navigator.pop(context);
    }
    //on error
    on FirebaseAuthException catch (e) {
      // pop loading
      Navigator.pop(context);

      setState(() {
        switch (e.code) {
          case 'invalid-email':
            emailError = e.code;
            passwordError = null;
            break;
          case 'missing-password':
            emailError = null;
            passwordError = e.code;
            break;
          default:
            emailError = null;
            passwordError = e.code;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            widthFactor: 1,
            heightFactor: 0.45,
            child: Container(
              height: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ride Share
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ride Share',
                            style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60.0),

                // white rounded box
                Container(
                  height: 350,
                  child: Stack(
                    children: [
                      Container(
                        height: 330,
                        padding: const EdgeInsets.all(15.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // login/register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text('Login',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      height: 3.0,
                                      width: 100.0,
                                      // color: Theme.of(context).colorScheme.background,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),

                            // email
                            MyTextField(
                              hintText: 'Email',
                              obscureText: false,
                              controller: emailController,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.7),
                              ),
                              errorText: emailError, // Pass errorText
                            ),
                            const SizedBox(height: 10.0),

                            // password
                            MyTextField(
                              hintText: 'Password',
                              obscureText: true,
                              controller: passwordController,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.7),
                              ),
                              errorText: passwordError, // Pass errorText
                            ),

                            // remember me
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      constraints: const BoxConstraints(
                                          minWidth: 30, maxWidth: 30),
                                      color: Colors.black,
                                      icon: Icon(
                                        rememberMe
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 18.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          rememberMe = !rememberMe;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Remember me',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: MyButton(
                                  text: "Sign In",
                                  onTap: login,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // Icon(
                //   Icons.person,
                //   size: 80,
                //   color: Theme.of(context).colorScheme.inversePrimary,
                // ),

                // const SizedBox(height: 25),

                // // app name
                // const Text(
                //   "a p p   n a m e",
                //   style: TextStyle(fontSize: 20),
                // ),

                // const SizedBox(height: 50),

                // // email textfield
                // MyTextField(
                //   hintText: "Email",
                //   obscureText: false,
                //   controller: emailController,
                // ),

                // const SizedBox(height: 10),

                // // password
                // MyTextField(
                //   hintText: "Password",
                //   obscureText: true,
                //   controller: passwordController,
                // ),

                // const SizedBox(height: 10),

                // // forgot
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       "Forgot Password",
                //       style: TextStyle(
                //         color: Theme.of(context).colorScheme.inversePrimary,
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 25),

                // // sign in button
                // MyButton(
                //   text: "Login",
                //   onTap: login,
                // ),

                // const SizedBox(height: 25),

                // // register here
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Don't have an account?",
                //       style: TextStyle(
                //         color: Theme.of(context).colorScheme.inversePrimary,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: widget.onTap,
                //       child: const Text(
                //         "Register Here",
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
