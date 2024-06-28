import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/components/my_button.dart';
import 'package:ride_share/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // reset error messages
    setState(() {
      usernameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    // username empty
    if (usernameController.text.isEmpty) {
      // pop loading circle
      Navigator.pop(context);

      // set error message
      setState(() {
        usernameError = 'Username is required';
      });
      return;
    }

    // make sure password match
    if (passwordController.text != confirmController.text) {
      // pop loading circle
      Navigator.pop(context);

      setState(() {
        confirmPasswordError = 'Password dont match';
      });
      return;
    }

    // if no error, try creating the user
    try {
      // creating user
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // create a user document and add to firestore
      createUserDocument(userCredential);

      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);

      // display error
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            emailError = e.code;
            break;
          case 'invalid-email':
            emailError = e.code;
            break;
          default:
            confirmPasswordError = e.code;
        }
      });
    }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'username': usernameController.text,
        },
      );
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
                const Padding(
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
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Selamat datang di aplikasi ride share,\nbersama kita kurangi kemacetan dan\nmenjaga lingkungan!',
                            style: TextStyle(
                              fontSize: 16,
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
                  height: 380,
                  child: Stack(
                    children: [
                      Container(
                        height: 360,
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
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('Register',
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
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),

                            // username
                            MyTextField(
                              hintText: 'Username',
                              obscureText: false,
                              controller: usernameController,
                              prefixIcon: Icons.person,
                              errorText: usernameError, // Pass errorText
                            ),
                            const SizedBox(height: 10.0),

                            // email
                            MyTextField(
                              hintText: 'Email',
                              obscureText: false,
                              controller: emailController,
                              prefixIcon: Icons.email_outlined,
                              errorText: emailError, // Pass errorText
                            ),
                            const SizedBox(height: 10.0),

                            // password
                            MyTextField(
                              hintText: 'Password',
                              obscureText: true,
                              controller: passwordController,
                              prefixIcon: Icons.lock_outline,
                              errorText: passwordError, // Pass errorText
                            ),
                            const SizedBox(height: 10.0),

                            // confirm password
                            MyTextField(
                              hintText: 'Confirm Password',
                              obscureText: true,
                              controller: confirmController,
                              prefixIcon: Icons.lock_outline,
                              errorText: confirmPasswordError, // Pass errorText
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
                                  boxShadow: const [
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
                                  text: "Sign Up",
                                  onTap: registerUser,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // body:
      // Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(25.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         // logo
      //         Icon(
      //           Icons.person,
      //           size: 80,
      //           color: Theme.of(context).colorScheme.inversePrimary,
      //         ),

      //         const SizedBox(height: 25),

      //         // app name
      //         const Text(
      //           "a p p   n a m e",
      //           style: TextStyle(fontSize: 20),
      //         ),

      //         const SizedBox(height: 50),

      //         // username textfield
      //         MyTextField(
      //           hintText: "Username",
      //           obscureText: false,
      //           controller: usernameController,
      //           prefixIcon: Icon(Icons.email),
      //         ),

      //         const SizedBox(height: 10),

      //         // email textfield
      //         MyTextField(
      //           hintText: "Email",
      //           obscureText: false,
      //           controller: emailController,
      //           prefixIcon: Icon(Icons.email),
      //         ),

      //         const SizedBox(height: 10),

      //         // password
      //         MyTextField(
      //           hintText: "Password",
      //           obscureText: true,
      //           controller: passwordController,
      //           prefixIcon: Icon(Icons.password),
      //         ),

      //         const SizedBox(height: 10),

      //         // comfirm password
      //         MyTextField(
      //           hintText: "Confirm Password",
      //           obscureText: true,
      //           controller: confirmController,
      //           prefixIcon: Icon(Icons.password),
      //         ),

      //         const SizedBox(height: 10),

      //         // forgot
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: [
      //             Text(
      //               "Forgot Password",
      //               style: TextStyle(
      //                 color: Theme.of(context).colorScheme.inversePrimary,
      //               ),
      //             ),
      //           ],
      //         ),

      //         const SizedBox(height: 25),

      //         // sign in button
      //         MyButton(
      //           text: "Register",
      //           onTap: registerUser,
      //         ),

      //         const SizedBox(height: 25),

      //         // register here
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               "Already have an account?",
      //               style: TextStyle(
      //                 color: Theme.of(context).colorScheme.inversePrimary,
      //               ),
      //             ),
      //             GestureDetector(
      //               onTap: widget.onTap,
      //               child: const Text(
      //                 "Login Here",
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             )
      //           ],
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
