import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/my%20matches/my%20matches.dart';
import '/features/my%20matches/select_openers_player.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../res/components/customtaost.dart';

class select_openers extends StatefulWidget {
  const select_openers({Key? key}) : super(key: key);

  @override
  _select_openersState createState() => _select_openersState();
}

class _select_openersState extends State<select_openers> {
  String firstTeamName = "First Team Name";
  String secondTeamName = "Second Team Name";
  var striker_name = 'Striker';
  var striker_pic = '';
  var striker_role = 'Tap to select';
  var nonstriker_name = 'Non Striker';
  var nonstriker_pic = '';
  var nonstriker_role = 'Tap to select';
  var bowler_name = 'Opening Bowler';
  var bowler_pic = '';
  var bowler_role = 'Tap to select';
  var currentuserid = '';
  var currentusername = '';
  bool iscreating = false;
  final match_info_box = GetStorage('Match_Info');
  var args = Get.arguments;
  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
      });
    }
    teaminfolistner();
    _fetchusername();
    args['inning_no'] == 'inning1'
        ? setState(() {
            var tosswinnerteam =
                match_info_box.read('toss')['toss_winner_team'];
            var team1 = match_info_box.read('team1info')['team_name'];
            var team2 = match_info_box.read('team2info')['team_name'];
            var toss_decision = match_info_box.read('toss')['toss_decision'];
            if (tosswinnerteam == team1) {
              if (toss_decision == 'Batting') {
                firstTeamName = team1;
                secondTeamName = team2;
              } else {
                firstTeamName = team2;
                secondTeamName = team1;
              }
            } else {
              if (toss_decision == 'Batting') {
                firstTeamName = team2;
                secondTeamName = team1;
              } else {
                firstTeamName = team1;
                secondTeamName = team2;
              }
            }
          })
        :
        //  setState(() {
        FirebaseFirestore.instance
            .collection('scoring')
            .doc(currentuserid)
            .collection('my_matches')
            .doc(args['match_id'])
            .collection('innings')
            .doc('inning1')
            .get()
            .then((DocumentSnapshot ds) {
            firstTeamName = ds['Bowler']['team_name'];
            secondTeamName = ds['batting_team'];
            setState(() {});
          });
    //  });
  }

  Future<void> _fetchusername() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentuserid)
        .get()
        .then((DocumentSnapshot ds) {
      currentusername = ds['full_name'];
    });
  }

  Future _player_name(player_id, team_name, var_name) async {
    await FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(team_name)
        .doc(player_id)
        .get()
        .then((DocumentSnapshot ds) {
      var_name = ds['player_name'];
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> teaminfolistner() async {
    match_info_box.listen(() {
      setState(() {
        if (match_info_box.read('openers' + firstTeamName + 'Striker') !=
            null) {
          striker_name = match_info_box
              .read('openers' + firstTeamName + 'Striker')['player_name'];
          striker_pic = match_info_box
              .read('openers' + firstTeamName + 'Striker')['imgurl'];
          striker_role = match_info_box
              .read('openers' + firstTeamName + 'Striker')['player_role'];
        }
        if (match_info_box.read('openers' + firstTeamName + 'Non Striker') !=
            null) {
          nonstriker_name = match_info_box
              .read('openers' + firstTeamName + 'Non Striker')['player_name'];
          nonstriker_pic = match_info_box
              .read('openers' + firstTeamName + 'Non Striker')['imgurl'];
          nonstriker_role = match_info_box
              .read('openers' + firstTeamName + 'Non Striker')['player_role'];
        }
        if (match_info_box.read('openers' + secondTeamName + 'Bowler') !=
            null) {
          bowler_name = match_info_box
              .read('openers' + secondTeamName + 'Bowler')['player_name'];
          bowler_pic = match_info_box
              .read('openers' + secondTeamName + 'Bowler')['imgurl'];
          bowler_role = match_info_box
              .read('openers' + secondTeamName + 'Bowler')['player_role'];
        }
      });
    });
  }

  Future<void> savetodatabase() async {
    var inning = args['inning_no'] == 'inning1' ? true : false;
    var team1info = match_info_box.read('team1info');
    var team2info = match_info_box.read('team2info');
    var team1players_names =
        inning ? match_info_box.read(team1info['team_name'] + 'players') : [];
    var team2players_names =
        inning ? match_info_box.read(team2info['team_name'] + 'players') : [];
    var team1players_ids = {};
    var team2players_ids = {};
    for (var player_name in team1players_names) {
      inning
          ? team1players_ids[player_name.toString()] = match_info_box.read(
              team1info['team_name'] + player_name.toString())['player_id']
          : {};
    }
    for (var player_name in team2players_names) {
      inning
          ? team2players_ids[player_name.toString()] = match_info_box.read(
              team2info['team_name'] + player_name.toString())['player_id']
          : {};
    }

    var match_details = inning ? match_info_box.read('match_details') : {};
    // var match_settings = match_info_box.read('match_settings');
    var toss = inning ? match_info_box.read('toss') : {};
    DocumentReference docref = await FirebaseFirestore.instance
        .collection('matches')
        .doc(currentuserid)
        .collection('mymatches')
        .doc();

    args['inning_no'] == 'inning2'
        ? null
        : await docref.set({
            'islive': true,
            'batting_team': firstTeamName,
            // 'inning_no': 'inning1',
            'match_name': (team1info['team_name'].toString() +
                ' VS ' +
                team2info['team_name'].toString()),
            'team_details': {
              'team1_name': team1info['team_name'].toString(),
              'team1_imgurl': team1info['imgurl'].toString(),
              'team1_id': team1info['team_id'],
              'team2_name': team2info['team_name'].toString(),
              'team2_imgurl': team2info['imgurl'].toString(),
              'team2_id': team2info['team_id'],
              'team1_players_ids': team1players_ids,
              'team2_players_ids': team2players_ids,
            },
            'match_details': {
              'ground_name': match_details['ground_name'],
              'overs': match_details['overs'],
              'ball_type': match_details['ball_type'],
              'date': match_details['date'],
              'time': match_details['time'],
            },
            // 'match_settings': {
            //   'wide': match_settings['wide'],
            //   're_ball_for_wide': match_settings['re_ball_for_wide'],
            //   'wide_runs': match_settings['wide_runs'],
            //   'no_ball': match_settings['no_ball'],
            //   're_ball_for_no_ball': match_settings['re_ball_for_no_ball'],
            //   'no_ball_runs': match_settings['no_ball_runs'],
            // },
            'toss': {
              'toss_winner_team': toss['toss_winner_team'],
              'toss_decision': toss['toss_decision'],
            },
            'openers': {
              'Striker': match_info_box
                  .read('openers' + firstTeamName + 'Striker')['player_id'],
              'Non Striker': match_info_box
                  .read('openers' + firstTeamName + 'Non Striker')['player_id'],
              'Bowler': match_info_box
                  .read('openers' + secondTeamName + 'Bowler')['player_id'],
            },
          }).then((value) {
            print('match added... ' + docref.id);
          });
    args['inning_no'] == 'inning2'
        ? null
        : FirebaseFirestore.instance
            .collection('livematches')
            .doc(docref.id.toString())
            .set({
            'match_id': docref.id,
            'user_id': currentuserid,
            'user_name': currentusername,
          }).then((value) async {});
    var striker_name = '';
    await FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(firstTeamName)
        .doc(match_info_box
            .read('openers' + firstTeamName + 'Striker')['player_id'])
        .get()
        .then((DocumentSnapshot ds) {
      striker_name = ds['player_name'];
    });
    var non_striker_name = '';
    await FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(firstTeamName)
        .doc(match_info_box
            .read('openers' + firstTeamName + 'Non Striker')['player_id'])
        .get()
        .then((DocumentSnapshot ds) {
      non_striker_name = ds['player_name'];
    });
    var bowler_name = '';
    await FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(secondTeamName)
        .doc(match_info_box
            .read('openers' + secondTeamName + 'Bowler')['player_id'])
        .get()
        .then((DocumentSnapshot ds) {
      bowler_name = ds['player_name'];
    });
    var total_overs;
    var target = 0;
    args['inning_no'] == 'inning2'
        ? await FirebaseFirestore.instance
            .collection('scoring')
            .doc(currentuserid)
            .collection('my_matches')
            .doc(args['match_id'])
            .collection('innings')
            .doc('inning1')
            .get()
            .then((DocumentSnapshot ds) {
            total_overs = ds['total_inning_overs'];
            target = ds['Total']['total_score'] + 1;
          })
        : total_overs = match_details['overs'];

    FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['inning_no'] == 'inning1' ? docref.id : args['match_id'])
        .collection('innings')
        .doc(args['inning_no'])
        .set({
      'isended': false,
      'target': target,
      'total_inning_overs': total_overs,
      'striker_name': striker_name,
      'batting_team': firstTeamName,
      'Total': {
        'total_overs': 0,
        'balls': 0,
        // 'total_overs_selected': match_details['overs'],
        'total_score': 0,
        'total_wickets': 0,
        // 'overs_finished': 0.0,
        'run_rate': 0.0,
      },
      'Batter1': {
        'player_id': match_info_box
            .read('openers' + firstTeamName + 'Striker')['player_id'],
        'player_name': striker_name,
        'team_name': firstTeamName,
        'total_runs': 0,
        'total_balls': 0,
        'fours': 0,
        'sixes': 0,
        'strike_rate': 0,
      },
      'Batter2': {
        'player_id': match_info_box
            .read('openers' + firstTeamName + 'Non Striker')['player_id'],
        'player_name': non_striker_name,
        'team_name': firstTeamName,
        'total_runs': 0,
        'total_balls': 0,
        'fours': 0,
        'sixes': 0,
        'strike_rate': 0,
      },
      'Extra': {
        // 'total_extra_runs': isextraruns?  FieldValue.increment(int.parse(txt)) : FieldValue.increment(0),
        'total_extras': 0,
        'wide': 0,
        'no_ball': 0,
        'byes': 0,
        'leg_byes': 0,
      },
      'Bowler': {
        'player_id': match_info_box
            .read('openers' + secondTeamName + 'Bowler')['player_id'],
        'player_name': bowler_name,
        'team_name': secondTeamName,
        'overs': 0.0,
        'maiden': 0,
        'runs': 0,
        'wickets': 0,
        'economy_rate': 0.0,
      },
      'over': [],
      'oversdata': {},
    }, SetOptions(merge: true)).then((value) {});
    args['inning_no'] == 'inning1'
        ? team1players_ids.forEach((key, value) {
            FirebaseFirestore.instance
                .collection('scoring')
                .doc(currentuserid)
                .collection('my_matches')
                .doc(docref.id)
                .collection('teams_players')
                .doc(value)
                .set({
              'team_name': team1info['team_name'].toString(),
              'player_name': key,
              'batting': {
                'status': 'Not Out',
                'total_runs': 0,
                'total_balls': 0,
                'fours': 0,
                'sixes': 0,
                'strike_rate': 0,
              },
              'bowling': {
                'wickets': 0,
                'overs': 0.0,
                'maiden': 0,
                'runs': 0,
                'economy_rate': 0.0,
              }
            }, SetOptions(merge: true));
          })
        : null;
    args['inning_no'] == 'inning1'
        ? team2players_ids.forEach((key, value) {
            FirebaseFirestore.instance
                .collection('scoring')
                .doc(currentuserid)
                .collection('my_matches')
                .doc(docref.id)
                .collection('teams_players')
                .doc(value)
                .set({
              'team_name': team2info['team_name'].toString(),
              'player_name': key,
              'batting': {
                'status': 'Not Out',
                'total_runs': 0,
                'total_balls': 0,
                'fours': 0,
                'sixes': 0,
                'strike_rate': 0,
              },
              'bowling': {
                'wickets': 0,
                'overs': 0.0,
                'maiden': 0,
                'runs': 0,
                'economy_rate': 0.0,
              }
            }, SetOptions(merge: true)).then((value) {
              //     match_info_box.erase();
              // Get.to(() => Matches(), arguments: {
              //   'inning_no' : args['inning_no'],
              // });
              // customtoast('Match Created');
              // setState(() {
              //   iscreating = false;
              // });
            });
          })
        : null;
  }

  // Custom list Tile
  Widget customListTile(imageUrl, title, onTapfunc, _subtitle) {
    return ListTile(
      dense: true,
      onTap: onTapfunc,
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        foregroundImage: NetworkImage(imageUrl),
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 25.0,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        _subtitle,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 17,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Select Players",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BATSMAN ($firstTeamName)",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const Divider(
                        height: 25,
                        thickness: 1.0,
                      ),
                      customListTile(striker_pic, striker_name, () {
                        Get.to(() => playersforopeners(), arguments: {
                          'match_id': args['match_id'],
                          'inning_no': args['inning_no'],
                          'team_name': firstTeamName,
                          'info': 'Striker'
                        });
                      }, striker_role),
                      const Divider(
                        thickness: 1.0,
                      ),
                      customListTile(nonstriker_pic, nonstriker_name, () {
                        Get.to(() => playersforopeners(), arguments: {
                          'match_id': args['match_id'],
                          'inning_no': args['inning_no'],
                          'team_name': firstTeamName,
                          'info': 'Non Striker',
                        });
                      }, nonstriker_role),
                    ],
                  ),
                ),
                SizedBox(height: heightSize * 2 / 100),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BOWLER ($secondTeamName)",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const Divider(
                        height: 25,
                        thickness: 1.0,
                      ),
                      customListTile(bowler_pic, bowler_name,
                          // strikerImage,
                          // "Opening Bowler",
                          () {
                        Get.to(() => playersforopeners(), arguments: {
                          'match_id': args['match_id'],
                          'inning_no': args['inning_no'],
                          'team_name': secondTeamName,
                          'info': 'Bowler',
                        });
                      }, bowler_role),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: widthSize,
              height: heightSize * 8.5 / 100,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(22, 6, 22, 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ),
                onPressed: iscreating
                    ? null
                    : () {
                        if (striker_name != 'Striker') {
                          if (nonstriker_name != 'NonStriker') {
                            if (bowler_name != 'Opening Bowler') {
                              setState(() {
                                iscreating = true;
                              });
                              savetodatabase().then((value) {
                                args['inning_no'] == 'inning1'
                                    ? setState(() {
                                        match_info_box.erase();
                                        Get.to(() => Matches());
                                        customtoast('Match Created');
                                        iscreating = false;
                                      })
                                    : setState(() {
                                        iscreating = false;
                                        Get.to(() => Matches());
                                        args['inning_no'] == 'inning1'
                                            ? customtoast('Match Created')
                                            : customtoast('Inning 2 created');
                                      });
                              });
                            } else {
                              customtoast('Select Bowler');
                            }
                          } else {
                            customtoast('Select Non-Striker');
                          }
                        } else {
                          customtoast('Select Striker');
                        }
                      },
                child: iscreating
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Start Match",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ))
        ],
      ),
    );
  }
}
