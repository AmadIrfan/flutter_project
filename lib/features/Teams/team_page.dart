import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';
import '/features/Teams/create_player.dart';
import '/features/Teams/create_team.dart';
import '/features/Teams/player_stats.dart';
import '/features/Teams/popup.dart';
import '/features/Teams/team_model.dart';

import '/res/components/customdialog.dart';
import '/res/components/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'dart:math' as math;

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  var teamname = Get.arguments;
  // String? currentuserid = '';
  bool inprogress = false;
  var length_player = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   var cuser = FirebaseAuth.instance.currentUser;
  //   if (cuser != null) {
  //     setState(() {
  //       currentuserid = cuser.uid;
  //     });
  //   }
  //   // _insertstats();
  //   print(teamname[6]);
  // }

  // Future<void> _insertstats() async {
  //   var user_ids = [];
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot query) {
  //     query.docs.forEach((user) {
  //       user_ids.add(user.id.toString());
  //     });
  //   }).then((value) {
  //     user_ids.forEach((user_id) {
  //       FirebaseFirestore.instance
  //           .collection('teams')
  //           .doc(user_id)
  //           .collection('myteams')
  //           .get()
  //           .then((QuerySnapshot teams) {
  //         teams.docs.forEach((team) {
  //           // FirebaseFirestore.instance
  //           //     .collection('teams')
  //           //     .doc(user_id)
  //           //     .collection('myteams')
  //           //     .doc(team.id)
  //           team.reference
  //               .set({
  //                'stats':{
  //       'played' : 0,
  //       'won' : 0,
  //       'lost' : 0,
  //       'draw' : 0,
  //       'win_percentage' : 0,
  //     }
  //               }, SetOptions(merge: true));
  //         });
  //       }).then((value){
  //         print('task completed.');
  //       });
  //     });
  //   });
  // }

  Widget customplayertile(leading_icon, player_name, player_attribute, args) {
    return ListTile(
      onTap: () {
        Get.to(PlayerStats(), arguments: args);
      },
      leading: leading_icon,
      title: Text(
        player_name,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        player_attribute,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Future<void> _delete_team() async {
    return FirebaseFirestore.instance
        .collection('teams')
        .doc(teamname[2])
        .collection('myteams')
        .doc(teamname[3])
        .delete()
        .then((value) {
      teamname[1].isNotEmpty
          ? FirebaseStorage.instance.refFromURL(teamname[1]).delete()
          : null;
      FirebaseFirestore.instance
          .collection('players')
          .doc(teamname[2])
          .collection(teamname[0])
          .get()
          .then((QuerySnapshot querysnapshot) {
        querysnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
        FirebaseStorage.instance
            .ref('images/player_photos/${currentuser.uid}/')
            .delete();
        setState(() {
          inprogress = false;
        });
        Navigator.pop(context);
        customtoast('Team Deleted Successfully.');
      });
    }).catchError((error) {
      customtoast('Failed to delete team: $error');
      setState(() {
        inprogress = false;
      });
      Navigator.pop(context);
    });
  }

  Future _delete_dialog() async {
    dialog_func(
      Text('Are you sure?'),
      Text('Do you want to delete this Team?'),
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
            .doc(currentuser.uid)
            .collection('mymatches')
            .get()
            .then((QuerySnapshot querysnap) {
          querysnap.docs.forEach((doc) {
            team1player_names.add(doc['team_details']['team1_name']);
            team2player_names.add(doc['team_details']['team2_name']);
          });
        });
        if (team1player_names.contains(teamname[0].toString()) ||
            team2player_names.contains(teamname[0].toString())) {
          customtoast(
              "Can't delete this team.\nas it has played some matches.");
          setState(() {
            inprogress = false;
          });
        } else {
          _delete_team();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          teamname[0].toString(),
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
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
                  "Edit Team",
                  () {
                    Navigator.pop(context);
                    Get.to(
                      () => create_team(
                        isedit: true,
                        teamid: teamname[3],
                        teamData: TeamModel(
                          teamName: teamname[0],
                          imgUrl: teamname[1],
                          teamShortName: teamname[4],
                          teamLocation: teamname[5],
                          stats: {},
                        ),
                      ),
                      transition: Transition.leftToRight,
                      arguments: [
                        {
                          // 'isedit': true,
                          // 'appbartext': 'Edit Team',
                          // 'currentuserid': currentuserid.toString(),
                          // 'team_name': teamname[0],
                          // 'img_url': teamname[1],
                          // 'team_doc_id': teamname[3],
                          // 'teamshortname': teamname[4],
                          // 'team_location': teamname[5],
                        }
                      ],
                    );
                  },
                  CupertinoIcons.trash,
                  "Delete Team",
                  () {
                    Navigator.pop(context);
                    _delete_dialog();
                  },
                ),
        ],
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => create_player(),
              transition: Transition.downToUp,
              arguments: [
                {
                  'team_name': teamname[0].toString(),
                  'appbartext': 'Create Player',
                  'isedit': false,
                  'player_name': '',
                  'player_role': '',
                  'batting_style': '',
                  'bowling_style': '',
                  'img_url': '',
                }
              ]);
        },
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.person_add,
          size: 30.0,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('players')
              .doc(currentuser.uid)
              .collection(teamname[0].toString())
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var data = snapshot.data?.docs;
            // setState(() {
            // });
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
            }
            if (data!.length == 0) {
              length_player = data.length;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.teal,
                              Colors.tealAccent,
                              Colors.white54,
                            ]),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.teal,
                              foregroundImage:
                                  CachedNetworkImageProvider(teamname[1]),
                              child: Text(
                                teamname[4],
                                style: TextStyle(
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              teamname[5],
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Played \n ${teamname[6]["played"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Won\n${teamname[6]["won"].toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  "Lost\n${teamname[6]['lost']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Draw/Tie\n${teamname[6]["draw"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Win  %\n${teamname[6]["win_percentage"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Players ($length_player)',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            size: 50.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'No Player',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              length_player = data.length;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.teal,
                              Colors.tealAccent,
                              Colors.white54,
                            ]),
                      ),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.teal,
                              foregroundImage:
                                  CachedNetworkImageProvider(teamname[1]),
                              child: Text(
                                teamname[4],
                                style: TextStyle(
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Center(
                              child: Text(
                                teamname[5],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Played\n${teamname[6]["played"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Won\n${teamname[6]["won"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Lost\n${teamname[6]["lost"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Draw/Tie\n${teamname[6]["draw"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Win  %\n${teamname[6]["win_percentage"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Players ($length_player)',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        DocumentSnapshot docsnapshot =
                            snapshot.data!.docs[index];
                        return customplayertile(
                          CircleAvatar(
                            backgroundColor: Colors.grey[500],
                            foregroundImage: CachedNetworkImageProvider(
                              docsnapshot['imgurl'],
                            ),
                            radius: 30.0,
                            child: Icon(
                              FontAwesomeIcons.userAlt,
                              color: Colors.grey[800],
                              size: 30.0,
                            ),
                          ),
                          docsnapshot['player_name'].toString(),
                          docsnapshot['player_role'].toString(),
                          [
                            {
                              'player_name': docsnapshot['player_name'],
                              'player_role': docsnapshot['player_role'],
                              'batting_style': docsnapshot['batting_style'],
                              'bowling_style': docsnapshot['bowling_style'],
                              'img_url': docsnapshot['imgurl'],
                              'player_id': docsnapshot.id.toString(),
                              'team_name': teamname[0].toString(),
                            }
                          ],
                        );
                      },
                      childCount: length_player,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}




// ListView.builder(
//           itemCount: 10,
//           itemBuilder: (BuildContext context, ind) {
//             return  customplayertile(
//                 CircleAvatar(
//                   backgroundColor: Colors.grey[500],
//                   radius: 30.0,
//                   child: Icon(
//                     FontAwesomeIcons.userAlt,
//                     color: Colors.grey[800],
//                     size: 30.0,
//                   ),
//                 ),
//                 'Shami',
//                 'Batting Allrounder',
//               );
//           },
//         ),


//  Container(
//             height: MediaQuery.of(context).size.height * 0.45,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.teal,
//                     Colors.tealAccent,
//                     Colors.white54,
//                   ]),
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 50.0),
//                   child: CircleAvatar(
//                     radius: 50.0,
//                     backgroundColor: Colors.teal,
//                     child: Text(
//                       'PA',
//                       style: TextStyle(
//                         fontSize: 30.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15.0),
//                   child: Text(
//                     'Pakistan',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.w800,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         'Played\n4',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       Text(
//                         'Won\n4',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       Text(
//                         'Lost\n0',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         'Draw/Tie\n0',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       Text(
//                         'Win %\n100',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Text(
//               'Players (10)',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),

          
         