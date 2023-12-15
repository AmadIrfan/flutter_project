import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/Scoring%20Page/Infotab.dart';
import '/features/Scoring%20Page/Match%20Summary.dart';
import '/features/Scoring%20Page/matchcentretab.dart';
import '/features/Scoring%20Page/overs.dart';
import '/features/Scoring%20Page/popup_bottomsheet.dart';
import '/features/Scoring%20Page/scorecard_tab.dart';

// import '/Scoring%20Page/commentry_tab.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ScoringPage extends StatefulWidget {
  const ScoringPage({Key? key}) : super(key: key);

  @override
  _ScoringPageState createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPage>
    with TickerProviderStateMixin {
  late TabController _tabcontroller;

  var args = Get.arguments;
  var currentuserid = '';
  var team2_info = [];
  var team1_info = [];
  var ismatchended;
  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: 4, vsync: this);
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // setState(() {
      currentuserid = currentUser.uid;
      // });
    }
    getteamdata(team1_info, args['team1_id']);
    getteamdata(team2_info, args['team2_id']);
  }

  Future<void> getteamdata(teaminfo, teamid) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(args['user_id'])
        .collection('myteams')
        .doc(teamid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        teaminfo.add({
          'team_name': ds['team_name'],
          'team_location': ds['team_location'],
          'teamshortname': ds['teamshortname'],
          'imgurl': ds['imgurl'],
          // 'openers' : ds['openers'],
          // 'toss' : ds['toss'],
        });
      }
    }).then((value) {
      setState(() {});
      // print(teaminfo);
    });
  }

  Widget CustomPopUpMenuChild(txt, icon, onpress) {
    return ListTile(
      minLeadingWidth: 10.0,
      trailing: null,
      onTap: onpress,
      leading: Icon(
        icon,
        size: 25.0,
      ),
      title: Text(
        '$txt',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //       bottomLeft: Radius.circular(10.0),
        //       bottomRight: Radius.circular(10.0),
        //     ),
        //     gradient: LinearGradient(
        //       colors: [
        //         Color(0xff2c5364),
        //             Color(0xff203a43),
        //             Color(0xff0F2027),
        //       ],
        //     ),
        //   ),
        // ),
        backgroundColor: Colors.teal,
        elevation: 0.0,
        toolbarHeight: 70.0,
        centerTitle: true,
        title: team1_info.isNotEmpty
            ? Text(
                "${team1_info[0]['teamshortname']} vs ${team2_info[0]['teamshortname']}",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )
            : Text(''),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: args['isscoring'] ? popup() : Text(''),
          ),
        ],
        bottom: TabBar(
          controller: _tabcontroller,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                "Info",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                args['ismatchended'] ? "Match Summary" : "Match Centre",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Scorecard",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Overs",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Tab(
            //   child: Text(
            //     "Commentry",
            //     style: TextStyle(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabcontroller,
        children: [
          MatchInfo(),
          args['ismatchended'] ? MatchSummary() : MatchCentre(),
          ScoreCard(),
          overs(),
          // Commentry(),
        ],
      ),
    );
  }
}
