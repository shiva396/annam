import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/canteen/canteen_main_tab.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

class FirebaseOperations {
  static final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> addCategories(
      {required String categoryName,
      required String collegeName,
      required BuildContext context}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = (obj[firebaseAuth.currentUser!.uid]);

    List<String> existingData = update['categories'].keys.toList();
    List items = [];
    existingData.forEach((e) {
      items.add(e.toLowerCase());
    });

    if (!(items.contains(categoryName.toLowerCase()))) {
      obj[firebaseAuth.currentUser!.uid]['categories'] = {categoryName: {}};
      await firebaseInstance.collection('college').doc(collegeName).set(
          {firebaseAuth.currentUser!.uid: update}, SetOptions(merge: true));
    } else {
      context.showSnackBar("Category Already exists");
    }
  }

  static Future<void> addItems(
      {required String categoryName,
      required String itemName,
      required String itemPrice,
      required String collegeName,
      required BuildContext context,
      required XFile itemImageUrl}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = obj[firebaseAuth.currentUser!.uid]
        ['categories'][categoryName] as Map<String, dynamic>;

    List<String> existingData = update.keys.toList();
    List<String> items = [];
    existingData.forEach((e) {
      items.add(e.toLowerCase());
    });
    if (!items.contains(itemName.toLowerCase())) {
      String? imagePath;
      try {
        Reference reference = firebaseStorage.ref();
        Reference ref = reference.child(
            "canteenOwners/${firebaseAuth.currentUser!.uid}/${categoryName}/${itemName}");
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
    } else {
      context.showSnackBar("Item Already Exist");
    }
  }

  static Future<void> editItems(
      {required String categoryName,
      required String collegeName,
      required String newitemName,
      required String oldImagePath,
      required String itemPrice,
      required XFile? newImagePath,
      required String olditemName,
      required bool stockInHand}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseInstance.collection('college').doc(collegeName).get();
    Map<String, dynamic> obj = data.data() as Map<String, dynamic>;
    Map<String, dynamic> update = obj[firebaseAuth.currentUser!.uid]
        ['categories'][categoryName] as Map<String, dynamic>;
    update[olditemName] = FieldValue.delete();
    String? imagePath;
    if (newImagePath != null) {
      try {
        Reference reference = firebaseStorage.ref();
        Reference ref = reference.child(
            "canteenOwners/${firebaseAuth.currentUser!.uid}/${categoryName}/${newitemName}");
        UploadTask uploadTask = ref.putFile(File(newImagePath.path));
        TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
        imagePath = await onCompleted.ref.getDownloadURL();
      } catch (r) {}
    } else {
      imagePath = oldImagePath;
    }
    update[newitemName] = {
      "name": newitemName,
      "price": itemPrice,
      "imageUrl": imagePath,
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

    itemdata['totalAmount'] =
        FieldValue.increment(int.parse(price) * int.parse(quantity));
    QuerySnapshot<Map<String, dynamic>> obj = await firebaseInstance
        .collection('student')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('cart')
        .get();
    if (obj.docs.isNotEmpty) {
      if (obj.docs.first.data().containsKey(canteenName)) {
        firebaseInstance
            .collection('student')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('cart')
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          canteenName: itemdata,
        }, SetOptions(merge: true));
      } else {
        firebaseInstance
            .collection('student')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('cart')
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          canteenName: itemdata,
        }, SetOptions(merge: true));
      }
    } else {
      firebaseInstance
          .collection('student')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('cart')
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

  static Future<void> placeOrders(
      {required Map<String, dynamic> data,
      required String canttenOwnerId,
      required String collegeName}) async {
    DocumentSnapshot<Map<String, dynamic>> existingIds = await firebaseInstance
        .collection('student_orders_id')
        .doc('orders_id')
        .get();

    List<dynamic> existingUniqueIds = existingIds.get('orders_id');

    var random = Random();
    String orderId;
    do {
      int part1 = random.nextInt(90000) + 10000; // 5-digit number
      int part2 = random.nextInt(90000) + 10000; // 5-digit number
      orderId = '$part1$part2';
    } while (existingUniqueIds.contains(orderId));
    firebaseInstance.collection('student_orders_id').doc('orders_id').set({
      'orders_id': FieldValue.arrayUnion([orderId.toString()])
    }, SetOptions(merge: true));

    firebaseInstance
        .collection('student')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('cart')
        .doc(firebaseAuth.currentUser!.uid)
        .set({canttenOwnerId: FieldValue.delete()},
            SetOptions(merge: true)).then((v) {
      firebaseInstance
          .collection('student')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('orders')
          .doc(firebaseAuth.currentUser!.uid)
          .set({orderId.toString(): data}, SetOptions(merge: true)).then(
              (v) async {
        DocumentSnapshot<Map<String, dynamic>> collegeData =
            await firebaseInstance.collection('college').doc(collegeName).get();
        Map<String, dynamic> obj = collegeData.data() as Map<String, dynamic>;

        Map<String, dynamic> update = (obj[canttenOwnerId]);
        update['todayOrders'] =
            FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]);
        firebaseInstance
            .collection('college')
            .doc(collegeName)
            .set({canttenOwnerId: update}, SetOptions(merge: true));
      });
    });
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
