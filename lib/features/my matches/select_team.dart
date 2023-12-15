import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SelectTeam extends StatefulWidget {
  const SelectTeam({Key? key}) : super(key: key);

  @override
  _SelectTeamState createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  String currentuserid = '';
  List TeamsData = [''];
  var team1name = '';
  var team2name = '';
  String _selectedteamname = '';
  var args = Get.arguments;
  final match_info_box = GetStorage('Match_Info');

  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        if (match_info_box.read('team1info') != null) {
          team1name = match_info_box.read('team1info')['team_name'];
          TeamsData.add(match_info_box.read('team1info')['team_name']);
        }
        if (match_info_box.read('team2info') != null) {
          team2name = match_info_box.read('team2info')['team_name'];
          TeamsData.add(match_info_box.read('team2info')['team_name']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Select Team',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('teams')
              .doc(currentuserid)
              .collection('myteams')
              .where('team_name', whereNotIn: TeamsData)
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
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'No Team',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2.0,
                    height: 5.0,
                    indent: 70.0,
                  );
                },
                itemCount: data.length, // removed null !
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ListTile(
                    onTap: () {
                      if (args['teamno'].toString() == 'team1') {
                        match_info_box.write('team1info', {
                          'team_name': ds['team_name'].toString(),
                          'team_location': ds['team_location'].toString(),
                          'imgurl': ds['imgurl'].toString(),
                          'teamshortname': ds['teamshortname'].toString(),
                          'team_id': ds.id.toString(),
                        }).then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        match_info_box.write('team2info', {
                          'team_name': ds['team_name'].toString(),
                          'team_location': ds['team_location'].toString(),
                          'imgurl': ds['imgurl'].toString(),
                          'teamshortname': ds['teamshortname'].toString(),
                          'team_id': ds.id.toString(),
                        }).then((value) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      foregroundImage:
                          CachedNetworkImageProvider(ds['imgurl'].toString()),
                      child: Text(
                        ds['team_name']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      ds['team_name'],
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 25.0,
                    ),
                    subtitle: Text(
                      ds['team_location'],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
