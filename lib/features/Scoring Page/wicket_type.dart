import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/Scoring%20Page/batsman_selection.dart';

import '/res/components/customdialog.dart';
import '/res/components/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WicketType extends StatefulWidget {
  final int? wicketType;
  const WicketType({Key? key, @required this.wicketType}) : super(key: key);

  @override
  _WicketTypeState createState() => _WicketTypeState();
}

class _WicketTypeState extends State<WicketType> {
  int _selectedRadio = -1;
  bool _isCrossed = false;
  bool _wideChecked = false;
  bool _noBallChecked = false;
  bool _byesChecked = false;
  bool _legByesChecked = false;

  String _selectedOutBatsman = "Select Out Batsman";
  String outBatsmanImage = "person";

  String _selectedFielder = "Select Fielder";
  // String _selectedFielder1 = "Select Fielder 1";
  // String _selectedFielder2 = "Select Fielder 2";
  String fielderImage = "person";
  String fielderImage1 = "person";
  String fielderImage2 = "person";
  // var batter_name = 'Select New Batsman';
  // var batter_img = '';
  // var batter_role = '';
  // var batter_id = '';
  var args = Get.arguments;
  var currentuserid;
  String _newBatsmanOn = "New Batsman On";
  final player_info_box = GetStorage('player_info');
  final TextEditingController _runsScored = TextEditingController(text: '0');
  var batter_team;
  // var match;
  var fielders = [];
  var current_batters = [];
  var notout_batters = 0;
  @override
  void initState() {
    super.initState();
    player_info_box.erase();
    player_info_box.write('isselected', false);
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // setState(() {
      currentuserid = currentUser.uid;
      batters_left();
      getfielders();
      getbatters();
      player_info_listener();
      // });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> player_info_listener() async {
    var info = player_info_box.read('player');
    player_info_box.listen(() {
      setState(() {
        // if (info != null) {
        //   batter_name = info['player_name'];
        //   batter_img = info['imgurl'];
        //   batter_role = info['player_role'];
        // }
      });
    });
  }

  Future getfielders() async {
    var bowler_id;
    var bowler_team;
    await FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('innings')
        .doc(args['inning_no'])
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        bowler_id = ds['Bowler']['player_id'];
        bowler_team = ds['Bowler']['team_name'];
      }
    });
    await FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('teams_players')
        .where(FieldPath.documentId, isNotEqualTo: bowler_id)
        .get()
        .then((QuerySnapshot querysnap) {
      querysnap.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('players')
            .doc(currentuserid)
            .collection(bowler_team.toString())
            .doc(doc.id.toString())
            .get()
            .then((DocumentSnapshot player) {
          fielders.add({
            'player_name': player['player_name'],
            'imgurl': player['imgurl'],
          });
        });
      });
    });
  }

  Future getbatters() async {
    // var batters = [];
    // print(args['inning_no']);
    // await FirebaseFirestore.instance
    //     .collection('scoring')
    //     .doc(currentuserid)
    //     .collection('my_matches')
    //     .doc(args['match_id'])
    //     .collection('innings')
    //     .doc(args['inning_no'])
    //     .get()
    //     .then((DocumentSnapshot ds) {
    //   if (ds.exists) {
    //     // batter_team = ds['Batter1']['team_name'];
    //     batters.add(ds['Batter1']['player_id']);
    //     batters.add(ds['Batter2']['player_id']);
    //   }
    // });
    await FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(args['team_name'])
        .where(FieldPath.documentId, whereIn: args['batters_names'])
        .get()
        .then((QuerySnapshot players) {
      players.docs.forEach((player) {
        current_batters.add({
          'player_name': player['player_name'],
          'player_role': player['player_role'],
          'batting_style': player['batting_style'],
          'player_id': player.id.toString(),
          'imgurl': player['imgurl'],
        });
      });
    }).then((value) {
      setState(() {});
    });
  }

  Future<void> batters_left() async {
    print(batter_team);
    return FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('teams_players')
        .where('team_name', isEqualTo: args['team_name'])
        .where('batting.status', isEqualTo: 'Not Out')
        .where(FieldPath.documentId, whereNotIn: args['batters_names'])
        // .orderBy('player_name', descending: false)
        .get()
        .then((QuerySnapshot qs) {
      notout_batters = qs.docs.length;
      print(notout_batters);
    }).then((value) {
      setState(() {});
    });
  }

