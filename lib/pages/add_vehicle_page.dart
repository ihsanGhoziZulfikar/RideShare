import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_share/components/my_textfield.dart';

class AddVehicleForm extends StatefulWidget {
  @override
  _AddVehicleFormState createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
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
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vehicle: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Makes the modal content wrap its content
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 10,
                ),
                child: Text(
                  'Add Vehicle',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15,
                ),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: Size(130, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
