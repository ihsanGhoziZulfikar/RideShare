import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ride_share/pages/add_vehicle_page.dart';
import 'package:ride_share/pages/history_page.dart';
import 'package:ride_share/pages/profile_page.dart';
import 'package:ride_share/pages/splash_page.dart';
import 'package:ride_share/components/my_navigation_bar.dart';
import 'package:ride_share/pages/order_tracking_page.dart';
import 'package:ride_share/auth/auth.dart';
import 'package:ride_share/auth/login_or_register.dart';
import 'package:ride_share/firebase_options.dart';
import 'package:ride_share/pages/home_page.dart';
import 'package:ride_share/theme/light_mode.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      routes: {
        '/login_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => const HomePage(),
        // '/profile_page': (context) => ProfilePage(),
        // '/users_page': (context) => const UsersPage(),
      },
    );
  }
}
