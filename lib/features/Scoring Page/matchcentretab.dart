// import '/Scoring%20Page/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/Scoring%20Page/player_out.dart';
import '/features/Scoring%20Page/player_selection.dart';
import '/features/my%20matches/selectopeners.dart';

import '/res/components/customdialog.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchCentre extends StatefulWidget {
  const MatchCentre({Key? key}) : super(key: key);

  @override
  _MatchCentreState createState() => _MatchCentreState();
}

class _MatchCentreState extends State<MatchCentre> {
  // ValueNotifier<int> _radio = ValueNotifier(0);
  ValueNotifier<bool> isextra = ValueNotifier(false);
  // ValueNotifier<bool> byes = ValueNotifier(false);
  var title_value = '';
  List<Widget> row1 = [];
  List<Widget> row2 = [];
  // List<bool> isSelected = [false, false];
  // List<bool> isSelectedbyes = [false, false];
  var args = Get.arguments;
  var currentuserid = '';
  var batter1_name = '';
  var batter2_name = '';
  var striker_name = '';
  var bowler_name = '';
  var thisover_balls = 0;
  var this_overs_data = [];
  var tot_overs = 0;
  var tot_runs = 0;
  DocumentReference? _match;
  @override
  void initState() {
    super.initState();
    var cuser = FirebaseAuth.instance.currentUser;
    if (cuser != null) {
      setState(() {
        currentuserid = cuser.uid;
        _match = FirebaseFirestore.instance
            .collection('scoring')
            .doc(currentuserid)
            .collection('my_matches')
            .doc(args['match_id']);
      });
    }
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

  double _win_percentage_calculator(won, played) {
    if (played == 0) {
      return 0.0;
    } else {
      return (won / played * 100);
    }
  }

  bool _decide_strike_change(runs_on_this_ball, [isover = false]) {
    if (runs_on_this_ball == 1 ||
        runs_on_this_ball == 3 ||
        runs_on_this_ball == 5 ||
        isover == true) {
      return true;
    } else {
      return false;
    }
  }

  Widget _customtext(txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        txt,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget customverticaldivider() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: VerticalDivider(
        indent: 0,
        endIndent: 0,
        thickness: 0.0,
        color: Colors.white,
      ),
    );
  }

