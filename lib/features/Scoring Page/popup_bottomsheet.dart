import 'package:cloud_firestore/cloud_firestore.dart';

import '/res/components/customdialog.dart';
import '/res/components/customtaost.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../my matches/my matches.dart';
import '../my matches/selectopeners.dart';

class popup extends StatefulWidget {
  const popup({Key? key}) : super(key: key);

  @override
  _popupState createState() => _popupState();
}

class _popupState extends State<popup> {
  int _selectedTeam = 0;
  DocumentReference? _match;
  String _selectReason = "Select Reason";
  var args = Get.arguments;
  var currentuserid = '';
  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        print('matchid : ' + args['match_id']);
      });
    }
    _match = FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['match_id']);
  }

  Future _delete_dialog() async {
    dialog_func(
      Text('Are you sure?'),
      Text('Do you want to delete this Match?'),
      () => Navigator.pop(context),
      () async {
        Navigator.pop(context);
        customdialogcircularprogressindicator('Deleting');
        await FirebaseFirestore.instance
            .collection('matches')
            .doc(currentuserid)
            .collection('mymatches')
            .doc(args['match_id'])
            .delete()
            .then((value) async {
          await FirebaseFirestore.instance
              .collection('livematches')
              .doc(args['match_id'])
              .delete()
              .then((value) async {
            await FirebaseFirestore.instance
                .collection('scoring')
                .doc(currentuserid)
                .collection('my_matches')
                .doc(args['match_id'])
                .delete() // todo later
                .then((value) {
              Navigator.pop(context);
              customtoast('Match Deleted');
              Get.to(Matches());
            });
          });
        });
      },
    );
  }

// Custom Radio Button
  Widget customRadioButton(title, value, onChangedFunc) {
    return RadioListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      value: value,
      groupValue: _selectedTeam,
      onChanged: onChangedFunc,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

// Custom ListTiles
  Widget customListTile(titleText, selectIcon, onTapFunc, _showTrailing) {
    return ListTile(
      leading: (selectIcon != null)
          ? Icon(
              selectIcon,
              size: 22,
              color: (titleText == "Delete Match") ? Colors.red : null,
            )
          : null,
      title: Text(
        titleText,
        style: TextStyle(
            color: (titleText == "Delete Match")
                ? Colors.red
                : (titleText == "Reasons")
                    ? Colors.grey
                    : null,
            fontWeight: FontWeight.w600,
            fontSize: 18),
      ),
      onTap: onTapFunc,
      trailing: _showTrailing,
    );
  }

// Custom Divider()
  Widget customDivider = const Divider(height: 1.0, thickness: 1.5);
// Custom Container
  Widget customContainer(setAlignment, setTitle, double setFontSize) {
    return Container(
      alignment: setAlignment,
      padding: const EdgeInsets.all(14.0),
      child: Text(
        setTitle,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: setFontSize),
      ),
    );
  }

