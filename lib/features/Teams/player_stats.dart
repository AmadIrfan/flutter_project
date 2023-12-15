import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/Teams/create_player.dart';
import '/features/Teams/popup.dart';

import '/res/components/customdialog.dart';
import '/res/components/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class PlayerStats extends StatefulWidget {
  const PlayerStats({Key? key}) : super(key: key);

  @override
  _PlayerStatsState createState() => _PlayerStatsState();
}

class _PlayerStatsState extends State<PlayerStats> {
  // for dynamic data final keyword have to be removed
  // dummy values are assigned to the below var.
  // final String _playerName = "Sami";
  // final String _playerRole = "Batting Allrounder";
  String _playerStatsType = "Batting";

  bool inprogress = false;

  var player_args = Get.arguments;

  String currentuserid = '';

  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        // downloadURLfunc(currentuserid, 'Pakstan');
      });
    }
  }

// Custom ListTiles
  Widget customListTile(titleText, onTapFunc, _showTrailing) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      dense: true,
      title: Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: (_showTrailing == null && titleText == "Stats")
              ? Colors.grey
              : null,
        ),
      ),
      onTap: onTapFunc,
      trailing: _showTrailing,
    );
  }

// custom SizedBox
  Widget fixedSizedBox = const SizedBox(
    height: 17,
  );
// custom verticleTile
  Widget customColumnTile(headingTitle, infoText, headingColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingTitle,
          style: TextStyle(
            fontWeight:
                (headingColor == null) ? FontWeight.w700 : FontWeight.w600,
            fontSize: (headingColor == null) ? 17 : 11,
            color: (headingColor == "") ? Colors.grey : null,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          infoText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (headingColor == null) ? 18 : 17,
          ),
        )
      ],
    );
  }

// Batting Stats
  Widget battingContainer(hSize, wSize) {
    return Container(
      height: hSize * 43.5 / 100,
      width: wSize,
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
      child: GridView.count(
        childAspectRatio: 1.7,
        crossAxisCount: 4,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        children: [
          customColumnTile("MATCHES", "0", ""),
          customColumnTile("INNINGS", "0", ""),
          customColumnTile("RUNS", "0", ""),
          customColumnTile("BALLS", "0", ""),
          customColumnTile("HIGHEST", "0", ""),
          customColumnTile("AVERAGE", "0.00", ""),
          customColumnTile("STRIKE RATE", "0.00", ""),
          customColumnTile("NOT OUTS", "0", ""),
          customColumnTile("FOURS", "0", ""),
          customColumnTile("SIXES", "0", ""),
          customColumnTile("DUCKS", "0", ""),
          customColumnTile("THIRTIES", "0", ""),
          customColumnTile("FIFTIES", "0", ""),
          customColumnTile("HUNDREDS", "0", ""),
        ],
      ),
    );
  }

// Bowling Stats
  Widget bowlingContainer(hSize, wSize) {
    return Container(
      height: hSize * 43.5 / 100,
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
      width: wSize,
      child: GridView.count(
        childAspectRatio: 1.7,
        crossAxisCount: 4,
        children: [
          customColumnTile("MATCHES", "0", ""),
          customColumnTile("INNINGS", "0", ""),
          customColumnTile("WICKETS", "0", ""),
          customColumnTile("BALLS", "0", ""),
          customColumnTile("RUNS", "0", ""),
          customColumnTile("MAIDENS", "0", ""),
          customColumnTile("DOT BALLS", "0", ""),
          customColumnTile("BEST", "0/0", ""),
          customColumnTile("ECONOMY", "0.00", ""),
          customColumnTile("AVERAGE", "0.00", ""),
          customColumnTile("STRIKE RATE", "0.00", ""),
          customColumnTile("WIDES", "0", ""),
          customColumnTile("NO BALLS", "0", ""),
          customColumnTile("3 WICKETS", "0", ""),
          customColumnTile("4 WICKETS", "0", ""),
          customColumnTile("5 WICKETS", "0", ""),
        ],
      ),
    );
  }

