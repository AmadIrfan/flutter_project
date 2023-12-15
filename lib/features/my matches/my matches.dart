// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/my%20matches/create_match.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Scoring Page/scoring_page.dart';
import '../home/home_page.dart';

class Matches extends StatefulWidget {
  const Matches({Key? key}) : super(key: key);

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  final match_info_box = GetStorage('Match_Info');
  var team1info = [];
  var team2info = [];
  var args = Get.arguments;
  String currentuserid = '';
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
      onWillPop: () async {
        Get.to(
          () => HomePage(),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            'My Matches',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            match_info_box.erase();
            Get.to(() => CreateMatch(),
                transition: Transition.rightToLeft,
                arguments: {
                  // 'team_name': '',
                  'team_name': '',
                  'team_logo': '',
                  'team_location': '',
                  'team_id': '',
                  'team_short_name': '',
                });
          },
          backgroundColor: Colors.teal,
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
          color: Colors.teal,
          onRefresh: () async {
            setState(() {});
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('matches')
                .doc(currentuserid)
                .collection('mymatches')
                .orderBy('match_details.date', descending: true)
                .orderBy('match_details.time', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              var data = snapshot.data?.docs;
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
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 50.0,
                        color: Colors.black87.withOpacity(0.8),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "No Match\nPress '+' to create match",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: data.length, // removed null !
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('scoring')
                            .doc(currentuserid)
                            .collection('my_matches')
                            .doc(ds.id)
                            .collection('innings')
                            .snapshots(),
                        builder: (context, scoring_snapshot) {
                          var inning2 = {};
                          var decision;
                          if (scoring_snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center();
                          } else {
                            DocumentSnapshot inning1 =
                                scoring_snapshot.data!.docs[0];
                            if (scoring_snapshot.data!.docs.length > 1) {
                              DocumentSnapshot ds2 =
                                  scoring_snapshot.data!.docs[1];
                              inning2 = {
                                'total_score': ds2['Total']['total_score'],
                                'total_wickets': ds2['Total']['total_wickets'],
                                'run_rate': ds2['Total']['run_rate'],
                                'total_overs':
                                    ds2['Total']['total_overs'].toString() +
                                        '.' +
                                        ds2['Total']['balls'].toString(),
                              };
                              if (ds2['isended'] ||
                                  ds2['target'] <=
                                      ds2['Total']['total_score'] ||
                                  ds2['total_inning_overs'].toString() ==
                                      ds2['Total']['total_overs']) {
                                decision = ds2['result']['match_result'];
                              } else {
                                decision =
                                    '${ds2['batting_team']} needs ${ds2['target'] - ds2['Total']['total_score']} runs to win';
                              }
                            } else {
                              inning2 = {
                                'total_score': '0',
                                'total_wickets': '0',
                                'run_rate': '0.0',
                                'total_overs': '0.0',
                              };
                              decision = '';
                            }

                            return InkWell(
                              onTap: () async {
                                var inning_no;
                                var ismatchended;
                                await FirebaseFirestore.instance
                                    .collection('scoring')
                                    .doc(currentuserid)
                                    .collection('my_matches')
                                    .doc(ds.id.toString())
                                    .collection('innings')
                                    .get()
                                    .then((QuerySnapshot qs) {
                                  if (qs.docs.length > 1) {
                                    inning_no = 'inning2';
                                  } else {
                                    inning_no = 'inning1';
                                  }
                                });
                                inning_no == 'inning2'
                                    ? await FirebaseFirestore.instance
                                        .collection('scoring')
                                        .doc(currentuserid)
                                        .collection('my_matches')
                                        .doc(ds.id.toString())
                                        .collection('innings')
                                        .doc('inning2')
                                        .get()
                                        .then((DocumentSnapshot data) {
                                        data['isended'] ||
                                                data['total_inning_overs'] ==
                                                    data['Total']['total_overs']
                                                        .toString() ||
                                                data['target'] <=
                                                    data['Total']
                                                        ['total_score'] ||
                                                data['target'] - 1 ==
                                                    data['Total']['total_score']
                                            ? ismatchended = true
                                            : ismatchended = false;
                                      })
                                    : ismatchended = false;
                                Get.to(
                                  () => ScoringPage(),
                                  arguments: {
                                    'inning_no': inning_no,
                                    'user_id': currentuserid,
                                    'match_id': ds.id.toString(),
                                    'team1_id': ds['team_details']['team1_id'],
                                    'team1_name': ds['team_details']
                                        ['team1_name'],
                                    'team2_name': ds['team_details']
                                        ['team2_name'],
                                    'team2_id': ds['team_details']['team2_id'],
                                    'isscoring': true,
                                    'ismatchended': ismatchended,
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                // margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 4),
                                    ),
                                    // BoxShadow(color: Color(0xFFDFD9D9), offset: Offset(5.0, 5.0), blurRadius: 10, spreadRadius: 2.0)
                                  ],
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    ListTile(
                                      dense: true,
                                      leading: Text(
                                        ds['match_details']['date'] +
                                            ', ' +
                                            ds['match_details']['time'] +
                                            ' | ' +
                                            ds['match_details']['overs'] +
                                            ' Overs',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: ds['islive'] || decision == ''
                                              ? Colors.teal
                                              : Colors.green,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            ds['islive'] || decision == ''
                                                ? 'Live'
                                                : "Completed",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.teal,
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                                ds['team_details']
                                                                ['team1_name']
                                                            .toString() ==
                                                        inning1['batting_team']
                                                    ? ds['team_details']
                                                        ['team1_imgurl']
                                                    : ds['team_details']
                                                        ['team2_imgurl']),
                                        child: Text(
                                          ds['team_details']['team1_name']
                                                      .toString() ==
                                                  inning1['batting_team']
                                              ? ds['team_details']['team1_name']
                                                  .toString()
                                                  .substring(0, 2)
                                              : ds['team_details']['team2_name']
                                                  .toString()
                                                  .substring(0, 2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        ds['team_details']['team1_name']
                                                    .toString() ==
                                                inning1['batting_team']
                                            ? ds['team_details']['team1_name']
                                                .toString()
                                            : ds['team_details']['team2_name']
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${inning1['Total']['total_overs']}.${inning1['Total']['balls']} Overs | RR: ${inning1['Total']['run_rate']}",
                                        // '0.5 Overs | RR: 12.00',
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${inning1['Total']['total_score']}/${inning1['Total']['total_wickets']}",
                                        // '10/1',
                                        style: TextStyle(
                                          // color: Colors.grey,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                                ds['team_details']
                                                            ['team2_name'] ==
                                                        inning1['batting_team']
                                                    ? ds['team_details']
                                                        ['team1_imgurl']
                                                    : ds['team_details']
                                                        ['team2_imgurl']),
                                        backgroundColor: Colors.teal,
                                        child: Text(
                                          ds['team_details']['team2_name'] ==
                                                  inning1['batting_team']
                                              ? ds['team_details']['team1_name']
                                                  .toString()
                                                  .substring(0, 2)
                                              : ds['team_details']['team2_name']
                                                  .toString()
                                                  .substring(0, 2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        ds['team_details']['team2_name'] ==
                                                inning1['batting_team']
                                            ? ds['team_details']['team1_name']
                                            : ds['team_details']['team2_name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${inning2['total_overs']} Overs | RR: ${inning2['run_rate']}",
                                        // '0.0 Overs | RR: 0.00',
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${inning2['total_score']}/${inning2['total_wickets']}",
                                        // '0/0',
                                        style: TextStyle(
                                          // color: Colors.grey,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        decision == ''
                                            ? ds['toss']['toss_winner_team'] +
                                                ' won the toss and elected to ' +
                                                ds['toss']['toss_decision']
                                            : decision,
                                        // 'Pakistan won the toss and elected to bowl',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        });
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// final DateTime now = DateTime.now();
//               final DateFormat formatter = DateFormat('MMM dd, yyyy, h:m:s a');
//               final String formatted = formatter.format(now);


