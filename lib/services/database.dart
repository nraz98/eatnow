import 'package:EatNow/model/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //collection reference
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get
  Stream<List<Preferences>> getPreferences() {
    final User user = _auth.currentUser;
    String uid = user.uid;

    return _db
        .collection('UserData')
        .doc(uid)
        .collection('preferences')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Preferences.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Default>> getDefault() {
    final User user = _auth.currentUser;
    String uid = user.uid;

    return _db
        .collection('UserData')
        .doc(uid)
        .collection('default')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Default.fromJson(doc.data())).toList());
  }

  //Add and Update
  Future<void> setPreferences(Preferences preferences) {
    final User user = _auth.currentUser;
    String uid = user.uid;
    var options = SetOptions(merge: true);
    return _db
        .collection('UserData')
        .doc(uid)
        .collection('preferences')
        .doc(preferences.preferId)
        .set(preferences.toMap(), options);
  }

  //update
  Future<void> setDefault(Default preferences) {
    final User user = _auth.currentUser;
    String uid = user.uid;
    var options = SetOptions(merge: true);
    return _db
        .collection('UserData')
        .doc(uid)
        .collection('default')
        .doc('myDefaultValue')
        .set(preferences.toMap(), options);
  }

  //delete
  Future<void> removePreferences(String preferId) {
    final User user = _auth.currentUser;
    String uid = user.uid;
    return _db
        .collection('UserData')
        .doc(uid)
        .collection('preferences')
        .doc(preferId)
        .delete();
  }

  Future<void> removeDefault() {
    final User user = _auth.currentUser;
    String uid = user.uid;
    return _db
        .collection('UserData')
        .doc(uid)
        .collection('default')
        .doc('myDefaultValue')
        .delete();
  }

  Future<String> getDefaultValue() async {
    String defaultName;
    final User user = _auth.currentUser;
    String uid = user.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('UserData')
        .doc(uid)
        .collection('default')
        .doc('myDefaultValue');

    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        defaultName = datasnapshot.data()["defaultName"];
      } else {
        defaultName = '';
      }
    });

    return defaultName;
  }
}
