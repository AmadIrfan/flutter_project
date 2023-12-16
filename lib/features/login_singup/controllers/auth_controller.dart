import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../res/components/customtaost.dart';
import '../../home/home_page.dart';

import '../../user profile/edit_profile.dart';
import '../../user profile/user_model.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Check if the user is already signed in on app start
    user.value = _auth.currentUser;
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw 'Google sign-in was cancelled';
      }

      // Obtain the GoogleAuthCredential for Firebase Authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user.value = userCredential.user;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          print('here1c');
          Get.to(const HomePage());
          // customtoast('Login Successful');
          // _email.clear();
          // _password.clear();
        } else {
          Get.to(
            Editprofile(
              isedit: false,
              userData: UserModel(
                UserCity: '',
                UserCountry: '',
                UserCreatedOn: '',
                UserEmail: '',
                UserId: '',
                UserImage: '',
                UserName: '',
              ),
            ),
            arguments: [
              {
                'isedit': false,
                'appbartitle': 'Set profile',
                '_displayname': '',
                '_countryname': '',
                '_cityname': '',
                '_profilepic':
                    'https://banner2.cleanpng.com/20180702/juw/kisspng-australia-national-cricket-team-bowling-cricket-5b39ce04df1a32.1401674715305149489138.jpg',
              },
            ],
          );
          // _email.clear();
          // _password.clear();
        }
      });
      customtoast('Login Successful');
    } catch (error) {
      // Handle the error in the UI
      throw error;
    }
  }

  Future<void> signOut() async {
    try {
      GoogleSignIn().signOut();
      await _auth.signOut();
      user.value = null;
    } catch (error) {
      print('Error signing out: $error');
      // Handle the error in the UI
      throw error;
    }
  }
}
