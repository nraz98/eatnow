import 'package:EatNow/model/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Create use object based on firebase

  UserData _fromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid, email: user.email) : null;
  }

  Stream<UserData> get user {
    return _auth.authStateChanges().map((User user) => _fromFirebaseUser(user));
  }

  Future<String> getUserID() async {
    final User user = _auth.currentUser;
    String uid = user.uid;
    return uid;
  }

  //Sign with email
  Future signInWithEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result != null) {
        User user = result.user;
        return _fromFirebaseUser(user);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //register with email & passwor
  Future registerWithEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _fromFirebaseUser(user);
    } catch (e) {
      return false;
    }
  }

  //SignOut
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getCurrentUser() async {
    final User user = _auth.currentUser;
    return user;
  }
}
