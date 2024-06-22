import 'package:flutter/material.dart';
import 'package:ride_share/pages/order_tracking_page.dart';
import 'package:ride_share/theme/dark_mode.dart';
import 'package:ride_share/theme/light_mode.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderTrackingPage(),
      // routes: {
      //   '/login_register_page': (context) => const LoginOrRegister(),
      //   '/home_page': (context) => HomePage(),
      //   '/profile_page': (context) => ProfilePage(),
      //   '/users_page': (context) => const UsersPage(),
      // },
    );
  }
}
