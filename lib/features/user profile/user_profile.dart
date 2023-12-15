// import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/user%20profile/edit_profile.dart';
import '/features/user%20profile/profile_controller.dart';
import '/features/user%20profile/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class UserProfile extends StatelessWidget {
  Widget customtile(_title, _trailing) {
    return ListTile(
      title: Text(
        _title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      trailing: Text(
        _trailing,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget CustomDivider() {
    return Divider(
      indent: 10.0,
      endIndent: 10.0,
      color: Colors.grey[800],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController _controller = Get.put(ProfileController());
    // __controller.getUserData();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                tooltip: 'Edit Profile',
                onPressed: () {
                  Get.to(
                    Editprofile(
                      userData: _controller.userData!,
                      isedit: true,
                    ),
                    transition: Transition.leftToRight,
                    // arguments: [
                    //   {
                    //     'isedit': true,
                    //     'appbartitle': 'Edit profile',
                    //     '_displayname': currentusername,
                    //     '_countryname': currentusercountry,
                    //     '_cityname': currentusercity,
                    //     '_profilepic': downloadURL.toString(),
                    //   },
                    // ],
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.userPen,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection('users')
                .doc(currentuser.uid.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('something went wrong'),
                );
              } else {
                final docsnap = snapshot.data!.data() as Map;
                // print(docsnap);
                _controller.userData = UserModel(
                  UserCity: docsnap['city'],
                  UserCountry: docsnap['country'],
                  UserName: docsnap['full_name'],
                  UserCreatedOn: currentuser.metadata.creationTime.toString(),
                  UserEmail: currentuser.email.toString(),
                  UserId: currentuser.uid.toString(),
                  UserImage: firebaseAuth.currentUser!.photoURL.toString(),
                );
                // print(_controller.userData!.UserCity);
                // print(_controller.userData!.UserCountry);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        foregroundImage: CachedNetworkImageProvider(
                            _controller.userData!.UserImage),
                        child: Icon(
                          Icons.person,
                          size: 80.0,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.black26,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _controller.userData!.UserName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child:
                                FirebaseAuth.instance.currentUser!.emailVerified
                                    ? Icon(
                                        FontAwesomeIcons.solidCircleCheck,
                                        color: Colors.teal,
                                        size: 20.0,
                                      )
                                    : Text(''),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        _controller.userData!.UserEmail,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    CustomDivider(),
                    customtile('Country', _controller.userData!.UserCountry),
                    CustomDivider(),
                    customtile('City', _controller.userData!.UserCity),
                    CustomDivider(),
                    customtile(
                        'Created on', _controller.userData!.UserCreatedOn),
                    CustomDivider(),
                  ],
                );
              }
            }));
  }
}



// ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.transparent,
//                   child: Icon(
//                     FontAwesomeIcons.solidUserCircle,
//                     color: Colors.grey,
//                     size: 40.0,
//                   ),
//                 ),
//                 title: Text(
//                   'Shami',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 subtitle: Text(
//                   'abc11@gmail.com',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),