import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseOperations {
  static final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> addCategories(
      String categoryName, String collegeName) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = (obj[firebaseAuth.currentUser!.uid]);
    obj[firebaseAuth.currentUser!.uid]['categories'] = {categoryName: {}};
    // print({firebaseAuth.currentUser!.uid: update});
    await firebaseInstance
        .collection('college')
        .doc(collegeName)
        .set({firebaseAuth.currentUser!.uid: update}, SetOptions(merge: true));
  }

  static Future<void> addItems(String categoryName, String collegeName,
      String itemName, String itemPrice, String itemImageUrl) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = obj[firebaseAuth.currentUser!.uid]
        ['categories'][categoryName] as Map<String, dynamic>;
    update[itemName] = {
      "name": itemName,
      "price": itemPrice,
      "imageUrl": itemImageUrl,
      "stockInHand": false,
    };

    await firebaseInstance.collection('college').doc(collegeName).set({
      firebaseAuth.currentUser!.uid: {
        'categories': {categoryName: update}
      }
    }, SetOptions(merge: true));
  }

  static Future<void> editItems(
      String categoryName,
      String collegeName,
      String newitemName,
      String itemPrice,
      String itemImageUrl,
      String olditemName) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = obj[firebaseAuth.currentUser!.uid]
        ['categories'][categoryName] as Map<String, dynamic>;
    update[olditemName] = FieldValue.delete();
    update[newitemName] = {
      "name": newitemName,
      "price": itemPrice,
      "imageUrl": itemImageUrl,
      "stockInHand": false,
    };

    await firebaseInstance.collection('college').doc(collegeName).set({
      firebaseAuth.currentUser!.uid: {
        'categories': {categoryName: update}
      }
    }, SetOptions(merge: true));
  }

  static Future<void> removeItems(
      String categoryName, String collegeName, String itemName) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = obj[firebaseAuth.currentUser!.uid]
        ['categories'][categoryName] as Map<String, dynamic>;
    update[itemName] = FieldValue.delete();

    await firebaseInstance.collection('college').doc(collegeName).set({
      firebaseAuth.currentUser!.uid: {
        'categories': {categoryName: update}
      }
    }, SetOptions(merge: true));
  }

  static Future<Map> fetchData(String collegeName) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update =
        (obj[firebaseAuth.currentUser!.uid])['categories'];

    return update;
  }
}
