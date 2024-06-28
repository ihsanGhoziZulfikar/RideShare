import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:ride_share/pages/history_page.dart';
import 'package:ride_share/pages/user_vehicle_page.dart';
import 'package:ride_share/services/auth/auth.dart';
import 'package:ride_share/services/auth/auth_service.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 30,
              ),
              margin: EdgeInsets.only(bottom: 70),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: "Kantumruy",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      _authService.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                      );
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.red,
                      ),
                      height: 45,
                      child: Row(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Iconify(
                            '<svg xmlns="http://www.w3.org/2000/svg" width="1rem" height="1rem" viewBox="0 0 24 24"><path fill="#0077B6" d="M5 5h6c.55 0 1-.45 1-1s-.45-1-1-1H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h6c.55 0 1-.45 1-1s-.45-1-1-1H5z"/><path fill="#0077B6" d="m20.65 11.65l-2.79-2.79a.501.501 0 0 0-.86.35V11h-7c-.55 0-1 .45-1 1s.45 1 1 1h7v1.79c0 .45.54.67.85.35l2.79-2.79c.2-.19.2-.51.01-.7"/></svg>',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(
                'https://plus.unsplash.com/premium_photo-1708275670170-f92d0c82a1d3?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                scale: 1.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _authService.getCurrentUser()!.email ?? "no name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 75,
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Rating",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                                size: 25,
                              ),
                              Text(
                                "5.0",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 75,
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Jumlah",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "14",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(),
                        ),
                      );
                    }),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Color(0xff90E0EF),
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Icon(
                            Icons.location_history,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 15,
                          ),
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 56,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "History",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserVehiclesPage(),
                        ),
                      );
                    }),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Color(0xff00B4D8),
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: IconButton(
                            onPressed: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserVehiclesPage(),
                                ),
                              );
                            }),
                            icon: Iconify(
                              '<svg xmlns="http://www.w3.org/2000/svg" width="1rem" height="1rem" viewBox="0 0 48 48"><path fill="white" d="m9.198 16.5l-.433 1.767A4.25 4.25 0 0 0 6 22.25v17.5A3.25 3.25 0 0 0 9.25 43h3.5A3.25 3.25 0 0 0 16 39.75V36.5h16v3.25A3.25 3.25 0 0 0 35.25 43h3.5A3.25 3.25 0 0 0 42 39.75v-17.5c0-1.84-1.17-3.408-2.807-3.999l-.5-1.751h2.057a1.25 1.25 0 1 0 0-2.5h-2.771l-.991-3.467A6.25 6.25 0 0 0 30.978 6H16.674a6.25 6.25 0 0 0-6.07 4.763L9.81 14H7.25a1.25 1.25 0 1 0 0 2.5zm7.475-8H30.98a3.75 3.75 0 0 1 3.605 2.72L36.521 18H11.404l1.627-6.642A3.75 3.75 0 0 1 16.673 8.5m17.827 28h5v3.25a.75.75 0 0 1-.75.75h-3.5a.75.75 0 0 1-.75-.75zm-26 3.25V36.5h5v3.25a.75.75 0 0 1-.75.75h-3.5a.75.75 0 0 1-.75-.75M14 28a2 2 0 1 1 0-4a2 2 0 0 1 0 4m22-2a2 2 0 1 1-4 0a2 2 0 0 1 4 0m-15.75 2h7.5a1.25 1.25 0 1 1 0 2.5h-7.5a1.25 1.25 0 1 1 0-2.5"/></svg>',
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 15,
                          ),
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 56,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "My Vehicle",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
