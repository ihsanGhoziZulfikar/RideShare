import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/pages/users_list_page.dart';
import 'package:ride_share/services/auth/login_or_register.dart';
import 'package:ride_share/components/my_navigation_bar.dart';
import 'package:ride_share/pages/home_page.dart';
import 'package:ride_share/pages/profile_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              // return UsersListPage();
              return MyNavigationBar();
            }

            // user is not logged in
            else {
              return LoginOrRegister();
            }
          }),
    );
  }
}
