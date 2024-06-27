import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/pages/user_vehicle_page.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_nameController.text.isEmpty ||
          _licenseController.text.isEmpty ||
          _typeController.text.isEmpty) {
        // set error message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please fill in all form')));
        return;
      }

      User? user = _auth.currentUser;
      if (user != null) {
        await _addVehicleToFirestore(
          _nameController.text,
          _licenseController.text,
          _typeController.text,
          user.uid,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User not logged in')));
      }
    }
  }

  Future<void> _addVehicleToFirestore(
      String name, String license, String type, String userId) async {
    try {
      CollectionReference userVehicles = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('vehicles');

      await userVehicles.add({
        'name': name,
        'license': license,
        'type': type,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vehicle Added')));
      _nameController.clear();
      _licenseController.clear();
      _typeController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vehicle: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (() {
              Navigator.pop(context);
            })),
        title: Text('Add Vehicle'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add Vehicle', style: TextStyle(fontSize: 24.0)),

              // name
              MyTextField(
                hintText: "Vehicle Name",
                obscureText: false,
                controller: _nameController,
                prefixIcon: Icons.car_repair_rounded,
              ),
              SizedBox(height: 10.0),

              // licence
              MyTextField(
                hintText: "Licence Number",
                obscureText: false,
                controller: _licenseController,
                prefixIcon: Icons.featured_play_list_outlined,
              ),
              SizedBox(height: 10.0),

              // type
              MyTextField(
                hintText: "Type",
                obscureText: false,
                controller: _typeController,
                prefixIcon: Icons.pedal_bike_outlined,
              ),
              SizedBox(height: 10.0),

              ElevatedButton(
                onPressed: () {
                  print('Add button pressed');
                  _submitForm();
                },
                child: Text('Add'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserVehiclesPage()),
                      );
                    },
                    child: Text('vehicle list'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
