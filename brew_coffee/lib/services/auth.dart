import 'package:brew_coffee/models/user.dart';
import 'package:brew_coffee/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create users class object based on firebase uid
  Users _userFromFirebase(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //auth change user stream

  Stream<Users> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebase(user));
  }

  //sign anno
  Future singInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email/pass
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //creat a new document for the user with the uid
      await Databaseservie(uid: user.uid)
          .updateUserDate('0', 'new crew member', 100);
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
