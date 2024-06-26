import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:ride_share/components/my_clipper_edge.dart';
import 'package:ride_share/components/my_destination_card.dart';
import 'package:ride_share/components/my_main_feature_option.dart';
import 'package:ride_share/pages/guest_page.dart';
import 'package:ride_share/pages/driver_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // current user
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await _firestore.collection("Users").doc(currentUser!.uid).get();
  }

  // future to fetch user vehicle
  // Fetch one random user vehicle
  // Fetch one random user vehicle
  Future<Map<String, dynamic>?> getRandomUserVehicle() async {
    try {
      QuerySnapshot<Map<String, dynamic>> vehicleSnapshot = await _firestore
          .collection("Users")
          .doc(currentUser!.uid)
          .collection("vehicles")
          .limit(1)
          .get();

      if (vehicleSnapshot.docs.isNotEmpty) {
        return vehicleSnapshot.docs.first.data();
      } else {
        return {
          "licence": "no licence",
          "name": "no vehicle",
          "type": "no type"
        };
      }
    } catch (e) {
      print("Error fetching random user vehicle: $e");
      return {"licence": "no licence", "name": "no vehicle", "type": "no type"};
    }
  }

  // update user status
  Future<void> updateUserStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.uid)
        .update({
      'status': status,
    });
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).colorScheme.background,
  //     body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //       future: getUserDetails(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }

  //         // error
  //         else if (snapshot.hasError) {
  //           return Text("Error: ${snapshot.error}");
  //         }

  //         // data
  //         else if (snapshot.hasData) {
  //           Map<String, dynamic>? user = snapshot.data!.data();

  //           return Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   user!['username'] ?? 'Username not available',
  //                 ),
  //                 Text(
  //                   user['email'] ?? 'email not available',
  //                 ),
  //                 Text(
  //                   user['password'] ?? 'password not available',
  //                 ),
  //                 IconButton(
  //                   onPressed:
  //                       signOut, // Pass the function reference instead of calling it
  //                   icon: const Icon(Icons.logout),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //         // if nothing
  //         else {
  //           return const Text("No data");
  //         }
  //       },
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height - 25,
          child: Stack(
            children: [
              Positioned(
                child: ClipPath(
                  clipper: MyClipperEdge(),
                  child: Container(
                    height: 440,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 130,
                          left: 270,
                          child: Container(
                            height: 220,
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(400),
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 195,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(400),
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 45),
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                              future: getUserDetails(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  Map<String, dynamic>? user =
                                                      snapshot.data!.data();
                                                  return Text(
                                                    "Hi, " +
                                                            user!['username'] ??
                                                        'Username not available',
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontFamily: 'Kanit',
                                                    ),
                                                  );
                                                } else {
                                                  return const Text("No data");
                                                }
                                              }),
                                          Text(
                                            'Kamu ingin pergi ke mana?',
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontFamily: 'Kantumruy',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundImage: NetworkImage(
                                        'https://plus.unsplash.com/premium_photo-1708275670170-f92d0c82a1d3?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                        scale: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Temukan destinasimu di sini',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12.0,
                                    ),
                                    child: Iconify(
                                      '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 25 25"><g fill="none" fill-rule="evenodd"><path d="M24 0v24H0V0zM12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.019-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="#CCCC" d="M10.5 4a6.5 6.5 0 1 0 0 13a6.5 6.5 0 0 0 0-13M2 10.5a8.5 8.5 0 1 1 15.176 5.262l3.652 3.652a1 1 0 0 1-1.414 1.414l-3.652-3.652A8.5 8.5 0 0 1 2 10.5M9.5 7a1 1 0 0 1 1-1a4.5 4.5 0 0 1 4.5 4.5a1 1 0 1 1-2 0A2.5 2.5 0 0 0 10.5 8a1 1 0 0 1-1-1"/></g></svg>',
                                      color: Color(0xffCCCCCC),
                                      size: 10,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FutureBuilder<Map<String, dynamic>?>(
                                        future: getRandomUserVehicle(),
                                        builder: (context, vehicleSnapshot) {
                                          if (vehicleSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          if (vehicleSnapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    "Error fetching vehicle"));
                                          }

                                          if (!vehicleSnapshot.hasData ||
                                              vehicleSnapshot.data == null) {
                                            return Center(
                                                child:
                                                    Text("No vehicle found"));
                                          }
                                          Map<String, dynamic> vehicle =
                                              vehicleSnapshot.data!;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Kendaraanmu',
                                                style: TextStyle(
                                                  fontFamily: 'Kantumruy',
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                vehicle['name'] ?? "no vehicle",
                                                style: TextStyle(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                              Text(
                                                vehicle['license'] ??
                                                    "no license",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily:
                                                        "KaiseiTokumin"),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 90,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    print('you hit the button');
                                                  },
                                                  child: Text(
                                                    'Ubah',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }),
                                    Container(
                                      width: 164,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/toyota.webp',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 420,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.49,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mau Jadi Apa',
                        style: TextStyle(
                          fontFamily: 'Kantumruy',
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MyMainFeatureOption(
                            svgIcon:
                                '<svg xmlns="http://www.w3.org/2000/svg" width="1rem" height="1rem" viewBox="0 0 24 24"><g fill="none" fill-rule="evenodd"><path d="M24 0v24H0V0zM12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.019-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="white" d="M12 2c5.523 0 10 4.477 10 10s-4.477 10-10 10S2 17.523 2 12S6.477 2 12 2M4.205 13.81a8.01 8.01 0 0 0 6.254 6.042c-.193-2.625-1.056-4.2-2.146-5.071c-1.044-.835-2.46-1.158-4.108-.972Zm11.482.97c-1.09.873-1.953 2.447-2.146 5.072a8.01 8.01 0 0 0 6.254-6.043c-1.648-.186-3.064.137-4.108.972ZM12 4a8 8 0 0 0-7.862 6.513l-.043.248l2.21-.442c.582-.116 1.135-.423 1.753-.84l.477-.332C9.332 8.581 10.513 8 12 8c1.388 0 2.509.506 3.3 1.034l.642.445c.54.365 1.032.645 1.536.788l.217.052l2.21.442A8 8 0 0 0 12 4"/></g></svg>',
                            iconSize: 70,
                            label: "Driver",
                            color: Color(0xFF90E0EF),
                            onTap: () async {
                              await updateUserStatus("driver");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DriverPage()),
                              );
                            },
                          ),
                          MyMainFeatureOption(
                            svgIcon:
                                '<svg xmlns="http://www.w3.org/2000/svg" width="1rem" height="1rem" viewBox="0 0 512 512"><path fill="none" stroke="white" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32" d="M208 208v264a23.73 23.73 0 0 0 24 24h0a23.73 23.73 0 0 0 24-24"/><path fill="none" stroke="white" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32" d="M256 336v136a23.73 23.73 0 0 0 24 24h0a23.73 23.73 0 0 0 24-24V208"/><path fill="none" stroke="white" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32" d="M208 192v88a23.72 23.72 0 0 1-24 24h0a23.72 23.72 0 0 1-24-24v-88a48 48 0 0 1 48-48h96a48 48 0 0 1 48 48v88a23.72 23.72 0 0 1-24 24h0a23.72 23.72 0 0 1-24-24v-88"/><circle cx="256" cy="56" r="40" fill="none" stroke="white" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32"/></svg>',
                            iconSize: 65,
                            label: 'Guest',
                            color: Color(0xFF00B4D8),
                            onTap: () async {
                              await updateUserStatus("guest");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GuestPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Destinasi Sebelumnya',
                        style: TextStyle(
                          fontFamily: 'Kantumruy',
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MyDestinationCard(
                              imageUrl:
                                  'https://media.istockphoto.com/id/1270561593/id/vektor/gedung-sate-terkenal-membangun-landmark-dari-bandung-jawa-barat-indonesia-konsep-dalam.jpg?s=2048x2048&w=is&k=20&c=wAFmyhfRa-cpK0trkWAp-ZHog39vk1AZvwLS0j77XjU=',
                              title: 'Gedung Sate',
                              time: '01:30 WIB',
                            ),
                            SizedBox(width: 10),
                            MyDestinationCard(
                              imageUrl:
                                  'https://www.shutterstock.com/shutterstock/photos/2460015087/display_1500/stock-photo-bandung-indonesia-april-villa-isola-is-an-art-deco-building-located-on-the-campus-of-2460015087.jpg',
                              title: 'Universitas Pendidikan Indonesia',
                              time: '10:30 WIB',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
