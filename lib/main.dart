import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ride_share/pages/splash_page.dart';
import 'package:ride_share/firebase_options.dart';
import 'package:ride_share/theme/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      theme: lightMode,
    );
  }
}
