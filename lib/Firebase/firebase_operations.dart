import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseOperations {
  static final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> addCategories(
      {required String categoryName, required String collegeName}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = (obj[firebaseAuth.currentUser!.uid]);
    obj[firebaseAuth.currentUser!.uid]['categories'] = {categoryName: {}};
    //  TODO : Check for existing categories Name

    await firebaseInstance
        .collection('college')
        .doc(collegeName)
        .set({firebaseAuth.currentUser!.uid: update}, SetOptions(merge: true));
  }

  static Future<void> addItems(
      {required String categoryName,
      required String itemName,
      required String itemPrice,
      required String collegeName,
      required XFile itemImageUrl}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = obj[firebaseAuth.currentUser!.uid]
        ['categories'][categoryName] as Map<String, dynamic>;
         //  TODO : Check for existing item Name
    String? imagePath;
    try {
      Reference reference = firebaseStorage.ref();
      Reference ref = reference.child(
          "canteenOwner/${firebaseAuth.currentUser!.uid}/${categoryName}/${itemName}");
      UploadTask uploadTask = ref.putFile(File(itemImageUrl.path));
      TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
      imagePath = await onCompleted.ref.getDownloadURL();
    } catch (r) {}
    update[itemName] = {
      "name": itemName,
      "price": itemPrice,
      "imageUrl": imagePath != null ? imagePath : "empty",
      "stockInHand": true,
    };

    await firebaseInstance.collection('college').doc(collegeName).set({
      firebaseAuth.currentUser!.uid: {
        'categories': {categoryName: update}
      }
    }, SetOptions(merge: true));
  }

  static Future<void> editItems(
      {required String categoryName,
      required String collegeName,
      required String newitemName,
      required String itemPrice,
      required String itemImageUrl,
      required String olditemName,
      required bool stockInHand}) async {
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
      "stockInHand": stockInHand,
    };

    await firebaseInstance.collection('college').doc(collegeName).set({
      firebaseAuth.currentUser!.uid: {
        'categories': {categoryName: update}
      }
    }, SetOptions(merge: true));
  }

  static Future<void> removeItems(
      {required String categoryName,
      required String collegeName,
      required String itemName}) async {
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

  static Future<void> addCartItems(
      {required String canteenName,
      required String itemName,
      required String collegeName,
      required String price,
      required String quantity}) async {
    Map<String, dynamic> itemdata = {};
    itemdata[itemName] = {
      "name": itemName,
      "price": price,
      "quantity": quantity,
    };
    itemdata['time'] = DateTime.now().toString();
    itemdata['checkOut'] = false;
    itemdata['totalAmount'] =
        FieldValue.increment(int.parse(price) * int.parse(quantity));
    QuerySnapshot<Map<String, dynamic>> obj = await firebaseInstance
        .collection('student')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .get();
    if (obj.docs.isNotEmpty) {
      if (obj.docs.first.data().containsKey(canteenName)) {
        firebaseInstance
            .collection('student')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('orders')
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          canteenName: itemdata,
        }, SetOptions(merge: true));
      } else {
        firebaseInstance
            .collection('student')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('orders')
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          canteenName: itemdata,
        }, SetOptions(merge: true)).then((v) async {
          DocumentSnapshot<Map<String, dynamic>> collegeData =
              await firebaseInstance
                  .collection('college')
                  .doc(collegeName)
                  .get();
          Map<String, dynamic> obj = collegeData.data() as Map<String, dynamic>;

          Map<String, dynamic> update = (obj[canteenName]);
          update['todayOrders'] =
              FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]);
          firebaseInstance
              .collection('college')
              .doc(collegeName)
              .set({canteenName: update}, SetOptions(merge: true));
        });
      }
    } else {
      firebaseInstance
          .collection('student')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('orders')
          .doc(firebaseAuth.currentUser!.uid)
          .set({canteenName: itemdata}).then((v) async {
        DocumentSnapshot<Map<String, dynamic>> collegeData =
            await firebaseInstance.collection('college').doc(collegeName).get();
        Map<String, dynamic> obj = collegeData.data() as Map<String, dynamic>;

        Map<String, dynamic> update = (obj[canteenName]);
        update['todayOrders'] =
            FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]);
        firebaseInstance
            .collection('college')
            .doc(collegeName)
            .set({canteenName: update}, SetOptions(merge: true));
      });
    }
  }

  static Future<void> checkOutItems({required String studentId}) async {
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseInstance
        .collection('student')
        .doc(studentId)
        .collection('orders')
        .doc(studentId)
        .get();
    Map<String, dynamic> orderedItems =
        data.data()![firebaseAuth.currentUser!.uid];
    orderedItems['checkOut'] = true;
    orderedItems['canteenId'] = firebaseAuth.currentUser!.uid;

    firebaseInstance
        .collection('student')
        .doc(studentId)
        .collection('history')
        .doc(studentId)
        .set({DateTime.now().toString(): orderedItems},
            SetOptions(merge: true)).then((v) {
      firebaseInstance
          .collection('student')
          .doc(studentId)
          .collection('orders')
          .doc(studentId)
          .set({firebaseAuth.currentUser!.uid: FieldValue.delete()},
              SetOptions(merge: true));
    });
  }

  static Future<void> pushToHistoryForCanteenOwners(
      {required String userName,
      required Map<String, dynamic> data,
      required String timeStamp}) async {
    data['studentName'] = userName;
    firebaseInstance
        .collection('history')
        .doc(firebaseAuth.currentUser!.uid)
        .set({timeStamp: data}, SetOptions(merge: true));
  }

  static Future<void> deleteOrders({
    required String canteenId,
  }) async {
    firebaseInstance
        .collection('student')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(firebaseAuth.currentUser!.uid)
        .update({canteenId: FieldValue.delete()});
  }

  static Future<void> studentLikes(
      {required bool like,
      required String categoryName,
      required String itemName,
      required String canteenId}) async {
    Map<String, dynamic> data = {};
    data[categoryName] = {itemName: like};
    firebaseInstance
        .collection('student')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('likes')
        .doc(canteenId)
        .set(data, SetOptions(merge: true));
  }
}