// Custom Radio Tile
  Widget customRadioButton(imageUrl, String title, int value, onChangedFunc) {
    return RadioListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      tileColor: Colors.white,
      secondary: CircleAvatar(
        backgroundColor: Colors.black45,
        foregroundImage: NetworkImage(imageUrl),
        child: Icon(
          Icons.person,
          size: 25.0,
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
      value: value,
      groupValue: _selectedRadio,
      onChanged: onChangedFunc,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

// Custom TextField
  Widget customTextField(labelText, keyType, controllerName, onSavedFunc) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
          labelText: labelText,
        ),
        keyboardType: keyType,
        controller: controllerName,
        onSaved: onSavedFunc,
      ),
    );
  }

// Custom List Tile
  Widget customListTile(icon, title, subTitle, onTapFunc) {
    return ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      contentPadding: const EdgeInsets.fromLTRB(15, 3, 10, 3),
      leading: ((title == "Fielder" ||
                      title == "Fielder 1" ||
                      title == "Fielder 2") &&
                  icon != "person" ||
              title == "Out Batsman" && icon != "person")
          ? CircleAvatar(
              foregroundImage: NetworkImage(icon),
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 25.0,
                color: Colors.white,
              ),
            )
          : (subTitle == "New Batsman On" ||
                  subTitle == "Striker End" ||
                  subTitle == "Non Striker End")
              ? icon
              : CircleAvatar(
                  foregroundImage:
                      AssetImage("assets/playerOut_icons/$icon.png"),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
      title: (subTitle == "New Batsman On" ||
              (subTitle == "Striker End" || subTitle == "Non Striker End") &&
                  title == null)
          ? null
          : Text(
              title,
              style: const TextStyle(
                fontSize: 17.5,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
      subtitle: Text(
        subTitle,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTapFunc,
      tileColor:
          ((subTitle == "Striker End" || subTitle == "Non Striker End") &&
                  title == null)
              ? null
              : Colors.grey[100],
    );
  }

  // Custom CheckBox
  Widget customCheckBox(leadingText, isChecked, onChangeFunc) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      activeColor: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      tileColor: Colors.grey[100],
      title: Text(
        leadingText,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      value: isChecked,
      onChanged: onChangeFunc,
    );
  }

  // custom sized box
  Widget customSizedBox = const SizedBox(
    height: 12,
  );

// Wicket Types customized functions
// Bowled
  Widget bowled() {
    return Column(
      children: [
        customListTile("bowled", "Wicket Type", "Bowled", null),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Caught
  Widget caught() {
    return Column(
      children: [
        customListTile("caught", "Wicket Type", "Caught", null),
        customSizedBox,
        customListTile(fielderImage, "Fielder", _selectedFielder, () {
          selectFielder("");
        }),
        customSizedBox,
        customCheckBox('Batsman Crossed?', _isCrossed, (value) {
          setState(() {
            _isCrossed = !_isCrossed;
          });
        }),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Caught Behind
  Widget caughtBehind() {
    return Column(
      children: [
        customListTile("caughtBehind", "Wicket Type", "Caught Behind", null),
        customSizedBox,
        customListTile(fielderImage, "Fielder", _selectedFielder, () {
          selectFielder("");
        }),
        customSizedBox,
        customCheckBox('Batsman Crossed?', _isCrossed, (value) {
          setState(() {
            _isCrossed = !_isCrossed;
          });
        }),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Stumped
  Widget stumped() {
    return Column(
      children: [
        customListTile("stumped", "Wicket Type", "Stumped", null),
        customSizedBox,
        customListTile(fielderImage, "Fielder", _selectedFielder, () {
          selectFielder("");
        }),
        customSizedBox,
        customCheckBox('Wide Ball?', _wideChecked, (value) {
          setState(() {
            _wideChecked = !_wideChecked;
          });
        }),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Run Out
  Widget runOut() {
    return Column(
      children: [
        customListTile("runOut", "Wicket Type", "Run Out", null),
        customSizedBox,
        customListTile(outBatsmanImage, "Out Batsman", _selectedOutBatsman, () {
          outBatsman();
        }),
        customSizedBox,
        customListTile(fielderImage, "Fielder", _selectedFielder, () {
          selectFielder(1);
        }),
        // customSizedBox,
        // customListTile(fielderImage2, "Fielder 2", _selectedFielder2, () {
        //   selectFielder(2);
        // }),
        customSizedBox,
        customCheckBox("Wide Balls?", _wideChecked, (value) {
          setState(() {
            _wideChecked = !_wideChecked;
            if (_wideChecked) {
              _noBallChecked = false;
              _byesChecked = false;
              _legByesChecked = false;
            }
          });
        }),
        customSizedBox,
        customCheckBox("No Ball?", _noBallChecked, (value) {
          setState(() {
            _noBallChecked = !_noBallChecked;
            if (_noBallChecked) {
              _wideChecked = false;
            }
          });
        }),
        customSizedBox,
        customCheckBox("Leg Byes?", _legByesChecked, (value) {
          setState(() {
            _legByesChecked = !_legByesChecked;
            if (_legByesChecked) {
              _wideChecked = false;
              _byesChecked = false;
            }
          });
        }),
        customSizedBox,
        customCheckBox("Byes?", _byesChecked, (value) {
          setState(() {
            _byesChecked = !_byesChecked;
            if (_byesChecked) {
              _wideChecked = false;

              _legByesChecked = false;
            }
          });
        }),
        customSizedBox,
        customTextField("Runs Scored", TextInputType.number, _runsScored,
            (value) {
          _runsScored.text = value!;
        }),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// LBW
  Widget lbw() {
    return Column(
      children: [
        customListTile("lbw", "Wicket Type", "LBW", null),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Hit Wicket
  Widget hitWicket() {
    return Column(
      children: [
        customListTile("hitWicket", "Wicket Type", "Hit Wicket", null),
        customSizedBox,
        customCheckBox('Wide Ball?', _wideChecked, (value) {
          setState(() {
            _wideChecked = !_wideChecked;
          });
        }),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Retired Hurt
  Widget retiredHurt() {
    return Column(
      children: [
        customListTile("retiredHurt", "Wicket Type", "Retired Hurt", null),
        customSizedBox,
        customListTile(outBatsmanImage, "Out Batsman", _selectedOutBatsman, () {
          outBatsman();
        }),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Retired Batsman can bat again and ball will not be counted",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Retired Out
  Widget retiredOut() {
    return Column(
      children: [
        customListTile("retiredOut", "Wicket Type", "Retired Out", null),
        customSizedBox,
        customListTile(outBatsmanImage, "Out Batsman", _selectedOutBatsman, () {
          outBatsman();
        }),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Retired Batsman can't bat again and ball will not be counted",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Retired
  Widget retired() {
    return Column(
      children: [
        customListTile("retired", "Wicket Type", "Retired", null),
        customSizedBox,
        customListTile(outBatsmanImage, "Out Batsman", _selectedOutBatsman, () {
          outBatsman();
        }),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Retired Batsman can bat again and ball will not be counted",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        customSizedBox,
        new_batsman(),
      ],
    );
  }

// Out Batsman BottomSheet
  Future<dynamic> outBatsman() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Wrap(
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Which Batsman is Out?",
                      style: TextStyle(
                        height: 1,
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: current_batters.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          current_batters[index]['player_name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          foregroundImage:
                              NetworkImage(current_batters[index]['imgurl']),
                          child: Icon(
                            Icons.person,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedOutBatsman =
                                current_batters[index]['player_name'];
                            outBatsmanImage = current_batters[index]['imgurl'];
                          });
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

// Fielder BottomSheet for Fielder Fielder 1 and 2
  Future<dynamic> selectFielder(fielderIndex) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Wrap(
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Fielder",
                        style: const TextStyle(
                          height: 2,
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      itemCount: fielders.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (fielders.isNotEmpty) {
                          return customRadioButton(
                              fielders[index]['imgurl'],
                              fielders[index]['player_name'],
                              // "Player $index",
                              index, (newValue) {
                            Navigator.pop(context);
                            setState(() {
                              _selectedRadio = newValue;
                              if (fielderIndex == "") {
                                _selectedFielder =
                                    fielders[index]['player_name'];
                                fielderImage = fielders[index]['imgurl'];
                              }
                              if (fielderIndex == 1) {
                                _selectedFielder =
                                    fielders[index]['player_name'];
                                fielderImage = fielders[index]['imgurl'];
                              }
                              if (fielderIndex == 2) {
                                _selectedFielder =
                                    fielders[index]['player_name'];
                                fielderImage = fielders[index]['imgurl'];
                              }
                            });
                          });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

// New Batsman On BottomSheet
  Future<dynamic> newBatsmanOn() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Wrap(
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "New Batsman On",
                      style: TextStyle(
                        height: 1,
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                customListTile(
                  null,
                  null,
                  "Striker End",
                  () {
                    Navigator.pop(context);
                    setState(() {
                      _newBatsmanOn = "Striker End";
                    });
                  },
                ),
                customListTile(
                  null,
                  null,
                  "Non Striker End",
                  () {
                    Navigator.pop(context);
                    setState(() {
                      _newBatsmanOn = "Non Striker End";
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  Widget new_batsman() {
    var info = player_info_box.read('player');
    return notout_batters == 0
        ? Center()
        : ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            contentPadding: const EdgeInsets.fromLTRB(15, 3, 10, 3),
            leading: CircleAvatar(
              backgroundColor: Colors.black38,
              foregroundImage: NetworkImage(info != null ? info['imgurl'] : ''),
              child: Icon(
                Icons.person,
                size: 25.0,
                color: Colors.white,
              ),
            ),
            title: Text(
              info != null ? info['player_name'] : 'Select New Batsman',
              style: const TextStyle(
                fontSize: 17.5,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              info != null ? info['batting_style'] : '',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(
                () => selectbatsman(),
                arguments: {
                  'match_id': args['match_id'],
                  'team_name': args['team_name'],
                  'batters_names': args['batters_names'],
                },
              );
            },
            tileColor: Colors.grey[100],
          );
  }

  double _calculate_run_rate(tot_runs, total_overs) {
    if (total_overs == 0) {
      return 0.0;
    } else {
      return tot_runs / total_overs;
    }
  }

  double _calculate_economy_rate(tot_runs, total_overs) {
    if (total_overs == 0) {
      return 0.0;
    } else {
      return tot_runs / total_overs;
    }
  }

  double _calculate_strike_rate(batsman_run, total_balls) {
    if (total_balls == 0) {
      return 0.0;
    } else {
      return (batsman_run / total_balls * 100);
    }
  }

  Future<void> out_player_functionality(wicket_type, {isallout = false}) async {
    customdialogcircularprogressindicator('Saving... ');
    var info = player_info_box.read('player');
    var wicket_type_name = '';
    if (wicket_type == 1) {
      wicket_type_name = 'Bowled';
    } else if (wicket_type == 2) {
      wicket_type_name = 'Caught';
    } else if (wicket_type == 4) {
      wicket_type_name = 'Stumped';
    } else if (wicket_type == 5) {
      wicket_type_name = 'Run Out';
    } else if (wicket_type == 6) {
      wicket_type_name = 'LBW';
    } else if (wicket_type == 7) {
      wicket_type_name = 'Hit Wicket';
    } else {
      wicket_type_name = 'Retired';
    }

    await FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('innings')
        .doc(args['inning_no'])
        .get()
        .then((DocumentSnapshot ds) async {
      var out_player_id;
      var striker;
      var striker_name = ds['striker_name'];

      if (_selectedOutBatsman == "Select Out Batsman") {
        if (striker_name == ds['Batter1']['player_name']) {
          out_player_id = ds['Batter1']['player_id'];
          striker = 'Batter1';
        } else {
          out_player_id = ds['Batter2']['player_id'];
          striker = 'Batter2';
        }
      } else {
        if (_selectedOutBatsman == ds['Batter1']['player_name']) {
          out_player_id = ds['Batter1']['player_id'];
          striker = 'Batter1';
        } else {
          out_player_id = ds['Batter2']['player_id'];
          striker = 'Batter2';
        }
      }

      var balls = ds['Total']['balls'];
      var total_overs = ds['Total']['total_overs'];
      var bowler_overs;
      bowler_overs = double.parse(ds['Bowler']['overs'].toString());
      List this_over = ds['over'];

      if (_wideChecked == false && _noBallChecked == false) {
        if (balls == 5) {
          total_overs += 1;
          balls = 0;
        } else {
          balls += 1;
        }
      }
      if (_wideChecked || _noBallChecked) {
        this_over.add("${int.parse(_runsScored.text.toString()) + 1}.w");
      } else {
        this_over.add("${_runsScored.text}.w");
      }

      if (!_wideChecked && !_noBallChecked) {
        if (int.parse(bowler_overs.toString().split('.')[1]) >= 5) {
          var thisovers = int.parse(bowler_overs.toString().split('.')[0]) + 1;
          bowler_overs = double.parse(thisovers.toString() + '.' + '0');
        } else {
          // var thisovers = int.parse(bowler_overs.toString().split('.')[0]) + 1;
          var thisballs = int.parse(bowler_overs.toString().split('.')[1]) + 1;
          bowler_overs = double.parse(bowler_overs.toString().split('.')[0] +
              '.' +
              thisballs.toString());
        }
      } else {
        var thisballs = int.parse(bowler_overs.toString().split('.')[1]);
        bowler_overs = double.parse(
            bowler_overs.toString().split('.')[0] + '.' + thisballs.toString());
      }

      await FirebaseFirestore.instance
          .collection('scoring')
          .doc(currentuserid)
          .collection('my_matches')
          .doc(args['match_id'])
          .collection('teams_players')
          .doc(out_player_id)
          .set({
        'batting': {
          'status': 'Out',
          'total_runs': _noBallChecked
              ? FieldValue.increment(int.parse(_runsScored.text))
              : !_wideChecked && !_byesChecked && !_legByesChecked
                  ? FieldValue.increment(int.parse(_runsScored.text))
                  : FieldValue.increment(0),
          'total_balls': _wideChecked || _noBallChecked
              ? FieldValue.increment(0)
              : FieldValue.increment(1),
          'sixes': _runsScored.text == '6'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'fours': _runsScored.text == '4'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'strike_rate': _calculate_strike_rate(
                  ds[striker.toString()]['total_runs'] +
                      int.parse(_runsScored.text),
                  _wideChecked || _noBallChecked
                      ? ds[striker.toString()]['total_balls']
                      : ds[striker.toString()]['total_balls'] + 1)
              .toInt(),
          'singles': _runsScored.text == '1'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'doubles': _runsScored.text == '2'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'threes': _runsScored.text == '3'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
        },
        'wicket_type': wicket_type_name,
        'fielder': _selectedFielder == "Select Fielder" ? '' : _selectedFielder,
      }, SetOptions(merge: true)).then((value) {});

      FirebaseFirestore.instance
          .collection('scoring')
          .doc(currentuserid)
          .collection('my_matches')
          .doc(args['match_id'])
          .collection('innings')
          .doc(args['inning_no'])
          .set({
        'isended': isallout ? true : false,
        'Total': {
          'total_score': _wideChecked || _noBallChecked
              ? FieldValue.increment(int.parse(_runsScored.text.toString()) + 1)
              : FieldValue.increment(int.parse(_runsScored.text.toString())),
          'total_overs': total_overs,
          'balls': balls,
          'total_wickets': FieldValue.increment(1),
          'run_rate': _calculate_run_rate(
                  (_wideChecked || _noBallChecked
                      ? (ds['Total']['total_score'] +
                          int.parse(_runsScored.text.toString()) +
                          1)
                      : ds['Total']['total_score'] +
                          int.parse(_runsScored.text.toString())),
                  double.parse(total_overs.toString() + '.' + balls.toString()))
              .toPrecision(2),
        },
        'Extra': {
          // 'total_extra_runs': isextraruns?  FieldValue.increment(int.parse(txt)) : FieldValue.increment(0),
          'total_extras':
              _wideChecked || _noBallChecked || _byesChecked || _legByesChecked
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
          'wide':
              _wideChecked ? FieldValue.increment(1) : FieldValue.increment(0),
          'no_ball': _noBallChecked
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'byes':
              _byesChecked ? FieldValue.increment(1) : FieldValue.increment(0),
          'leg_byes': _legByesChecked
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
        },
        striker.toString(): player_info_box.read('isselected')
            ? {
                'player_id': player_info_box.read('player')['player_id'],
                'player_name': player_info_box.read('player')['player_name'],
                'team_name': args['team_name'].toString(),
                'total_runs': 0,
                'total_balls': 0,
                'fours': 0,
                'sixes': 0,
                'strike_rate': 0,
              }
            : {
                'player_id': '',
                'player_name': '',
                'team_name': '',
                'total_runs': 0,
                'total_balls': 0,
                'fours': 0,
                'sixes': 0,
                'strike_rate': 0,
              },
        'striker_name': player_info_box.read('isselected')
            ? _isCrossed
                ? ds['striker_name']
                : player_info_box.read('player')['player_name']
            : ds['striker_name'],
        'over': this_over,
        'oversdata': {
          balls == 0 ? (total_overs - 1).toString() : total_overs.toString(): {
            'over_no': balls == 0 ? total_overs : total_overs + 1,
            'every_ball': this_over,
            'Batter1_name': ds['Batter1']['player_name'],
            'Batter2_name': ds['Batter2']['player_name'],
            'Bowler_name': ds['Bowler']['player_name'],
            'total_runs': FieldValue.increment(_wideChecked || _noBallChecked
                ? (int.parse(_runsScored.text) + 1)
                : int.parse(_runsScored.text)),
          },
        },
        'Bowler': {
          'wickets': wicket_type == 5
              ? FieldValue.increment(0)
              : FieldValue.increment(1),
          'runs': FieldValue.increment(_wideChecked || _noBallChecked
              ? (int.parse(_runsScored.text) + 1)
              : int.parse(_runsScored.text)),
          'overs': bowler_overs,
          // 'maiden': ismaiden ? FieldValue.increment(1) : FieldValue.increment(0),
          'economy_rate': _calculate_economy_rate(
                  ds['Bowler']['runs'] +
                      (_wideChecked || _noBallChecked
                          ? (int.parse(_runsScored.text) + 1)
                          : int.parse(_runsScored.text)),
                  bowler_overs)
              .toPrecision(1),
        },
      }, SetOptions(merge: true)).then((value) {});
      await FirebaseFirestore.instance
          .collection('scoring')
          .doc(currentuserid)
          .collection('my_matches')
          .doc(args['match_id'])
          .collection('teams_players')
          .doc(ds['Bowler']['player_id'])
          .set({
        'bowling': {
          'wickets': wicket_type == 5
              ? FieldValue.increment(0)
              : FieldValue.increment(1),
          'runs': FieldValue.increment(_wideChecked || _noBallChecked
              ? (int.parse(_runsScored.text) + 1)
              : int.parse(_runsScored.text)),
          'dot_balls': _wideChecked || _noBallChecked
              ? (int.parse(_runsScored.text) + 1)
              : int.parse(_runsScored.text) == 0
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
          'overs': bowler_overs,
          // 'maiden':
          // ismaiden ? FieldValue.increment(1) : FieldValue.increment(0),
          'economy_rate': _calculate_economy_rate(
                  ds['Bowler']['runs'] +
                      (_wideChecked || _noBallChecked
                          ? (int.parse(_runsScored.text) + 1)
                          : int.parse(_runsScored.text)),
                  bowler_overs)
              .toPrecision(1),
        }
      }, SetOptions(merge: true)).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // Get.to(() => MatchCentre(),
        // arguments: {

        // }
        // );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Wicket",
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF424242),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Container(
          height: heightSize,
          width: widthSize,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    (widget.wicketType == 1)
                        ? bowled()
                        : (widget.wicketType == 2)
                            ? caught()
                            // : (widget.wicketType == 3)
                            //     ? caughtBehind()
                            : (widget.wicketType == 4)
                                ? stumped()
                                : (widget.wicketType == 5)
                                    ? runOut()
                                    : (widget.wicketType == 6)
                                        ? lbw()
                                        : (widget.wicketType == 7)
                                            ? hitWicket()
                                            // : (widget.wicketType == 8)
                                            //     ? retiredHurt()
                                            //     : (widget.wicketType == 9)
                                            //         ? retiredOut()
                                            : retired(),
                  ],
                ),
              ),
              Container(
                width: widthSize,
                height: heightSize * 8.5 / 100,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Back"),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        onPressed: () {
                          if (player_info_box.read('isselected') ||
                              notout_batters == 0) {
                            if (widget.wicketType == 1) {
                              out_player_functionality(1,
                                  isallout: notout_batters == 0 ? true : false);
                            } else if (widget.wicketType == 2) {
                              if (_selectedFielder == "Select Fielder") {
                                customtoast('Select Fielder');
                              } else {
                                out_player_functionality(2,
                                    isallout:
                                        notout_batters == 0 ? true : false);
                              }
                            } else if (widget.wicketType == 4) {
                              if (_selectedFielder == "Select Fielder") {
                                customtoast('Select Fielder');
                              } else {
                                out_player_functionality(4,
                                    isallout:
                                        notout_batters == 0 ? true : false);
                              }
                            } else if (widget.wicketType == 5) {
                              if (_selectedFielder == "Select Fielder") {
                                customtoast('Select Fielder');
                              } else if (_selectedOutBatsman ==
                                  "Select Out Batsman") {
                                customtoast('Select Out Batsman');
                              } else {
                                out_player_functionality(5,
                                    isallout:
                                        notout_batters == 0 ? true : false);
                              }
                            } else if (widget.wicketType == 6) {
                              out_player_functionality(6,
                                  isallout: notout_batters == 0 ? true : false);
                            } else if (widget.wicketType == 7) {
                              out_player_functionality(7,
                                  isallout: notout_batters == 0 ? true : false);
                            } else if (widget.wicketType == 10) {
                              if (_selectedOutBatsman == "Select Out Batsman") {
                                customtoast('Select Out Batsman');
                              } else {
                                out_player_functionality(10,
                                    isallout:
                                        notout_batters == 0 ? true : false);
                              }
                            }
                          } else {
                            customtoast('select new batsman');
                          }
                        },
                        child: const Text("Done"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
