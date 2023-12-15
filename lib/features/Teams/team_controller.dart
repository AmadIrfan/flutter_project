import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import '../../res/components/customtaost.dart';

class TeamController extends GetxController {
  RxBool inprogress = false.obs;
  RxString filepath = ''.obs;
  RxString downloadURL = ''.obs;
  RxBool IsSelected = false.obs;
  CollectionReference teams = FirebaseFirestore.instance.collection('teams');

  Future<void> savedata(
      __teamname, __teamlocation, __teamshortname, isedit, team_doc_id) async {
    return isedit
        ? teams
            .doc(currentuser.uid)
            .collection('myteams')
            .doc(team_doc_id)
            .set({
            'team_name': __teamname,
            'team_location': __teamlocation,
            'teamshortname': __teamshortname,
            'imgurl': downloadURL.toString(),
          }, SetOptions(merge: true)).then((value) {
            inprogress.value = false;

            Get.back();
            customtoast('Team info updated');
            // Get.snackbar('Team Added', '');
          }).catchError((error) {
            // setState(() {
            inprogress.value = false;
            // });
            customtoast('Failed to update team: $error');
            // Get.snackbar('', 'Failed to add team: $error');
          })
        : teams.doc(currentuser.uid).collection('myteams').add({
            'team_name': __teamname,
            'team_location': __teamlocation,
            'teamshortname': __teamshortname,
            'imgurl': downloadURL.toString(),
            'stats': {
              'played': 0,
              'won': 0,
              'lost': 0,
              'draw': 0,
              'win_percentage': 0,
            }
          }).then((value) {
            // setState(() {
            inprogress.value = false;
            IsSelected.value = false;
            // });
            Get.back();

            customtoast('Team added');
            // Get.snackbar('Team Added', '');
          }).catchError((error) {
            // setState(() {
            inprogress.value = false;
            IsSelected.value = false;

            // });
            customtoast('Failed to add team: $error');
            // Get.snackbar('', 'Failed to add team: $error');
          });
  }

  Future<void> addteam(
      teamname, teamlocation, teamshortname, isedit, team_doc_id) async {
    // Call the user's CollectionReference to add a new user
    if (filepath.isNotEmpty) {
      await uploadFile(filepath.value, teamname).then((value) {
        downloadURLfunc(currentuser.uid, teamname).then((value) {
          savedata(teamname, teamlocation, teamshortname, isedit, team_doc_id);
        });
      });
    } else {
      savedata(teamname, teamlocation, teamshortname, isedit, team_doc_id);
    }
  }

  Future<void> uploadFile(String filePath, team_name) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('images/team_logos/${currentuser.uid}/$team_name.png')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      Get.snackbar('Error occured.', '');
    }
  }

  Future<void> downloadURLfunc(cuserid, team_name) async {
    String imgurl = await firebase_storage.FirebaseStorage.instance
        .ref('images/team_logos/$cuserid/$team_name.png')
        .getDownloadURL();
    // setState(() {
    downloadURL.value = imgurl;
    // });
  }
}