  Widget custommaterialbutton(btn_txt, on_pressed) {
    return Expanded(
      child: MaterialButton(
        onPressed: on_pressed,
        child: Text(
          btn_txt,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget customextrabutton(btn_txt, on_pressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: on_pressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          btn_txt,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget customcontainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          leading: IconButton(
            onPressed: () {
              isextra.value = false;
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 25.0,
            ),
          ),
          title: Text(
            title_value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row2,
        ),
      ],
    );
  }

  Future scoring_func(txt, overs, balls, runs,
      {iswide = false,
      isno_ball = false,
      isbye = false,
      islegbye = false}) async {
    customdialogcircularprogressindicator('Saving...'); //todo
    var ismaiden = false;
    var bowler_overs;
    var bowler_runs = 0;
    var striker = '';
    var striker_id = '';
    var bowler_id = '';
    var bowler_team = '';
    var batsman_runs = 0;
    // var this_over_runs = 0;
    var batsman_balls = 0;
    var isextraruns = false;
    var isended = false;
    var total_inning_overs;
    await _match
        ?.collection('innings')
        .doc(args['inning_no'])
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        bowler_overs = double.parse(ds['Bowler']['overs'].toString());
        bowler_runs = ds['Bowler']['runs'];
        this_overs_data = ds['over'];
        // this_over_runs = ds['oversdata'][overs-1]['total_runs'] != null ? ds['oversdata'][overs-1]['total_runs'] : 0;
        batter1_name = ds['Batter1']['player_name'];
        batter2_name = ds['Batter2']['player_name'];
        bowler_name = ds['Bowler']['player_name'];
        striker_name = ds['striker_name'];
        // isended = ds['isended'];
        // total_inning_overs = ds['total_inning_overs'];
// data['isended'] || data['total_inning_overs'] == data['Total']['total_overs'].toString()

        if (_decide_strike_change(int.parse(txt)) || balls == 5) {
          if (striker_name == batter1_name) {
            striker_name = batter2_name;
            striker = 'Batter1';
          } else {
            striker_name = batter1_name;
            striker = 'Batter2';
          }
        } else {
          if (striker_name == batter1_name) {
            striker_name = batter1_name;
            striker = 'Batter1';
          } else {
            striker_name = batter2_name;
            striker = 'Batter2';
          }
        }

        //  if (balls == 0) {
        //   if (striker_name == batter1_name) {
        //     striker = 'Batter2';
        //   } else {
        //     striker = 'Batter1';
        //   }
        // } else {
        //   if (striker_name == batter1_name) {
        //     striker = 'Batter1';
        //   } else {
        //     striker = 'Batter2';
        //   }
        // }

        if (iswide || isno_ball) {
          isextraruns = true;
        }
        striker_id = ds[striker.toString()]['player_id'].toString();
        bowler_id = ds['Bowler']['player_id'].toString();
        bowler_team = ds['Bowler']['team_name'].toString();
        if (striker_name == batter1_name) {
          if (!isextraruns) {
            if (!isbye && !islegbye) {
              batsman_runs = ds['Batter1']['total_runs'] + int.parse(txt);
              batsman_balls = ds['Batter1']['total_balls'] + 1;
            } else {
              batsman_runs = ds['Batter1']['total_runs'];
              batsman_balls = ds['Batter1']['total_balls'] + 1;
            }
          } else {
            if (isno_ball) {
              batsman_runs = ds['Batter1']['total_runs'] + int.parse(txt);
              batsman_balls = ds['Batter2']['total_balls'];
            } else {
              batsman_runs = ds['Batter1']['total_runs'];
              batsman_balls = ds['Batter1']['total_balls'];
            }
          }
        } else {
          if (!isextraruns) {
            if (!isbye && !islegbye) {
              batsman_runs = ds['Batter2']['total_runs'] + int.parse(txt);
              batsman_balls = ds['Batter2']['total_balls'] + 1;
            } else {
              batsman_runs = ds['Batter2']['total_runs'];
              batsman_balls = ds['Batter2']['total_balls'] + 1;
            }
          } else {
            if (isno_ball) {
              batsman_runs = ds['Batter2']['total_runs'] + int.parse(txt);
              batsman_balls = ds['Batter2']['total_balls'];
            } else {
              batsman_runs = ds['Batter2']['total_runs'];
              batsman_balls = ds['Batter2']['total_balls'];
            }
          }
        }

        if (!isextraruns) {
          if (int.parse(bowler_overs.toString().split('.')[1]) >= 5) {
            var thisovers =
                int.parse(bowler_overs.toString().split('.')[0]) + 1;
            bowler_overs = double.parse(thisovers.toString() + '.' + '0');
          } else {
            // var thisovers = int.parse(bowler_overs.toString().split('.')[0]) + 1;
            var thisballs =
                int.parse(bowler_overs.toString().split('.')[1]) + 1;
            bowler_overs = double.parse(bowler_overs.toString().split('.')[0] +
                '.' +
                thisballs.toString());
          }
        } else {
          var thisballs = int.parse(bowler_overs.toString().split('.')[1]);
          bowler_overs = double.parse(bowler_overs.toString().split('.')[0] +
              '.' +
              thisballs.toString());
        }
      }
    });

    // if (balls == 0) {
    //   // if(!isextraruns){
    //   //    if (this_overs_data.every((element) {
    //   //   return element.toString().split('.')[0] == '0' &&
    //   //       element.toString().split('.')[1] == '';
    //   // })) {
    //   //   ismaiden = true;
    //   // }
    //   // this_overs_data.clear();
    //   // }
    // }

    if (balls == 5) {
      if (!isextraruns) {
        overs += 1;
        balls = 0;
      }
      // this_overs_data.add(int.parse(txt).toString() + '.' + '');
    } else {
      if (!isextraruns) {
        balls += 1;
      }
    }

    if (iswide) {
      this_overs_data.add(txt + '.' + 'wd');
    } else if (isno_ball) {
      this_overs_data.add(txt + '.' + 'nb');
    } else if (isbye) {
      this_overs_data.add(txt + '.' + 'b');
    } else if (islegbye) {
      this_overs_data.add(txt + '.' + 'lb');
    } else {
      this_overs_data.add(int.parse(txt).toString() + '.' + '');
    }

