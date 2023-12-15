import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class selectbatsman extends StatefulWidget {
  const selectbatsman({Key? key}) : super(key: key);

  @override
  _selectbatsmanState createState() => _selectbatsmanState();
}

class _selectbatsmanState extends State<selectbatsman> {
  String currentuserid = '';
  var args = Get.arguments;
  final player_info_box = GetStorage('player_info');
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text(
          'Select Batsman',
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('scoring')
                .doc(currentuserid)
                .collection('my_matches')
                .doc(args['match_id'])
                .collection('teams_players')
                .where('team_name', isEqualTo: args['team_name'])
                .where('batting.status', isEqualTo: 'Not Out')
                .where(FieldPath.documentId, whereNotIn: args['batters_names'])
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
              } else if (doc!.length == 0) {
                return Center(
                  child: Text(
                    'No Batsman',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: doc.length, // removed null !
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
                            return Center();
                          } else {
                            return ListTile(
                              onTap: () {
                                player_info_box.write('player', {
                                  'player_name': data['player_name'],
                                  'imgurl': data['imgurl'],
                                  'batting_style': data['batting_style'],
                                  'player_id': data.id.toString(),
                                  'team_name': args['team_name'].toString(),
                                }).then((value) {
                                  player_info_box.write('isselected', true);
                                  print(player_info_box.read('player'));
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
                                data['batting_style'],
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
