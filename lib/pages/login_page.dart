import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/components/my_button.dart';
import 'package:ride_share/components/my_textfield.dart';
import 'package:ride_share/services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final AuthService _authService = AuthService();
  // text editing controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  // Load remember me info
  void _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('remember_me') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  // Save remember me info
  void _saveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', rememberMe);
    if (rememberMe) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    } else {
      prefs.remove('email');
      prefs.remove('password');
    }
  }

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
      UserCredential userCredential =
          await _authService.signInWithEmailPassword(
              emailController.text, passwordController.text);
      // pop loading
      if (context.mounted) Navigator.pop(context);

      // Save remember me info
      _saveRememberMe();
    } catch (e) {
      // pop loading
      if (context.mounted) Navigator.pop(context);

      // Handle errors from signInWithEmailPassword function
      setState(() {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-email':
              emailError = 'Invalid email address';
              passwordError = null;
              break;
            case 'user-not-found':
              emailError = 'No user found for that email';
              passwordError = null;
              break;
            case 'wrong-password':
              emailError = null;
              passwordError = 'Wrong password provided';
              break;
            default:
              emailError = null;
              passwordError = e.message;
          }
        } else {
          // Handle other exceptions if needed
          emailError = null;
          passwordError = e.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
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
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - bottomInset,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Ride Share
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // login/register
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Login',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
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
                                          prefixIcon: Icons.email_outlined,
                                          errorText:
                                              emailError, // Pass errorText
                                        ),
                                        const SizedBox(height: 10.0),

                                        // password
                                        MyTextField(
                                          hintText: 'Password',
                                          obscureText: true,
                                          controller: passwordController,
                                          prefixIcon: Icons.lock_outline,
                                          errorText:
                                              passwordError, // Pass errorText
                                        ),

                                        // remember me
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 30,
                                                          maxWidth: 30),
                                                  color: Colors.black,
                                                  icon: Icon(
                                                    rememberMe
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
