import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager{
  final CollectionReference profileList =
  FirebaseFirestore.instance.collection('profileInfo');

  Future<void> createUserData(
      String name, String email, String password, String mobile, String age, String dob, String uid) async {
    return await profileList
        .doc(uid)
        .set({'name': name, 'email': email, 'password': password, 'mobile' : mobile, 'age': age, 'dob' : dob, });
  }

  Future updateUserList(String name, String email, String password, String mobile, String age, String dob, String uid) async {
    return await profileList.doc(uid).update({
      'name': name, 'email': email, 'password': password, 'mobile' : mobile, 'age': age, 'dob' : dob,
    });
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}