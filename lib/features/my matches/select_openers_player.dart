import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/res/components/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class playersforopeners extends StatefulWidget {
  const playersforopeners({Key? key}) : super(key: key);

  @override
  _playersforopenersState createState() => _playersforopenersState();
}

class _playersforopenersState extends State<playersforopeners> {
  ValueNotifier<bool?> _selectedRadio = ValueNotifier(false);

  String currentuserid = '';
  final match_info_box = GetStorage('Match_Info');
  var selected_players = {};
  var selected_players_true_val = [];
  var all_players = [];
  var args = Get.arguments;
  var team_players_ids = [];
  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        args['inning_no'] == 'inning1'
            ? _fetch_players_data_inning1()
            : _getplayerids();
      });
    }
  }

  Future<void> _getplayerids() async {
    await FirebaseFirestore.instance
        .collection('scoring')
        .doc(currentuserid)
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('teams_players')
        .where('team_name', isEqualTo: args['team_name'])
        .get()
        .then((QuerySnapshot players) {
      players.docs.forEach((doc) {
        team_players_ids.add(doc.id.toString());
      });
    }).then((value) {
      _fetch_players_data_inning2().then((value) {
        setState(() {});
      });
    });
  }

  Future<void> _fetch_players_data_inning2() async {
    //todo player query
    return FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(args['team_name'])
        .where(FieldPath.documentId, whereIn: team_players_ids)
        .get()
        .then((QuerySnapshot query) {
      query.docs.forEach((doc) {
        if (args['info'] == 'Striker' || args['info'] == 'Non Striker') {
          if (match_info_box.read('openers' + args['team_name'] + 'Striker') !=
              null) {
            if (match_info_box
                    .read('openers' + args['team_name'] + 'Non Striker') !=
                null) {
              if (match_info_box.read('openers' +
                          args['team_name'] +
                          'Striker')['player_name'] !=
                      doc['player_name'] &&
                  match_info_box.read('openers' +
                          args['team_name'] +
                          'Non Striker')['player_name'] !=
                      doc['player_name']) {
                all_players.add({
                  'player_name': doc['player_name'],
                  'player_role': doc['player_role'],
                  'batting_style': doc['batting_style'],
                  'bowling_style': doc['bowling_style'],
                  'imgurl': doc['imgurl'],
                  'player_id': doc.id.toString(),
                });
                selected_players[doc['player_name']] = false;
              }
            } else {
              if (match_info_box.read('openers' +
                      args['team_name'] +
                      'Striker')['player_name'] !=
                  doc['player_name']) {
                all_players.add({
                  'player_name': doc['player_name'],
                  'player_role': doc['player_role'],
                  'batting_style': doc['batting_style'],
                  'bowling_style': doc['bowling_style'],
                  'imgurl': doc['imgurl'],
                  'player_id': doc.id.toString(),
                });
                selected_players[doc['player_name']] = false;
              }
              // non striker else part
            }
          } else {
            if (match_info_box
                    .read('openers' + args['team_name'] + 'Non Striker') !=
                null) {
              if (match_info_box.read('openers' +
                      args['team_name'] +
                      'Non Striker')['player_name'] !=
                  doc['player_name']) {
                all_players.add({
                  'player_name': doc['player_name'],
                  'player_role': doc['player_role'],
                  'batting_style': doc['batting_style'],
                  'bowling_style': doc['bowling_style'],
                  'imgurl': doc['imgurl'],
                  'player_id': doc.id.toString(),
                });
                selected_players[doc['player_name']] = false;
              }
            } else {
              all_players.add({
                'player_name': doc['player_name'],
                'player_role': doc['player_role'],
                'batting_style': doc['batting_style'],
                'bowling_style': doc['bowling_style'],
                'imgurl': doc['imgurl'],
                'player_id': doc.id.toString(),
              });
              selected_players[doc['player_name']] = false;
            }
            //striker else part
          }
        } else {
          if (match_info_box.read('openers' + args['team_name'] + 'Bowler') !=
              null) {
            if (match_info_box.read(
                    'openers' + args['team_name'] + 'Bowler')['player_name'] !=
                doc['player_name']) {
              all_players.add({
                'player_name': doc['player_name'],
                'player_role': doc['player_role'],
                'batting_style': doc['batting_style'],
                'bowling_style': doc['bowling_style'],
                'imgurl': doc['imgurl'],
                'player_id': doc.id.toString(),
              });
              selected_players[doc['player_name']] = false;
            }
          } else {
            all_players.add({
              'player_name': doc['player_name'],
              'player_role': doc['player_role'],
              'batting_style': doc['batting_style'],
              'bowling_style': doc['bowling_style'],
              'imgurl': doc['imgurl'],
              'player_id': doc.id.toString(),
            });
            selected_players[doc['player_name']] = false;
          }
        }
      });
    });
  }

  Future<void> _fetch_players_data_inning1() async {
    // return
    var players = match_info_box.read(args['team_name'] + 'players');
    for (var player_name in players) {
      var player_info =
          match_info_box.read(args['team_name'] + player_name.toString());
      print(player_info);

      if (args['info'] == 'Striker' || args['info'] == 'Non Striker') {
        if (match_info_box.read('openers' + args['team_name'] + 'Striker') !=
            null) {
          if (match_info_box
                  .read('openers' + args['team_name'] + 'Non Striker') !=
              null) {
            if (match_info_box.read('openers' + args['team_name'] + 'Striker')[
                        'player_name'] !=
                    player_info['player_name'] &&
                match_info_box.read('openers' +
                        args['team_name'] +
                        'Non Striker')['player_name'] !=
                    player_info['player_name']) {
              all_players.add(player_info);
            }
          } else {
            if (match_info_box.read(
                    'openers' + args['team_name'] + 'Striker')['player_name'] !=
                player_info['player_name']) {
              all_players.add(player_info);
            }
            // non striker else part
          }
        } else {
          if (match_info_box
                  .read('openers' + args['team_name'] + 'Non Striker') !=
              null) {
            if (match_info_box.read('openers' +
                    args['team_name'] +
                    'Non Striker')['player_name'] !=
                player_info['player_name']) {
              all_players.add(player_info);
            }
          } else {
            all_players.add(player_info);
          }
          //striker else part
        }
      } else {
        if (match_info_box.read('openers' + args['team_name'] + 'Bowler') !=
            null) {
          if (match_info_box.read(
                  'openers' + args['team_name'] + 'Bowler')['player_name'] !=
              player_info['player_name']) {
            all_players.add(player_info);
          }
        } else {
          all_players.add(player_info);
        }
      }

      selected_players[player_info['player_name']] = false;
      setState(() {
        all_players;
        selected_players;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text(
          "Select Players",
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 21.0,
              fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                // _fetch_players_data();
                if (selected_players_true_val.length == 0) {
                  customtoast('Select a player');
                } else {
                  match_info_box
                      .write('openers' + args['team_name'] + args['info'], {
                    'player_name': selected_players_true_val[0]['player_name'],
                    'player_role': selected_players_true_val[0]['player_role'],
                    'batting_style': selected_players_true_val[0]
                        ['batting_style'],
                    'bowling_style': selected_players_true_val[0]
                        ['bowling_style'],
                    'imgurl': selected_players_true_val[0]['imgurl'],
                    'player_id': selected_players_true_val[0]['player_id'],
                  }).then((value) {
                    print('completed' +
                        match_info_box
                            .read('openers' + args['team_name'] + args['info'])
                            .toString());
                    Get.back();
                    // customtoast('player');
                  });
                }
              },
              icon: Icon(
                Icons.check,
                size: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            all_players.clear();
            selected_players.clear();
            args['inning_no'] == 'inning1'
                ? _fetch_players_data_inning1()
                : _fetch_players_data_inning2();
          });
        },
        child: all_players.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2.0,
                    height: 5.0,
                    indent: 95.0,
                  );
                },
                itemCount: all_players.length, // removed null !
                itemBuilder: (BuildContext context, int index) {
                  return ValueListenableBuilder(
                    valueListenable: _selectedRadio,
                    builder: (context, index1, _) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 12, left: 14, right: 14),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.transparent,
                          visualDensity: VisualDensity(vertical: 3),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey[200],
                            radius: 24,
                            foregroundImage: CachedNetworkImageProvider(
                                all_players[index]['imgurl'].toString()),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: Text(
                              all_players[index]['player_name'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                          subtitle: Text(
                            all_players[index]['batting_style'],
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          trailing: Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                                activeColor: Colors.teal,
                                value: selected_players[all_players[index]
                                    ['player_name']],
                                onChanged: (newval) async {
                                  setState(() {
                                    selected_players_true_val.clear();
                                    selected_players.forEach((key, value) {
                                      selected_players[key] = false;
                                    });
                                    selected_players[all_players[index]
                                        ['player_name']] = newval;
                                    if (newval == true) {
                                      selected_players_true_val
                                          .add(all_players[index]);
                                      print(selected_players_true_val[0]);
                                    }
                                  });
                                  _selectedRadio.value = selected_players[
                                      all_players[index]['player_name']];
                                }),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