// Fielding Stats
  Widget fieldingContainer(hSize, wSize) {
    return Container(
      height: hSize * 43.5 / 100,
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
      width: wSize,
      child: GridView.count(
        childAspectRatio: 1.7,
        crossAxisCount: 4,
        children: [
          customColumnTile("MATCHES", "0", ""),
          customColumnTile("CATCHES", "0", ""),
          customColumnTile("STUMPINGS", "0", ""),
          customColumnTile("RUN OUTS", "0", ""),
        ],
      ),
    );
  }

  Future<void> _delete_player() async {
    return FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(player_args[0]['team_name'])
        .doc(player_args[0]['player_id'])
        .delete()
        .then((value) {
      player_args[0]['img_url'].toString().isNotEmpty
          ? FirebaseStorage.instance
              .refFromURL(player_args[0]['img_url'])
              .delete()
          : null;
      setState(() {
        inprogress = false;
      });
      Navigator.pop(context);
      customtoast('Player Deleted Successfully.');
    }).catchError((error) {
      customtoast('Failed to delete Player: $error');
      setState(() {
        inprogress = false;
      });
      Navigator.pop(context);
    });
  }

  Future _delete_dialog() async {
    dialog_func(
      Text('Are you sure?'),
      Text('Do you want to delete this player?'),
      () => Navigator.pop(context),
      () async {
        Navigator.pop(context);
        setState(() {
          inprogress = true;
        });
        var team1player_names = [];
        var team2player_names = [];
        await FirebaseFirestore.instance
            .collection('matches')
            .doc(currentuserid)
            .collection('mymatches')
            .get()
            .then((QuerySnapshot querysnap) {
          querysnap.docs.forEach((doc) {
            team1player_names.add(doc['team_details']['team1_players_ids']
                [player_args[0]['player_name']]);
            team1player_names.add(doc['team_details']['team2_players_ids']
                [player_args[0]['player_name']]);
          });
        });
        if (team1player_names
            .contains(player_args[0]['player_id'].toString())) {
          customtoast(
              "Can't delete this player.\nas it has played some matches.");
          setState(() {
            inprogress = false;
          });
        } else {
          _delete_player();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: heightSize * 9 / 100,
        title: Text(
          'Player Info',
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff424242),
        elevation: 2.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          inprogress
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                )
              : custompopup(
                  Icons.mode_edit_outline_outlined,
                  "Edit Player",
                  () {
                    Navigator.pop(context);
                    Get.to(
                      () => create_player(),
                      arguments: [
                        {
                          'isedit': true,
                          'player_id': player_args[0]['player_id'],
                          'team_name': player_args[0]['team_name'],
                          'appbartext': 'Edit Player',
                          'player_name': player_args[0]['player_name'],
                          'player_role': player_args[0]['player_role'],
                          'batting_style': player_args[0]['batting_style'],
                          'bowling_style': player_args[0]['bowling_style'],
                          'img_url': player_args[0]['img_url'],
                        }
                      ],
                      transition: Transition.leftToRight,
                    );
                  },
                  CupertinoIcons.trash,
                  "Delete Player",
                  () {
                    Navigator.pop(context);
                    _delete_dialog();
                  },
                ),
        ],
      ),
      body: Column(children: [
        Container(
          padding:
              const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
          height: heightSize * 30 / 100,
          width: widthSize,
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80.0,
                      ),
                      radius: 50,
                      foregroundImage: CachedNetworkImageProvider(
                        player_args[0]['img_url'].toString(),
                      ),
                    ),
                  ),
                  SizedBox(width: widthSize * 4 / 100),
                  customColumnTile(player_args[0]['player_name'],
                      player_args[0]['player_role'], null),
                ],
              ),
              fixedSizedBox,
              //  SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.07,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customColumnTile(
                      "Batting Style", player_args[0]['batting_style'], null),
                  SizedBox(
                    width: widthSize * 7 / 100,
                  ),
                  customColumnTile(
                      "Bowling Style", player_args[0]['bowling_style'], null)
                ],
              ),
              fixedSizedBox,
              // customColumnTile("Teams", _teamName, null),
              // Container(
              //   height: heightSize * 5 / 100,
              //   alignment: Alignment.topCenter,
              //   child: customListTile(
              //     "Stats",
              //     () {
              //       selectPlayerStatsType(context);
              //     },
              //     Directionality(
              //       textDirection: TextDirection.rtl,
              //       child: TextButton.icon(
              //         onPressed: null,
              //         style: ButtonStyle(
              //             overlayColor:
              //                 MaterialStateProperty.all(Colors.transparent)),
              //         icon: const Icon(
              //           Icons.arrow_drop_down,
              //         ),
              //         label: Text(_playerStatsType,
              //             style: const TextStyle(
              //               fontWeight: FontWeight.w700,
              //               fontSize: 17,
              //               color: Colors.black,
              //             )),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        // (_playerStatsType == "Batting")
        //     ? battingContainer(heightSize, widthSize)
        //     : (_playerStatsType == "Bowling")
        //         ? bowlingContainer(heightSize, widthSize)
        //         : fieldingContainer(heightSize, widthSize),
      ]),
    );
  }

  Future<dynamic> selectPlayerStatsType(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Wrap(
              children: [
                customListTile("Stats", null, null),
                customListTile("Batting", () {
                  Navigator.pop(context);
                  setState(() {
                    _playerStatsType = "Batting";
                  });
                }, null),
                customListTile("Bowling", () {
                  Navigator.pop(context);
                  setState(() {
                    _playerStatsType = "Bowling";
                  });
                }, null),
                customListTile("Fielding", () {
                  Navigator.pop(context);
                  setState(() {
                    _playerStatsType = "Fielding";
                  });
                }, null),
              ],
            ),
          );
        });
  }
}
