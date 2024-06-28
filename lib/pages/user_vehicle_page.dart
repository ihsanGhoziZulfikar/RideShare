import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/pages/add_vehicle_page.dart';

class UserVehiclesPage extends StatefulWidget {
  const UserVehiclesPage({super.key});

  @override
  State<UserVehiclesPage> createState() => _UserVehiclesPageState();
}

class _UserVehiclesPageState extends State<UserVehiclesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  Future<List<Map<String, dynamic>>> _fetchUserVehicles() async {
    if (_currentUser == null) {
      return [];
    }

    CollectionReference vehiclesCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUser!.uid)
        .collection('vehicles');

    QuerySnapshot querySnapshot = await vehiclesCollection.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    return docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10,
              bottom: 15,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "My Vehicles",
                  style: TextStyle(
                    fontFamily: 'Kantumruy',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchUserVehicles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No vehicles found.'));
                }

                List<Map<String, dynamic>> vehicles = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 10),
                  child: ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> vehicle = vehicles[index];
                      return Card(
                        surfaceTintColor: Color(0xFF00B4D8),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                vehicle['type'].contains('car')
                                    ? 'assets/images/mobil.jpg'
                                    : 'assets/images/motor.jpg',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5),
                                    Text(
                                      vehicle['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'License: ${vehicle['license']} \nType: ${vehicle['type']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (value == 'Ubah') {
                                      SnackBar(
                                        content: Text("mengubah vehicle"),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {'Ubah'}.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehiclePage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
      ),
    );
  }
}
