import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/Scoring%20Page/lineupspage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MatchInfo extends StatefulWidget {
  const MatchInfo({Key? key}) : super(key: key);

  @override
  _MatchInfoState createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo> {
  var args = Get.arguments;
  String currentuserid = '';
  var match_info = [];

  void initState() {
    super.initState();
    print(args['match_id']);
    // var currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser != null) {
    //   setState(() {
    //     currentuserid = currentUser.uid;
    //   });
    // }
    getmatchdata();
  }

  Future<void> getmatchdata() async {
    return FirebaseFirestore.instance
        .collection('matches')
        .doc(args['user_id'])
        .collection('mymatches')
        .doc(args['match_id'])
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        match_info.add({
          'team_details': ds['team_details'],
          'match_details': ds['match_details'],
          'match_name': ds['match_name'],
          // 'match_settings': ds['match_settings'],
          'openers': ds['openers'],
          'toss': ds['toss'],
        });
      }
    }).then((value) {
      setState(() {
        print(match_info);
      });
    });
  }

  Widget lineupscontainer(team1icon, team1name, team2icon, team2name) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Colors.grey,
              spreadRadius: 0.2,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text(
              "LINEUPS",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 19),
            ),
          ),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colors.black,
          ),
          ListTile(
            onTap: () {
              Get.to(() => LineupsPage(), arguments: {
                'user_id': args['user_id'],
                'team_name': team1name,
                // 'imgurl' : team1icon,
                'players_ids': match_info[0]['team_details']
                    ['team1_players_ids'],
              });
            },
            dense: true,
            leading: CircleAvatar(
              radius: 20.0,
              foregroundImage: CachedNetworkImageProvider(team1icon),
              backgroundColor: Colors.teal,
              child: Icon(
                FontAwesomeIcons.shieldAlt,
                color: Colors.white,
              ),
            ),
            title: Text(
              team1name,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colors.black,
          ),
          ListTile(
            onTap: () {
              Get.to(() => LineupsPage(), arguments: {
                'user_id': args['user_id'],
                'team_name': team2name,
                // 'imgurl' : team2icon,
                'players_ids': match_info[0]['team_details']
                    ['team2_players_ids'],
              });
            },
            dense: true,
            leading: CircleAvatar(
              radius: 20.0,
              foregroundImage: CachedNetworkImageProvider(team2icon),
              backgroundColor: Colors.teal,
              child: Icon(
                FontAwesomeIcons.shieldAlt,
                color: Colors.white,
              ),
            ),
            title: Text(
              team2name,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget customtile(leading_txt, trailing_txt) {
    return ListTile(
      dense: true,
      title: Text(
        leading_txt,
        style: TextStyle(
            color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 17),
      ),
      trailing: Text(
        trailing_txt,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16.0),
      ),
    );
  }

  Widget customdivider() {
    return Divider(
      indent: 10.0,
      endIndent: 10.0,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    // match_info = args['match_info'];
    if (match_info.isNotEmpty) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: lineupscontainer(
                match_info[0]['team_details']['team1_imgurl'].toString(),
                match_info[0]['team_details']['team1_name'],
                match_info[0]['team_details']['team2_imgurl'].toString(),
                match_info[0]['team_details']['team2_name']),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Colors.grey,
                    spreadRadius: 0.2,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  ListTile(
                    dense: true,
                    title: Text(
                      "Match Info",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 19),
                    ),
                  ),
                  customdivider(),
                  // customtile('Match', 'INDIVIDUAL'),
                  // customdivider(),
                  customtile('Overs', match_info[0]['match_details']['overs']),
                  customdivider(),
                  customtile('Date', match_info[0]['match_details']['date']),
                  customdivider(),
                  customtile('Time', match_info[0]['match_details']['time']),
                  customdivider(),
                  customtile(
                      'Toss',
                      match_info[0]['toss']['toss_winner_team'] +
                          ' OPT ' +
                          match_info[0]['toss']['toss_decision']),
                  customdivider(),
                  customtile(
                      'Ball Type', match_info[0]['match_details']['ball_type']),
                  customdivider(),
                  customtile(
                      'Ground', match_info[0]['match_details']['ground_name']),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      );
    }
  }
}
