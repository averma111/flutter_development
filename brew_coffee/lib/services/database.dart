import 'package:brew_coffee/models/brew.dart';
import 'package:brew_coffee/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservie {
  final String uid;

  Databaseservie({this.uid});

  //collection reference
  final CollectionReference coffeCollection =
      FirebaseFirestore.instance.collection('coffee');

  Future updateUserDate(String sugars, String name, int strength) async {
    return await coffeCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  List<Brew> _brewListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
          name: doc.data()['name'] ?? '',
          strength: doc.data()['strength'] ?? '',
          sugar: doc.data()['sugar'] ?? '0');
    }).toList();
  }

  // user data from snapshot

  Userdata _userDataFromSnapshot(DocumentSnapshot snaphost) {
    return Userdata(
        uid: uid,
        name: snaphost.data()['name'],
        sugars: snaphost.data()['sugars'],
        strength: snaphost.data()['strength']);
  }

  //new database stream
  Stream<List<Brew>> get brews {
    return coffeCollection.snapshots().map(_brewListFromSnapShot);
  }

  Stream<Userdata> get userData {
    return coffeCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

//get user doc stream