    _match!.collection('innings').doc(args['inning_no']).set({
      'striker_name': striker_name,
      'Total': {
        'total_score': FieldValue.increment(int.parse(txt)),
        'total_overs': overs,
        'balls': balls,
        'run_rate': _calculate_run_rate(runs + int.parse(txt),
                double.parse(overs.toString() + '.' + balls.toString()))
            .toPrecision(2),
      },
      'Extra': {
        // 'total_extra_runs': isextraruns?  FieldValue.increment(int.parse(txt)) : FieldValue.increment(0),
        'total_extras': isextraruns
            ? FieldValue.increment(1)
            : isbye
                ? FieldValue.increment(1)
                : islegbye
                    ? FieldValue.increment(1)
                    : FieldValue.increment(0),
        'wide': iswide ? FieldValue.increment(1) : FieldValue.increment(0),
        'no_ball':
            isno_ball ? FieldValue.increment(1) : FieldValue.increment(0),
        'byes': isbye ? FieldValue.increment(1) : FieldValue.increment(0),
        'leg_byes':
            islegbye ? FieldValue.increment(1) : FieldValue.increment(0),
      },
      'over': this_overs_data,
      'oversdata': {
        balls == 0 ? (overs - 1).toString() : overs.toString(): {
          'over_no': balls == 0 ? overs : overs + 1,
          'every_ball': this_overs_data,
          'Batter1_name': batter1_name,
          'Batter2_name': batter2_name,
          'Bowler_name': bowler_name,
          'total_runs': FieldValue.increment(int.parse(txt)),
        },
      },
      'Bowler': {
        'runs': FieldValue.increment(int.parse(txt)),
        'overs': bowler_overs,
        // 'maiden': ismaiden ? FieldValue.increment(1) : FieldValue.increment(0),
        'economy_rate':
            _calculate_economy_rate(bowler_runs + int.parse(txt), bowler_overs)
                .toPrecision(1),
      },
      striker.toString(): {
        'total_runs': isextraruns
            ? isno_ball
                ? FieldValue.increment((int.parse(txt) - 1))
                : FieldValue.increment(0)
            : isbye
                ? FieldValue.increment(0)
                : islegbye
                    ? FieldValue.increment(0)
                    : FieldValue.increment(int.parse(txt)),
        'total_balls':
            isextraruns ? FieldValue.increment(0) : FieldValue.increment(1),
        'sixes': isno_ball
            ? (int.parse(txt) - 1) == 6
                ? FieldValue.increment(1)
                : FieldValue.increment(0)
            : int.parse(txt) == 6
                ? FieldValue.increment(1)
                : FieldValue.increment(0),
        'fours': isno_ball
            ? (int.parse(txt) - 1) == 4
                ? FieldValue.increment(1)
                : FieldValue.increment(0)
            : int.parse(txt) == 4
                ? FieldValue.increment(1)
                : FieldValue.increment(0),
        'strike_rate':
            _calculate_strike_rate(batsman_runs, batsman_balls).toInt(),
      },
    }, SetOptions(merge: true)).then((value) {
      _match!.collection('teams_players').doc(striker_id).set({
        'batting': {
          'total_runs': isextraruns
              ? isno_ball
                  ? FieldValue.increment((int.parse(txt) - 1))
                  : FieldValue.increment(0)
              : isbye
                  ? FieldValue.increment(0)
                  : islegbye
                      ? FieldValue.increment(0)
                      : FieldValue.increment(int.parse(txt)),
          'total_balls':
              isextraruns ? FieldValue.increment(0) : FieldValue.increment(1),
          'sixes': isno_ball
              ? (int.parse(txt) - 1) == 6
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0)
              : int.parse(txt) == 6
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
          'fours': isno_ball
              ? (int.parse(txt) - 1) == 4
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0)
              : int.parse(txt) == 4
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
          'strike_rate':
              _calculate_strike_rate(batsman_runs, batsman_balls).toInt(),
          'singles': isno_ball
              ? (int.parse(txt) - 1) == 1
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0)
              : int.parse(txt) == 1
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
          'doubles': isno_ball
              ? (int.parse(txt) - 1) == 2
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0)
              : int.parse(txt) == 2
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
          'threes': isno_ball
              ? (int.parse(txt) - 1) == 3
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0)
              : int.parse(txt) == 3
                  ? FieldValue.increment(1)
                  : FieldValue.increment(0),
        },
      }, SetOptions(merge: true)).then((value) {
        _match!.collection('teams_players').doc(bowler_id).set({
          'bowling': {
            'runs': FieldValue.increment(int.parse(txt)),
            'dot_balls': int.parse(txt) == 0
                ? FieldValue.increment(1)
                : FieldValue.increment(0),
            'overs': bowler_overs,
            // 'maiden':
            // ismaiden ? FieldValue.increment(1) : FieldValue.increment(0),
            'economy_rate': _calculate_economy_rate(bowler_runs, bowler_overs)
                .toPrecision(1),
          }
        }, SetOptions(merge: true)).then((value) async {
          ismaiden = false;
          isextra.value = false;
          Navigator.pop(context);
          if (balls == 0 && !isextraruns) {
            await _match
                ?.collection('innings')
                .doc(args['inning_no'])
                .get()
                .then((DocumentSnapshot ds) {
              isended = ds['isended'];
              total_inning_overs = ds['total_inning_overs'];
            });
            isended || overs.toString() == total_inning_overs.toString()
                ? null
                : Get.to(
                    () => selectplayer(),
                    arguments: {
                      'match_id': args['match_id'],
                      'team_name': bowler_team,
                      'appbartxt': 'Select Bowler',
                      'current_player_id': bowler_id,
                      'inning': args['inning_no'],
                    },
                  );
          }
        }).catchError((e) {
          Navigator.pop(context);
          Get.rawSnackbar(
            message: "Unable to add data. $e",
            backgroundColor: Colors.black,
          );
        });
      });
    });
  }

  Widget custombutton(txt, overs, runs, balls) {
    return Expanded(
      child: MaterialButton(
        onPressed: () {
          scoring_func(txt, overs, balls, runs);
        },
        child: Text(
          txt,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _customcircleavatar(_txt, extra) {
    Color? circlecolor;
    if (_txt == '4') {
      circlecolor = Colors.green;
    } else if (_txt == '6') {
      circlecolor = Colors.purple;
    } else if (_txt.toString().toLowerCase() == 'w') {
      circlecolor = Colors.red;
    } else {
      circlecolor = Colors.blueGrey[800];
    }
    if (extra.toString() != '') {
      circlecolor = Colors.yellow[700];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 15.0,
              backgroundColor: circlecolor,
              child: Text(
                _txt,
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            extra.toString(),
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> result_func() async {
    await FirebaseFirestore.instance
        .collection('scoring')
        .doc(args['user_id'])
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('innings')
        .doc('inning2')
        .get()
        .then((DocumentSnapshot ds) async {
      var match_result;
      var winner_team;
      var winner_team_id;
      var loser_team;
      var loser_team_id;
      var total_players;
      var winner_team_won_matches;
      var loser_team_won_matches;
      var winner_team_played_matches;
      var loser_team_played_matches;
      await _match!
          .collection('teams_players')
          .where('team_name', isEqualTo: ds['batting_team'])
          .get()
          .then((QuerySnapshot qs) {
        total_players = qs.docs.length;
      }).then((value) async {
        if (ds['target'] <= ds['Total']['total_score']) {
          match_result =
              "${ds['batting_team']} won the match by ${total_players - ds['Total']['total_wickets'] - 1} wicket(s)";
          winner_team = ds['batting_team'];
          loser_team = ds['Bowler']['team_name'];
        } else if (ds['target'] - 1 == ds['Total']['total_score']) {
          match_result = 'Match Drawn';
          winner_team = '';
          loser_team = '';
        } else {
          match_result =
              "${ds['Bowler']['team_name']} won the match by ${ds['target'] - ds['Total']['total_score']} run(s)";
          winner_team = ds['Bowler']['team_name'];
          loser_team = ds['batting_team'];
        }
        var _teams = FirebaseFirestore.instance
            .collection('teams')
            .doc(args['user_id'])
            .collection('myteams');
        if (match_result != 'Match Drawn') {
          if (args['team1_name'] == winner_team) {
            winner_team_id = args['team1_id'];
            loser_team_id = args['team2_id'];
          } else {
            loser_team_id = args['team1_id'];
            winner_team_id = args['team2_id'];
          }
        }

        if (match_result != 'Match Drawn') {
          await _teams.get().then((QuerySnapshot query) {
            query.docs.forEach((doc) {
              if (doc['team_name'] == winner_team) {
                winner_team_won_matches = (doc['stats']['won'] + 1).toString();
                winner_team_played_matches =
                    (doc['stats']['played'] + 1).toString();
              } else if (doc['team_name'] == loser_team) {
                loser_team_won_matches = (doc['stats']['won']).toString();
                loser_team_played_matches =
                    (doc['stats']['played'] + 1).toString();
              }
            });
          });
          ds['isended']
              ? null
              : await _teams.doc(winner_team_id).set({
                  'stats': {
                    'won': FieldValue.increment(1),
                    'played': FieldValue.increment(1),
                    'win_percentage': _win_percentage_calculator(
                            double.parse(winner_team_won_matches),
                            double.parse(winner_team_played_matches))
                        .toInt(),
                  }
                }, SetOptions(merge: true));
          ds['isended']
              ? null
              : await _teams.doc(loser_team_id).set({
                  'stats': {
                    'lost': FieldValue.increment(1),
                    'played': FieldValue.increment(1),
                    'win_percentage': _win_percentage_calculator(
                            double.parse(loser_team_won_matches),
                            double.parse(loser_team_played_matches))
                        .toInt(),
                  }
                }, SetOptions(merge: true));
        } else {
          await _teams.get().then((QuerySnapshot query) {
            query.docs.forEach((doc) {
              if (doc['team_name'] == args['team1_name']) {
                winner_team_won_matches = doc['stats']['won'].toString();
                winner_team_played_matches =
                    (doc['stats']['played'] + 1).toString();
              } else if (doc['team_name'] == args['team2_name']) {
                loser_team_won_matches = doc['stats']['won'].toString();
                loser_team_played_matches =
                    (doc['stats']['played'] + 1).toString();
              }
            });
          });
          ds['isended']
              ? null
              : await _teams.doc(args['team1_id']).set({
                  'stats': {
                    'draw': FieldValue.increment(1),
                    'played': FieldValue.increment(1),
                    'win_percentage': _win_percentage_calculator(
                            double.parse(winner_team_won_matches),
                            double.parse(winner_team_played_matches))
                        .toInt(),
                  }
                }, SetOptions(merge: true));
          ds['isended']
              ? null
              : _teams.doc(args['team2_id']).set({
                  'stats': {
                    'draw': FieldValue.increment(1),
                    'played': FieldValue.increment(1),
                    'win_percentage': _win_percentage_calculator(
                            double.parse(loser_team_won_matches),
                            double.parse(loser_team_played_matches))
                        .toInt(),
                  }
                }, SetOptions(merge: true));
        }
      }).then((value) {});

      FirebaseFirestore.instance
          .collection('matches')
          .doc(args['user_id'])
          .collection('mymatches')
          .doc(args['match_id'])
          .set({
        'islive': false,
      }, SetOptions(merge: true));

      FirebaseFirestore.instance
          .collection('livematches')
          .doc(args['match_id'])
          .delete();

      FirebaseFirestore.instance
          .collection('scoring')
          .doc(args['user_id'])
          .collection('my_matches')
          .doc(args['match_id'])
          .collection('innings')
          .doc('inning2')
          .set({
        'result': {
          'match_result': match_result,
        },
        'isended': true,
      }, SetOptions(merge: true)).then((value) {
        print('result function completed');
        // Navigator.pop(context);
      });
    }).then((value) {
      print('result function completed2');
      // Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('scoring')
          .doc(args['user_id'])
          .collection('my_matches')
          .doc(args['match_id'])
          .collection('innings')
          .doc(args['inning_no'])
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var data = snapshot.data;
        if (snapshot.hasError) {
          return Center(
            child: Text('Something Went Wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        } else {
          args['inning_no'] == 'inning2' && data!['isended'] ||
                  data!['total_inning_overs'] ==
                      data['Total']['total_overs'].toString() ||
                  data['Total']['total_score'] >=
                      data['target'] // && data['result'].isBlank
              ? result_func()
              : null;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    // left: 15.0,
                    // bottom: 2.0,
                  ),
                  child: Center(
                    child: Text(
                      args['inning_no'] == 'inning2' &&
                              data['target'] > data['Total']['total_score']
                          ? '${data['batting_team']} needs ${data['target'] - data['Total']['total_score']} runs to win'
                          : '',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  dense: true,
                  title: Text(
                    data['batting_team'],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    'RR: ' + data['Total']['run_rate'].toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  dense: true,
                  // minVerticalPadding: 1.0,
                  title: Text(
                    data['Total']['total_score'].toString() +
                        '/' +
                        data['Total']['total_wickets'].toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    data['Total']['total_overs'].toString() +
                        '.' +
                        data['Total']['balls'].toString() +
                        ' Overs',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(10.0),
                    1: FlexColumnWidth(3.5),
                    2: FlexColumnWidth(3.5),
                    3: FlexColumnWidth(3.5),
                    4: FlexColumnWidth(3.5),
                    5: FlexColumnWidth(4.0),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      children: [
                        _customtext('Batsman'),
                        _customtext('R'),
                        _customtext('B'),
                        _customtext('4s'),
                        _customtext('6s'),
                        _customtext('SR'),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['striker_name'] ==
                                    data['Batter1']['player_name']
                                ? data['Batter1']['player_name'] + '*'
                                : data['Batter1']['player_name'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        _customtext(data['Batter1']['total_runs'].toString()),
                        _customtext(data['Batter1']['total_balls'].toString()),
                        _customtext(data['Batter1']['fours'].toString()),
                        _customtext(data['Batter1']['sixes'].toString()),
                        _customtext(data['Batter1']['strike_rate'].toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['striker_name'] ==
                                    data['Batter2']['player_name']
                                ? data['Batter2']['player_name'] + '*'
                                : data['Batter2']['player_name'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        _customtext(data['Batter2']['total_runs'].toString()),
                        _customtext(data['Batter2']['total_balls'].toString()),
                        _customtext(data['Batter2']['fours'].toString()),
                        _customtext(data['Batter2']['sixes'].toString()),
                        _customtext(data['Batter2']['strike_rate'].toString()),
                      ],
                    ),
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      children: [
                        _customtext('Bowler'),
                        _customtext('O'),
                        _customtext('M'),
                        _customtext('R'),
                        _customtext('W'),
                        _customtext('ER'),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['Bowler']['player_name'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        _customtext(data['Bowler']['overs'].toString()),
                        _customtext(data['Bowler']['maiden'].toString()), //todo
                        _customtext(data['Bowler']['runs'].toString()),
                        _customtext(data['Bowler']['wickets'].toString()),
                        _customtext(data['Bowler']['economy_rate'].toString()),
                      ],
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  color: Colors.black,
                ),
              ),
              SliverToBoxAdapter(
                // _customcircleavatar('0'),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.065,
                  child: data['over'] != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data['over'].length,
                          itemBuilder: (context, index) {
                            var balls_list = data['over'];
                            return _customcircleavatar(
                                balls_list[index].toString().split('.')[0],
                                balls_list[index].toString().split('.')[1]);
                          })
                      : Center(),
                ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  color: Colors.transparent,
                ),
              ),
              SliverToBoxAdapter(
                child: args['isscoring']
                    ? Container(
                        color: Colors.teal,
                        width: MediaQuery.of(context).size.width,
                        height: data['isended'] ||
                                data['total_inning_overs'] ==
                                    data['Total']['total_overs'].toString()
                            ? MediaQuery.of(context).size.height * 0.25
                            : null,
                        padding: const EdgeInsets.all(25.0),
                        child: data['isended'] ||
                                data['total_inning_overs'] ==
                                    data['Total']['total_overs'].toString() ||
                                (data['target'] <=
                                        data['Total']['total_score'] &&
                                    args['inning_no'] == 'inning2')
                            ? Center(
                                child: args['inning_no'] == 'inning1'
                                    ? MaterialButton(
                                        onPressed: () {
                                          Get.to(
                                            () => select_openers(),
                                            transition: Transition.rightToLeft,
                                            arguments: {
                                              'inning_no': 'inning2',
                                              'match_id': args['match_id'],
                                              'team1_id': args['team1_id'],
                                              'team2_id': args['team2_id'],
                                            },
                                          );
                                        },
                                        shape: StadiumBorder(),
                                        color: Colors.white,
                                        child: Text(
                                          'Start Next Innings',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Match Ended',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              )
                            : ValueListenableBuilder(
                                valueListenable: isextra,
                                builder: (context, ind, _) {
                                  return isextra.value
                                      ? customcontainer()
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Divider(
                                            //   color: Colors.white,
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                custombutton(
                                                    '0',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                                customverticaldivider(),
                                                custombutton(
                                                    '1',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                                customverticaldivider(),
                                                custombutton(
                                                    '2',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                                customverticaldivider(),
                                                custombutton(
                                                    '3',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                custombutton(
                                                    '4',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                                customverticaldivider(),
                                                custombutton(
                                                    '5',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                                customverticaldivider(),
                                                custombutton(
                                                    '6',
                                                    data['Total']
                                                        ['total_overs'],
                                                    data['Total']
                                                        ['total_score'],
                                                    data['Total']['balls']),
                                                customverticaldivider(),
                                                custommaterialbutton('Out', () {
                                                  Get.to(() => PlayerOut(),
                                                      arguments: {
                                                        'inning_no':
                                                            args['inning_no'],
                                                        'match_id':
                                                            args['match_id'],
                                                        'team_name': data[
                                                            'batting_team'],
                                                        'batters_names': [
                                                          data['Batter1']
                                                              ['player_id'],
                                                          data['Batter2']
                                                              ['player_id'],
                                                        ],
                                                      },
                                                      transition:
                                                          Transition.downToUp);
                                                }),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            Row(
                                              children: [
                                                custommaterialbutton('Wide',
                                                    () {
                                                  title_value = 'Wide';
                                                  row1 = [
                                                    customextrabutton('Wd', () {
                                                      scoring_func(
                                                        '1',
                                                        data['Total']
                                                            ['total_overs'],
                                                        data['Total']['balls'],
                                                        data['Total']
                                                            ['total_score'],
                                                        iswide: true,
                                                      );
                                                    }),
                                                    customextrabutton('1 + Wd',
                                                        () {
                                                      scoring_func(
                                                        '2',
                                                        data['Total']
                                                            ['total_overs'],
                                                        data['Total']['balls'],
                                                        data['Total']
                                                            ['total_score'],
                                                        iswide: true,
                                                      );
                                                    }),
                                                    customextrabutton('2 + Wd',
                                                        () {
                                                      scoring_func(
                                                        '3',
                                                        data['Total']
                                                            ['total_overs'],
                                                        data['Total']['balls'],
                                                        data['Total']
                                                            ['total_score'],
                                                        iswide: true,
                                                      );
                                                    }),
                                                  ];
                                                  row2 = [
                                                    customextrabutton('3 + Wd',
                                                        () {
                                                      scoring_func(
                                                        '4',
                                                        data['Total']
                                                            ['total_overs'],
                                                        data['Total']['balls'],
                                                        data['Total']
                                                            ['total_score'],
                                                        iswide: true,
                                                      );
                                                    }),
                                                    customextrabutton('4 + Wd',
                                                        () {
                                                      scoring_func(
                                                        '5',
                                                        data['Total']
                                                            ['total_overs'],
                                                        data['Total']['balls'],
                                                        data['Total']
                                                            ['total_score'],
                                                        iswide: true,
                                                      );
                                                    }),
                                                    // customextrabutton('5 + Wd',(){
                                                    //   extra_runs(6, data['Total']['total_score'],data['Total']['balls'],data['Total']['total_overs']);
                                                    // }),
                                                    // customextrabutton('6 + Wd',(){
                                                    //   extra_runs(7, data['Total']['total_score'],data['Total']['balls'],data['Total']['total_overs']);
                                                    // }),
                                                  ];
                                                  isextra.value = true;
                                                }),
                                                customverticaldivider(),
                                                custommaterialbutton('No Ball',
                                                    () {
                                                  title_value = 'No Ball';
                                                  row1 = [
                                                    customextrabutton('NB', () {
                                                      scoring_func(
                                                          '1',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isno_ball: true);
                                                    }),
                                                    customextrabutton('1 + NB',
                                                        () {
                                                      scoring_func(
                                                          '2',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isno_ball: true);
                                                    }),
                                                    customextrabutton('2 + NB',
                                                        () {
                                                      scoring_func(
                                                          '3',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isno_ball: true);
                                                    }),
                                                  ];
                                                  row2 = [
                                                    customextrabutton('3 + NB',
                                                        () {
                                                      scoring_func(
                                                          '4',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isno_ball: true);
                                                    }),
                                                    customextrabutton('4 + NB',
                                                        () {
                                                      scoring_func(
                                                          '5',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isno_ball: true);
                                                    }),
                                                    // customextrabutton('5 + NB', () {
                                                    //   scoring_func(
                                                    //       '6',
                                                    //       data['Total']
                                                    //           ['total_overs'],
                                                    //       data['Total']['balls'],
                                                    //       data['Total']
                                                    //           ['total_score'],
                                                    //       isno_ball: true);
                                                    // }),
                                                    customextrabutton('6 + NB',
                                                        () {
                                                      scoring_func(
                                                          '7',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isno_ball: true);
                                                    }),
                                                  ];
                                                  isextra.value = true;
                                                }),
                                                customverticaldivider(),
                                                custommaterialbutton('Byes',
                                                    () {
                                                  title_value = 'Byes';
                                                  row1 = [
                                                    customextrabutton('1 B',
                                                        () {
                                                      scoring_func(
                                                          '1',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isbye: true);
                                                    }),
                                                    customextrabutton('2 B',
                                                        () {
                                                      scoring_func(
                                                          '2',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isbye: true);
                                                    }),
                                                    customextrabutton('3 B',
                                                        () {
                                                      scoring_func(
                                                          '3',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isbye: true);
                                                    }),
                                                  ];
                                                  row2 = [
                                                    customextrabutton('4 B',
                                                        () {
                                                      scoring_func(
                                                          '4',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          isbye: true);
                                                    }),
                                                    // customextrabutton('5 B', (){
                                                    //   extra_runs(5, data['Total']['total_score'],data['Total']['balls'],data['Total']['total_overs']);
                                                    // }),
                                                    // customextrabutton('6 B', (){
                                                    //   extra_runs(6, data['Total']['total_score'],data['Total']['balls'],data['Total']['total_overs']);
                                                    // }),
                                                  ];
                                                  isextra.value = true;
                                                }),
                                                customverticaldivider(),
                                                custommaterialbutton('Leg Byes',
                                                    () {
                                                  title_value = 'Leg Byes';
                                                  row1 = [
                                                    customextrabutton('1 LB',
                                                        () {
                                                      scoring_func(
                                                          '1',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          islegbye: true);
                                                    }),
                                                    customextrabutton('2 LB',
                                                        () {
                                                      scoring_func(
                                                          '2',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          islegbye: true);
                                                    }),
                                                    customextrabutton('3 LB',
                                                        () {
                                                      scoring_func(
                                                          '3',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          islegbye: true);
                                                    }),
                                                  ];
                                                  row2 = [
                                                    customextrabutton('4 LB',
                                                        () {
                                                      scoring_func(
                                                          '4',
                                                          data['Total']
                                                              ['total_overs'],
                                                          data['Total']
                                                              ['balls'],
                                                          data['Total']
                                                              ['total_score'],
                                                          islegbye: true);
                                                    }),
                                                    // customextrabutton('5 LB', (){
                                                    //   extra_runs(5, data['Total']['total_score'],data['Total']['balls'],data['Total']['total_overs']);
                                                    // }),
                                                    // customextrabutton('6 LB', (){
                                                    //   extra_runs(6, data['Total']['total_score'],data['Total']['balls'],data['Total']['total_overs']);
                                                    // }),
                                                  ];
                                                  isextra.value = true;
                                                }),
                                              ],
                                            ),
                                          ],
                                        );
                                }),
                      )
                    : Center(),
              ),
            ],
          );
        }
      },
    );
  }
}

// SingleChildScrollView(
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   ValueListenableBuilder(
//                                       valueListenable: wide,
//                                       builder: (context, id, __) {
//                                         return ToggleButtons(
//                                           constraints: BoxConstraints.expand(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.063,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.23,
//                                           ),
//                                           renderBorder: true,
//                                           color: Colors.grey[600],
//                                           fillColor: Colors.teal,
//                                           borderColor: Colors.grey,
//                                           selectedColor: Colors.black,
//                                           selectedBorderColor: Colors.transparent,
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           children: [
//                                             Text(
//                                               'Wide',
//                                               style: TextStyle(
//                                                 fontSize: 17.0,
//                                                 fontWeight: FontWeight.w600,
//                                                 // color: Colors.grey[600],
//                                               ),
//                                             ),
//                                             Text(
//                                               'No Ball',
//                                               style: TextStyle(
//                                                 fontSize: 17.0,
//                                                 fontWeight: FontWeight.w600,
//                                                 // color: Colors.grey[600],
//                                               ),
//                                             ),
//                                           ],
//                                           onPressed: (int index) {
//                                             for (int i = 0;
//                                                 i < isSelected.length;
//                                                 i++) {
//                                               // isSelected[i] = i == index;
//                                               if (i == index) {
//                                                 isSelected[i] = !isSelected[i];
//                                               } else {
//                                                 isSelected[i] = false;
//                                               }
//                                               wide.value = !wide.value;
//                                             }
//                                           },
//                                           isSelected: isSelected,
//                                         );
//                                       }),
//                                   ValueListenableBuilder(
//                                       valueListenable: byes,
//                                       builder: (context, index, _) {
//                                         return ToggleButtons(
//                                           constraints: BoxConstraints.expand(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.063,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.23,
//                                           ),
//                                           renderBorder: true,
//                                           color: Colors.grey[600],
//                                           fillColor: Colors.teal,
//                                           borderColor: Colors.grey,
//                                           selectedColor: Colors.black,
//                                           selectedBorderColor: Colors.transparent,
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           children: [
//                                             Text(
//                                               'Byes',
//                                               style: TextStyle(
//                                                 fontSize: 17.0,
//                                                 fontWeight: FontWeight.w600,
//                                                 // color: Colors.grey[600],
//                                               ),
//                                             ),
//                                             Text(
//                                               'Leg Byes',
//                                               style: TextStyle(
//                                                 fontSize: 17.0,
//                                                 fontWeight: FontWeight.w600,
//                                                 // color: Colors.grey[600],
//                                               ),
//                                             ),
//                                           ],
//                                           onPressed: (int index) {
//                                             for (int i = 0;
//                                                 i < isSelectedbyes.length;
//                                                 i++) {
//                                               // isSelectedbyes[i] = i == index;
//                                               if (i == index) {
//                                                 isSelectedbyes[i] = !isSelectedbyes[i];
//                                               } else {
//                                                 isSelectedbyes[i] = false;
//                                               }
//                                               byes.value = !byes.value;
//                                             }
//                                           },
//                                           isSelected: isSelectedbyes,
//                                         );
//                                       }),
//                                 ],
//                               ),
//                             ),

// SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // Text(
//                             //   '',                                // 'Over ' + data['over']['over_no'].toString(),
//                             //   style: TextStyle(
//                             //     fontSize: 16.0,
//                             //     fontWeight: FontWeight.w800,
//                             //     color: Colors.black,
//                             //   ),
//                             // ),
//                             _customcircleavatar('0'),
//                             _customcircleavatar('4'),
//                             _customcircleavatar('6'),
//                             _customcircleavatar('1'),
//                             _customcircleavatar('W'),
//                             _customcircleavatar('0', true),
//                             // _customcircleavatar('6'),
//                             // _customcircleavatar('3'),
//                             // _customcircleavatar('4'),
//                             // _customcircleavatar('0', true),
//                             // _customcircleavatar('1', true),
//                           ],
//                         ),
//                       ),
//                     ),
