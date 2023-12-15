import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class selectplayer extends StatefulWidget {
  const selectplayer({Key? key}) : super(key: key);

  @override
  _selectplayerState createState() => _selectplayerState();
}

class _selectplayerState extends State<selectplayer> {
  String currentuserid = '';
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          title: Text(
            args['appbartxt'].toString(),
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 21.0,
                fontWeight: FontWeight.w500),
          ),
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          // ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('scoring')
                .doc(currentuserid)
                .collection('my_matches')
                .doc(args['match_id'])
                .collection('teams_players')
                .where('team_name', isEqualTo: args['team_name'])
                .where(FieldPath.documentId,
                    isNotEqualTo: args['current_player_id'])
                .snapshots(),
            builder: (context, snapshot) {
              var doc = snapshot.data?.docs;
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
                return ListView.builder(
                  itemCount: doc!.length, // removed null !
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = doc[index];
                    print(ds.id);
                    print(args['team_name']);
                    return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('players')
                            .doc(currentuserid)
                            .collection(args['team_name'].toString())
                            .doc(ds.id.toString())
                            .snapshots(),
                        builder: (context, mysnapshot) {
                          var data = mysnapshot.data;
                          // print(data!['player_name']);
                          if (mysnapshot.hasError) {
                            return Center(
                              child: Text('Something Went Wrong'),
                            );
                          }
                          if (mysnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // return Text('');
                            return Center(
                                //     // child: CircularProgressIndicator(
                                //     //   color: Colors.teal,
                                //     // ),
                                );
                          } else {
                            return ListTile(
                              onTap: () async {
                                var match = FirebaseFirestore.instance
                                    .collection('scoring')
                                    .doc(currentuserid)
                                    .collection('my_matches')
                                    .doc(args['match_id']);

                                await match
                                    .collection('innings')
                                    .doc(args['inning'])
                                    .get()
                                    .then((DocumentSnapshot ds) {
                                  var over = [];
                                  var sum = 0;
                                  if (ds.exists) {
                                    over = ds['over'];
                                    over.forEach((element) {
                                      sum = sum +
                                          int.parse(
                                              element.toString().split('.')[0]);
                                    });
                                    if (sum == 0) {
                                      match
                                          .collection('teams_players')
                                          .doc(args['current_player_id'])
                                          .set({
                                        'bowling': {
                                          'maiden': FieldValue.increment(1)
                                        }
                                      }, SetOptions(merge: true));
                                    }
                                  }
                                });
                                match
                                    .collection('innings')
                                    .doc(args['inning'])
                                    .set({
                                  'over': [],
                                  'Bowler': {
                                    'player_id': data.id.toString(),
                                    'player_name': data['player_name'],
                                    'team_name': args['team_name'],
                                    'overs': ds['bowling']['overs'],
                                    'maiden': ds['bowling']['maiden'],
                                    'runs': ds['bowling']['runs'],
                                    'wickets': ds['bowling']['wickets'] != null
                                        ? ds['bowling']['wickets']
                                        : 0,
                                    'economy_rate': ds['bowling']
                                        ['economy_rate'],
                                  },
                                }, SetOptions(merge: true)).then((value) {
                                  Get.back();
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              tileColor: Colors.transparent,
                              visualDensity: VisualDensity(vertical: 3),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueGrey[200],
                                radius: 24,
                                foregroundImage: CachedNetworkImageProvider(
                                    data!['imgurl'].toString()),
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Text(
                                  data['player_name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              subtitle: Text(
                                data['player_role'],
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            );
                          }
                        });
                  },
                );
              }
            }),
      ),
    );
  }
}
