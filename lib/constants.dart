import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

double? responsiveHW(ctx, {ht, wd}) {
  return (ht != null)
      ? MediaQuery.of(ctx).size.height * ht / 100
      : (wd != null)
          ? MediaQuery.of(ctx).size.width * wd / 100
          : null;
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
var currentuser = firebaseAuth.currentUser!;
Color color1 = Color(0xffF2DDB6).withOpacity(0.5);
Color color2 = Color(0xffA82A2A).withOpacity(0.3);
