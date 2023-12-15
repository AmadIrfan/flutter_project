import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/res/components/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SelectPlayer extends StatefulWidget {
  const SelectPlayer({Key? key}) : super(key: key);

  @override
  _SelectPlayerState createState() => _SelectPlayerState();
}

class _SelectPlayerState extends State<SelectPlayer> {
  ValueNotifier<bool> _selectedRadio = ValueNotifier(false);

  String currentuserid = '';
  final match_info_box = GetStorage('Match_Info');
  var selected_players = {};
  var selected_players_true_val = {};
  var all_players = [];
  var args = Get.arguments;
  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        _fetch_players_data();
      });
    }
  }

  Future<void> _fetch_players_data() async {
    return FirebaseFirestore.instance
        .collection('players')
        .doc(currentuserid)
        .collection(args['team_name'].toString())
        .get()
        .then((QuerySnapshot qsnap) {
      qsnap.docs.forEach((doc) {
        all_players.add({
          'player_name': doc['player_name'],
          'player_role': doc['player_role'],
          'batting_style': doc['batting_style'],
          'bowling_style': doc['bowling_style'],
          'imgurl': doc['imgurl'],
          'player_id': doc.id,
        });
        if (match_info_box.read('selected_status' + args['team_name']) ==
            null) {
          selected_players[doc['player_name']] = false;
        } else {
          Map players_status =
              match_info_box.read('selected_status' + args['team_name']);
          players_status.forEach((key, value) {
            if (key == doc['player_name']) {
              selected_players[doc['player_name']] = value;
              if (value) {
                selected_players_true_val[doc['player_name']] = {
                  'player_name': doc['player_name'],
                  'player_role': doc['player_role'],
                  'batting_style': doc['batting_style'],
                  'bowling_style': doc['bowling_style'],
                  'imgurl': doc['imgurl'],
                  'player_id': doc.id,
                };
              }
            }
          });
        }
      });
    }).then((value) {
      setState(() {
        print(selected_players);
      });
    });
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
          "Select Player",
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
                if (selected_players_true_val.length < 2) {
                  customtoast('Select at least 2 players');
                } else {
                  print(selected_players_true_val);
                  match_info_box.write(args['team_name'] + 'players',
                      selected_players_true_val.keys.toList());
                  match_info_box.write(
                      'selected_status' + args['team_name'], selected_players);
                  selected_players_true_val.forEach((plkey, plvalue) {
                    match_info_box
                        .write(args['team_name'].toString() + '$plkey', {
                      'player_name': plvalue['player_name'],
                      'player_role': plvalue['player_role'],
                      'batting_style': plvalue['batting_style'],
                      'bowling_style': plvalue['bowling_style'],
                      'imgurl': plvalue['imgurl'],
                      'player_id': plvalue['player_id'],
                    }).then((value) {
                      var id = match_info_box.read(
                          args['team_name'].toString() + '$plkey')['player_id'];
                      print('player_id : $id');
                    });
                  });
                  Get.back();
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
            _fetch_players_data();
          });
        },
        child: all_players.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                    // color: Colors.teal,
                    ),
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
                      return ListTile(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5),
                        // ),
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
                                  selected_players[all_players[index]
                                      ['player_name']] = newval;
                                  if (selected_players[all_players[index]
                                      ['player_name']]) {
                                    selected_players_true_val[all_players[index]
                                        ['player_name']] = {
                                      'player_name': all_players[index]
                                          ['player_name'],
                                      'player_role': all_players[index]
                                          ['player_role'],
                                      'batting_style': all_players[index]
                                          ['batting_style'],
                                      'bowling_style': all_players[index]
                                          ['bowling_style'],
                                      'imgurl': all_players[index]['imgurl'],
                                      'player_id': all_players[index]
                                          ['player_id'],
                                    };
                                  } else {
                                    selected_players_true_val.remove(
                                        all_players[index]['player_name']);
                                  }
                                });
                                _selectedRadio.value = selected_players[
                                    all_players[index]['player_name']];
                              }),
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
