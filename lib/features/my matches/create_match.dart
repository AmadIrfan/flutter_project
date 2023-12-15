import 'package:cached_network_image/cached_network_image.dart';
import '/features/my%20matches/match_details.dart';
import '/features/my%20matches/select_player.dart';
import '/features/my%20matches/select_team.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../res/components/customtaost.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({Key? key}) : super(key: key);

  @override
  _CreateMatchState createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final match_info_box = GetStorage('Match_Info');
  // var args = Get.arguments;
  String currentuserid = '';
  var team1name = 'Team 1';
  var team1location = 'Tap to add';
  var team2name = 'Team 2';
  var team2location = 'Tap to add';
  var team1img = '';
  var team2img = '';
  var team1shortname = '';
  var team2shortname = '';

  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
      });
      teaminfolistner();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> teaminfolistner() async {
    match_info_box.listen(() {
      if (match_info_box.read('team1info') != null) {
        team1name = match_info_box.read('team1info')['team_name'];
        team1location = match_info_box.read('team1info')['team_location'];
        team1img = match_info_box.read('team1info')['imgurl'];
        team1shortname = match_info_box.read('team1info')['teamshortname'];
      }
      if (match_info_box.read('team2info') != null) {
        team2name = match_info_box.read('team2info')['team_name'];
        team2location = match_info_box.read('team2info')['team_location'];
        team2img = match_info_box.read('team2info')['imgurl'];
        team2shortname = match_info_box.read('team2info')['teamshortname'];
      }
      setState(() {});
    });
  }

  Widget customteamcontainer(teamicon, teamname, cityname, _ontap) {
    return GestureDetector(
      onTap: _ontap,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              teamicon,
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  teamname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                cityname,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customlineuptile(teamname, add_edit_icon, add_edit_text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(9)),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 16.0),
            dense: true,
            title: Text(
              "LINEUP-$teamname",
              style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w500,
                  fontSize: 19),
            ),
          ),
          Divider(
            endIndent: 20,
            indent: 20,
          ),
          ListTile(
            onTap: () {
              if (match_info_box.read('team1info') != null) {
                if (match_info_box.read('team2info') != null) {
                  Get.to(() => SelectPlayer(), arguments: {
                    'team_name': teamname.toString(),
                  });
                } else {
                  customtoast('Select 2 teams');
                }
              } else {
                customtoast('Select 2 teams');
              }
            },
            dense: true,
            leading: add_edit_icon,
            title: Text(
              add_edit_text,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Create Match",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
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
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: Text(
                  "Team Details",
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              controller: ScrollController(keepScrollOffset: false),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: customteamcontainer(
                    team1img.isNotEmpty
                        ? CircleAvatar(
                            radius: 50,
                            foregroundImage:
                                CachedNetworkImageProvider(team1img),
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              FontAwesomeIcons.users,
                              color: Colors.grey[800],
                              size: 30,
                            ),
                          )
                        : Icon(
                            FontAwesomeIcons.shieldAlt,
                            color: Colors.grey[800],
                            size: 100,
                          ),
                    team1name,
                    team1location,
                    () {
                      Get.to(() => SelectTeam(),
                          transition: Transition.downToUp,
                          arguments: {'teamno': 'team1'});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: customteamcontainer(
                    team2img.isNotEmpty
                        ? CircleAvatar(
                            radius: 50,
                            foregroundImage:
                                CachedNetworkImageProvider(team2img),
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              FontAwesomeIcons.users,
                              color: Colors.grey[800],
                              size: 30,
                            ),
                          )
                        : Icon(
                            FontAwesomeIcons.shieldAlt,
                            color: Colors.grey[800],
                            size: 100,
                          ),
                    team2name,
                    team2location,
                    () {
                      Get.to(() => SelectTeam(),
                          transition: Transition.downToUp,
                          arguments: {'teamno': 'team2'});
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: customlineuptile(
                  team1name,
                  match_info_box.read(team1name + 'players') != null
                      ? Icon(
                          Icons.check_box,
                          color: Colors.teal,
                          size: 30,
                        )
                      : Icon(
                          Icons.add_circle_rounded,
                          color: Colors.grey[700],
                          size: 30,
                        ),
                  match_info_box.read(team1name + 'players') != null
                      ? 'Lineup Selected'
                      : 'Add Lineup'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: customlineuptile(
                  team2name,
                  match_info_box.read(team2name + 'players') != null
                      ? Icon(
                          Icons.check_box,
                          color: Colors.teal,
                          size: 30,
                        )
                      : Icon(
                          Icons.add_circle_rounded,
                          color: Colors.grey[700],
                          size: 30,
                        ),
                  match_info_box.read(team2name + 'players') != null
                      ? 'Lineup Selected'
                      : 'Add Lineup'),
            ),
            Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        fixedSize: Size(110, 48)),
                    onPressed: () {
                      if (match_info_box.read('team1info') != null) {
                        if (match_info_box.read('team2info') != null) {
                          if (match_info_box.read(team1name + 'players') !=
                              null) {
                            if (match_info_box.read(team2name + 'players') !=
                                null) {
                              Get.to(
                                MatchDetails(),
                                transition: Transition.rightToLeft,
                              );
                            } else {
                              customtoast('Select $team2name Lineup');
                              //team 2 players
                            }
                          } else {
                            customtoast('Select $team1name Lineup');
                            //team 1 players
                          }
                        } else {
                          customtoast('Select team2');
                          //team2info
                        }
                      } else {
                        customtoast('Select team1');
                        //team1info
                      }
                    },
                    child: Text('Next')),
              ),
            ]),
          ],
        ));
  }
}
