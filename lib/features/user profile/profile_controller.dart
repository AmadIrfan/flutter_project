import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/user%20profile/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../home/home_page.dart';

class ProfileController extends GetxController {
  UserModel? userData;
  RxBool isworking = false.obs;
  RxBool IsSelected = false.obs;
  RxString path = ''.obs;

  @override
  void onInit() {
    // getUserData();
    super.onInit();
  }

  // Future getUserData() async {
  //   var currentuser = firebaseAuth.currentUser!;
  //   firestore
  //       .collection('users')
  //       .doc(currentuser.uid.toString())
  //       .get()
  //       .then((DocumentSnapshot docsnap) {
  //     if (docsnap.exists) {
  //       userData = UserModel(
  //         UserCity: docsnap['city'],
  //         UserCountry: docsnap['country'],
  //         UserName: currentuser.displayName.toString(),
  //         UserCreatedOn: currentuser.metadata.creationTime.toString(),
  //         UserEmail: currentuser.email.toString(),
  //         UserId: currentuser.uid.toString(),
  //         UserImage: currentuser.photoURL.toString(),
  //       );
  //       // setState(() {
  //       //   currentusername = docsnap['full_name'];
  //       //   currentusercountry = docsnap['country'];
  //       //   currentusercity = docsnap['city'];
  //       // });
  //     }
  //     update();
  //   });
  // }

  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String url = '';
    try {
      await FirebaseStorage.instance
          .ref('images/profile_pictures/${firebaseAuth.currentUser!.uid}.png')
          .putFile(file)
          .then((p0) async {
        url = await p0.ref.getDownloadURL();
      });
    } on FirebaseException catch (e) {
      Get.snackbar('Error occured.$e', '');
    }
    return url;
  }

  Future<void> addUser(displayname, country, city, isedit) async {
    // Call the user's CollectionReference to add a new user
    // return profileargs[0]['isedit']
    //     ?
    firebaseAuth.currentUser!.updateDisplayName(displayname);
    firestore.collection('users').doc(firebaseAuth.currentUser!.uid).set({
      'full_name': displayname,
      'country': country,
      'city': city,
    }, SetOptions(merge: true)).then((value) {
      if (path.isNotEmpty) {
        uploadFile(path.value).then((value) {
          isworking.value = false;
          if (value.isNotEmpty) {
            firebaseAuth.currentUser!.updatePhotoURL(value);
            path.value = '';
            IsSelected.value = false;
          }

          // Get.reset(clearRouteBindings: true);
          isedit
              ? Get.back()
              : Get.to(HomePage(), transition: Transition.rightToLeft);
          Get.snackbar('Data Updated', '');
        });
      } else {
        isworking.value = false;

        isedit
            ? Get.back()
            : Get.to(HomePage(), transition: Transition.rightToLeft);
        Get.snackbar('Data Saved', '');
      }
    }).catchError((error) {
      isworking.value = false;

      // Get.snackbar('', 'Failed to add user: $error');
    });
  }
}
