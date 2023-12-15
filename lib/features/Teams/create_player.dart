import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/res/components/customtaost.dart';
import '/res/components/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class create_player extends StatefulWidget {
  const create_player({Key? key}) : super(key: key);

  @override
  _create_playerState createState() => _create_playerState();
}

class _create_playerState extends State<create_player> {
  var playerargs = Get.arguments;

  String player_role = '';
  String batting_style = '';
  String bowling_style = '';
  String player_pic_path = '';
  var currentuserid = '';
  String downloadURL = '';
  var __team_name = '';
  bool IsSelected = false;
  bool inprogress = false;
  TextEditingController _playername = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var __teamname = Get.arguments;

  CollectionReference players =
      FirebaseFirestore.instance.collection('players');

  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        _playername.text = __teamname[0]['player_name'];
        batting_style = __teamname[0]['batting_style'];
        bowling_style = __teamname[0]['bowling_style'];
        player_role = __teamname[0]['player_role'];
        downloadURL = __teamname[0]['img_url'];
        __team_name = __teamname[0]['team_name'];
      });
    }
  }

  Future<void> uploadFile(String filePath, player_name) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(
              'images/player_photos/$currentuserid/$__team_name/$player_name.png')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      Get.snackbar('Error occured.', '');
    }
  }

  Future<void> downloadURLfunc(cuserid, player_name) async {
    String imgurl = await firebase_storage.FirebaseStorage.instance
        .ref(
            'images/player_photos/$currentuserid/$__team_name/$player_name.png')
        .getDownloadURL();
    setState(() {
      downloadURL = imgurl;
    });
  }

  Future _query() async {
    return playerargs[0]['isedit']
        ? players
            .doc(currentuserid)
            .collection(__teamname[0]['team_name'])
            .doc(playerargs[0]['player_id'].toString())
            .update({
            'player_name': _playername.text,
            'player_role': player_role.toString(),
            'batting_style': batting_style.toString(),
            'bowling_style': bowling_style.toString(),
            'imgurl': downloadURL.toString(),
          })
        : players
            .doc(currentuserid)
            .collection(__teamname[0]['team_name'])
            .add({
            'player_name': _playername.text,
            'player_role': player_role.toString(),
            'batting_style': batting_style.toString(),
            'bowling_style': bowling_style.toString(),
            'imgurl': downloadURL.toString(),
          });
  }

  Future<void> savedata() async {
    return _query().then((value) {
      setState(() {
        inprogress = false;
        _playername.clear();
        player_role = '';
        batting_style = '';
        bowling_style = '';
      });

      Get.back();

      playerargs[0]['isedit']
          ? customtoast('Player Updated')
          : customtoast('Player Added');
    }).catchError((error) {
      setState(() {
        inprogress = false;
      });
      playerargs[0]['isedit']
          ? customtoast("Failed to update Player: $error")
          : customtoast("Failed to add Player: $error");
    });
  }

  Future<void> addplayer() async {
    if (player_pic_path.isNotEmpty) {
      uploadFile(player_pic_path, _playername.text).then((value) {
        downloadURLfunc(currentuserid, _playername.text).then((value) {
          savedata();
        });
      });
    } else {
      savedata();
    }
  }

  Widget custombottomsheet(tilename, Wrapsheet, player_var) {
    return ListTile(
      contentPadding: EdgeInsets.all(8.0),
      dense: true,
      onTap: () {
        showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
            ),
            context: context,
            builder: (context) {
              return Wrapsheet;
            });
      },
      leading: Text(
        tilename,
        style: TextStyle(
            color: Colors.grey[900], fontWeight: FontWeight.w800, fontSize: 18),
      ),
      // subtitle: subtile,
      trailing: player_var.toString().isEmpty
          ? Wrap(
              children: [
                Text(
                  "Select",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[500],
                  size: 23,
                ),
              ],
            )
          : Text(
              player_var,
              style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
    );
  }

  Widget sheetlisttile(_title, playervar) {
    return ListTile(
      dense: true,
      onTap: () {
        setState(() {
          if (playervar == 1) {
            player_role = _title;
          } else if (playervar == 2) {
            batting_style = _title;
          } else if (playervar == 3) {
            bowling_style = _title;
          }
        });
        Navigator.pop(context);
      },
      selected: true,
      title: Text(
        _title,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          playerargs[0]['appbartext'].toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w500),
        ),
        actions: [
          inprogress
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                )
              : IconButton(
                  onPressed: inprogress
                      ? null
                      : () {
                          if (_formkey.currentState!.validate()) {
                            if (player_role.isNotEmpty) {
                              if (batting_style.isNotEmpty) {
                                if (bowling_style.isNotEmpty) {
                                  setState(() {
                                    inprogress = true;
                                  });
                                  // addplayer func will be here
                                  addplayer();
                                } else {
                                  //  Get.snackbar('', 'Please Select bowling style');
                                  customtoast('Please Select Bowling Style');
                                }
                              } else {
                                //  Get.snackbar('', 'Please Select batting style');
                                customtoast('Please Select Batting Style');
                              }
                            } else {
                              //  Get.snackbar('', 'Please Select player role');
                              customtoast('Please Select Player Role');
                            }
                          }
                        },
                  icon: Icon(
                    Icons.check,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () {
                filepicker().then((selectedpath) {
                  if (selectedpath.toString().isNotEmpty) {
                    setState(() {
                      player_pic_path = selectedpath;
                      IsSelected = true;
                      // uploadFile(selectedpath.toString());
                    });
                  }
                });
              },
              child: IsSelected
                  ? CircleAvatar(
                      radius: 50.0,
                      foregroundImage: FileImage(File(player_pic_path)),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      radius: 50.0,
                      foregroundImage: CachedNetworkImageProvider(
                          __teamname[0]['img_url'].toString()),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black26,
                    ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formkey,
              child: TextFormField(
                  controller: _playername,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'required';
                    }
                  },
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: "Player Name",
                    labelStyle: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700),
                  )),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          custombottomsheet(
            "Player Role",
            Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Player Role",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 19),
                ),
              ),
              sheetlisttile("Batsman", 1),
              sheetlisttile("Wicketkeeper", 1),
              sheetlisttile("Batting Allrounder", 1),
              sheetlisttile("Bowling Allrounder", 1),
              sheetlisttile("Bowler", 1),
            ]),
            player_role,
          ),
          custombottomsheet(
            "Batting style",
            Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Batting style",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 19),
                ),
              ),
              sheetlisttile("Right Hand", 2),
              sheetlisttile("Left hand", 2),
            ]),
            batting_style,
          ),
          custombottomsheet(
            "Bowling Style",
            Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Bowling Style",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 19),
                ),
              ),
              sheetlisttile("Right Arm Fast", 3),
              sheetlisttile("Right Arm Fast Medium", 3),
              sheetlisttile("Right Arm Medium", 3),
              sheetlisttile("Right Arm Off Spin", 3),
              sheetlisttile("Right Arm Leg Spin", 3),
              sheetlisttile("Left Arm Fast", 3),
              sheetlisttile("Left Arm Fast Medium", 3),
              sheetlisttile("Left Arm Medium", 3),
              sheetlisttile("Left Arm Orthodox", 3),
              sheetlisttile("Left Arm Chinaman", 3),
            ]),
            bowling_style,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
