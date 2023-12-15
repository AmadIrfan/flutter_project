// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchSummary extends StatefulWidget {
  const MatchSummary({Key? key}) : super(key: key);

  @override
  _MatchSummaryState createState() => _MatchSummaryState();
}

class _MatchSummaryState extends State<MatchSummary> {
  var args = Get.arguments;
  var MostValuablePlayer;
  var MostValuablePlayerimg;
  var TopBatters = [];
  var TopBattersImgs = [];
  var TopBowlers = [];
  var TopBowlerImgs = [];
  late DocumentReference _player;
  // @override
  void initState() {
    super.initState();
   _player =  FirebaseFirestore.instance.collection('players').doc(args['user_id']);
    most_valuable_player();
    top_batters();
    top_bowlers();
  }

  Future<void> most_valuable_player() async {
    return FirebaseFirestore.instance
        .collection('scoring')
        .doc(args['user_id'])
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('teams_players')
        // .where('batting.total_runs', isGreaterThan: 0)
        // .where('batting.status', isEqualTo: 'Out')
        // .where('bowling.overs', isGreaterThan: 0)
        .orderBy('batting.total_runs', descending: true)
        .orderBy('bowling.wickets', descending: true)
        .get()
        .then((QuerySnapshot query) async {
          _player.collection(query.docs[0]['team_name']).doc(query.docs[0].id.toString()).get().then((DocumentSnapshot ds){
            MostValuablePlayerimg = ds['imgurl'];
          });          
      MostValuablePlayer = query.docs[0].data();
    }).then((value) {
      print(MostValuablePlayer);
      print(MostValuablePlayerimg);
      setState(() {
        // print(MostValuablePlayer);
      });
    });
  }

  Future<void> top_batters() async {
    return FirebaseFirestore.instance
        .collection('scoring')
        .doc(args['user_id'])
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('teams_players')
        // .where('batting.status', isEqualTo: 'Out')
        .orderBy('batting.total_runs', descending: true)
        .orderBy('batting.total_balls', descending: false)
        .limit(3)
        .get()
        .then((QuerySnapshot query) {
      query.docs.forEach((doc) {
        TopBatters.add(doc.data());
      });
    }).then((value) {
      // setState(() {
      //   // print(MostValuablePlayer);
      // });
    });
  }

  Future<void> top_bowlers() async {
    return FirebaseFirestore.instance
        .collection('scoring')
        .doc(args['user_id'])
        .collection('my_matches')
        .doc(args['match_id'])
        .collection('teams_players')
        .orderBy('bowling.overs', descending: true)
        .orderBy('bowling.wickets', descending: true)
        .orderBy('bowling.runs', descending: false)
        .limit(3)
        .get()
        .then((QuerySnapshot query) {
      query.docs.forEach((doc) {
        TopBowlers.add(doc.data());
      });
    }).then((value) {
      setState(() {});
    });
  }

  Widget customlisttile(name, score) {
    return ListTile(
      leading: Text(
        name,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: Text(
        score,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  Widget customplayer(tilename, subtilename, Ctraling, img) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(img),
        child: Icon(Icons.person),
      ),
      title: Text(
        tilename,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
      ),
      subtitle: Text(
        subtilename,
        style: TextStyle(
            color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 17),
      ),
      trailing: Text(
        Ctraling,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scoring')
            .doc(args['user_id'])
            .collection('my_matches')
            .doc(args['match_id'])
            .collection('innings')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something Went Wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting || TopBowlers.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          } else {
            var inning = snapshot.data!.docs;
            var inning1 = inning[0];
            var inning2 = inning[1];
            return CustomScrollView(
              slivers: [
                
                SliverToBoxAdapter(
                  child: customlisttile("${inning1['batting_team']}",
                      "${inning1['Total']['total_score']}/${inning1['Total']['total_wickets']}(${inning1['Total']['total_overs']}.${inning1['Total']['balls']})"),
                ),
                SliverToBoxAdapter(
                  child: customlisttile("${inning2['batting_team']}",
                      "${inning2['Total']['total_score']}/${inning2['Total']['total_wickets']}(${inning2['Total']['total_overs']}.${inning2['Total']['balls']})"),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "${inning2['result']['match_result']}",
                      style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Man Of The Match",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: MostValuablePlayer != null
                      ? customplayer(
                          "${MostValuablePlayer['player_name']}",
                          "${MostValuablePlayer['team_name']}",
                          "${MostValuablePlayer['batting']['total_runs']}(${MostValuablePlayer['batting']['total_balls']})\n${MostValuablePlayer['bowling']['overs']}-${MostValuablePlayer['bowling']['wickets']}",
                          "${MostValuablePlayerimg}")
                      : customplayer("", "", "", ""),
                ),
                SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Top Batters",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index1) {
                      return customplayer(
                          "${TopBatters[index1]['player_name']}",
                          "${TopBatters[index1]['team_name']}",
                          "${TopBatters[index1]['batting']['total_runs']}(${TopBatters[index1]['batting']['total_balls']})",
                          "");
                    },
                    childCount: TopBatters.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Top Bowlers",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index1) {
                      return customplayer(
                          "${TopBowlers[index1]['player_name']}",
                          "${TopBowlers[index1]['team_name']}",
                          "${TopBowlers[index1]['bowling']['overs']}-${TopBowlers[index1]['bowling']['runs']}-${TopBowlers[index1]['bowling']['wickets']}",
                          "");
                    },
                    childCount: TopBowlers.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(),
                ),
              ],
            );
          }
        });
  }
}

 
             
             
              
             
              
              
             
              //  Divider(),
               
              //  customplayer("player5", "Pakistan","1(9)"),
              //  customplayer("player6", "India","0(11)"),
              //  Divider(),