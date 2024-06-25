import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      appBar: AppBar(
        title: Text('My Vehicles'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle['name']),
                subtitle: Text(
                    'License: ${vehicle['license']} \nType: ${vehicle['type']}'),
              );
            },
          );
        },
      ),
    );
  }
}
