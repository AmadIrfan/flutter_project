import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineupsPage extends StatefulWidget {
  const LineupsPage({ Key? key }) : super(key: key);

  @override
  _LineupsPageState createState() => _LineupsPageState();
}

class _LineupsPageState extends State<LineupsPage> {
  var team_playerids = [];
  String currentuserid = '';
  var args = Get.arguments;
  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        Map playerids = args['players_ids'];
        playerids.forEach((key, plvalue) {
          team_playerids.add(plvalue);
        });
        print(team_playerids);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          
        });
      },
      color: Colors.teal,
      backgroundColor: Colors.white,
      strokeWidth:2.0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(args['team_name'],
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('players')
              .doc(args['user_id'])
              .collection(args['team_name'])
              .where(FieldPath.documentId , whereIn : team_playerids)
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
                      'No player',
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
                    thickness: 1.0,
                    height: 5.0,
                    indent: 70.0,
                  );
                },
                itemCount: data.length, // removed null !
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ListTile(
                    onTap: () {
                     
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      foregroundImage:
                          CachedNetworkImageProvider(ds['imgurl'].toString()),
                      child: Text(
                        ds['player_name']
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
                      ds['player_name'],
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // trailing: Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 25.0,
                    // ),
                    subtitle: Text(
                      ds['player_role'],
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