//
  void _resetAbandonMatch() {
    setState(() {
      _selectReason = "Select Reason";
      _selectedTeam = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;

    return PopupMenuButton(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(heightSize * 1 / 100))),
        padding: const EdgeInsets.all(10.0),
        offset: Offset(0, heightSize * 7 / 100),
        itemBuilder: !args['ismatchended']
            ? (context) => [
                  // PopupMenuItem(
                  //     child: customListTile("Retire Batsman", Icons.logout, () {
                  //   Navigator.pop(context);
                  //   customdialogcircularprogressindicator('InProgress');
                  // }, null)),
                  // PopupMenuItem(
                  //     child: customListTile("Change Strike",
                  //         CupertinoIcons.refresh_thick, () {}, null)),
                  // PopupMenuItem(
                  //     child: customListTile(
                  //         "Change Bowler", CupertinoIcons.arrow_2_squarepath,
                  //         () async {
                  //           var bowler_team;
                  //           var bowler_id;
                  //   await _match
                  //       ?.collection('innings')
                  //       .doc(args['inning_no'])
                  //       .get()
                  //       .then((DocumentSnapshot ds) {
                  //         bowler_team = ds['Bowler']['player_name'];
                  //         bowler_id = ds['Bowler']['player_id'];
                  //       });
                  //   Get.to(
                  //     () => selectplayer(),
                  //     arguments: {
                  //       'match_id': args['match_id'],
                  //       'team_name': bowler_team,
                  //       'appbartxt': 'Select Bowler',
                  //       'current_player_id': bowler_id,
                  //       'inning': args['inning_no'],
                  //     },
                  //   );
                  // }, null)),
                  // PopupMenuItem(
                  //     child: customListTile(
                  //         "Match Settings", Icons.settings_outlined, () {
                  //   Get.to(MatchSettings());
                  // }, null)),
                  // PopupMenuItem(
                  //     child: customListTile("Add Penality Runs",
                  //         CupertinoIcons.exclamationmark_triangle, () {}, null)),
                  PopupMenuItem(
                      child: customListTile(
                          "End Innings", Icons.do_not_disturb_alt_rounded, () {
                    args['inning_no'] == 'inning1'
                        ? Get.to(
                            () => select_openers(),
                            transition: Transition.rightToLeft,
                            arguments: {
                              'inning_no': 'inning2',
                              'match_id': args['match_id'],
                              'team1_id': args['team1_id'],
                              'team2_id': args['team2_id'],
                            },
                          )
                        : null;
                  }, null)),
                  // PopupMenuItem(
                  //   child: customListTile(
                  //     "Abandon Match",
                  //     CupertinoIcons.xmark_circle,
                  //     () {
                  //       Navigator.pop(context);
                  //       showAbandonMatchReason(context, widthSize, heightSize);
                  //     },
                  //     null,
                  //   ),
                  // ),
                  PopupMenuItem(
                      child: customListTile(
                          "Delete Match", CupertinoIcons.trash, () {
                    _delete_dialog();
                  }, null)),
                ]
            : (context) => [
                  PopupMenuItem(
                      child: customListTile(
                          "Delete Match", CupertinoIcons.trash, () {
                    _delete_dialog();
                  }, null)),
                ]);
  }

// Abandon Match BottomSheet

  Future<dynamic> showAbandonMatchReason(
      BuildContext context, double widthSize, double heightSize) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setSheetState) {
          return Wrap(
            children: [
              SizedBox(
                  height: 60,
                  child:
                      customContainer(Alignment.center, "Abandon Match", 22)),
              customDivider,
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customListTile(
                      "Reason",
                      null,
                      () {
                        matchEndReasons(context, setSheetState);
                      },
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton.icon(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          onPressed: null,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                          ),
                          label: Text(_selectReason,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: (_selectReason == "Select Reason")
                                      ? Colors.grey
                                      : const Color(0xdd000000))),
                        ),
                      ),
                    ),
                    customDivider,
                    customContainer(Alignment.centerLeft, "Winner?", 18),
                    customRadioButton("Team1", 1, (newValue) {
                      setSheetState(() {
                        _selectedTeam = newValue;
                      });
                    }),
                    customDivider,
                    customRadioButton("Team2", 2, (newValue) {
                      setSheetState(() {
                        _selectedTeam = newValue;
                      });
                    }),
                    customDivider,
                    SizedBox(height: heightSize * 25 / 100),
                    SizedBox(
                      height: heightSize * 6.5 / 100,
                      width: widthSize * 100 / 100,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //use this set state to set value to default
                            _resetAbandonMatch();
                          },
                          child: const Text("End Match",
                              style: TextStyle(fontSize: 18))),
                    )
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

// BottomSheet For Reason In Abandon Match BottomSheet
  Future<dynamic> matchEndReasons(
      BuildContext context, StateSetter setSheetState) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              customListTile("Reasons", null, null, null),
              customListTile("Rain", null, () {
                Navigator.pop(context);
                setSheetState(() {
                  _selectReason = "Rain";
                });
              }, null),
              customListTile("Bad Weather", null, () {
                Navigator.pop(context);
                setSheetState(() {
                  _selectReason = "Bad Weather";
                });
              }, null),
              customListTile("Bad Ground Condition", null, () {
                Navigator.pop(context);
                setSheetState(() {
                  _selectReason = "Bad Ground Condition";
                });
              }, null),
              customListTile("Bad Light", null, () {
                Navigator.pop(context);
                setSheetState(() {
                  _selectReason = "Bad Light";
                });
              }, null),
              customListTile("Other Reason", null, () {
                Navigator.pop(context);
                setSheetState(() {
                  _selectReason = "Other Reason";
                });
              }, null)
            ],
          );
        });
  }
}
