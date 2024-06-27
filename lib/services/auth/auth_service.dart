import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //nce for auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      print('before -----');
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('after -----');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
