import 'package:cloud_firestore/cloud_firestore.dart';
import '/res/components/customdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreCard extends StatefulWidget {
  const ScoreCard({Key? key}) : super(key: key);

  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  var args = Get.arguments;
  List<TableRow> bowler_row = [];
  List<TableRow> batter_row = [];
  Widget _customtext(txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        txt,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
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
          var docs = snapshot.data?.docs;
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
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              itemCount: docs?.length,
              itemBuilder: (context, index) {
                var ds = docs?[index];
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('scoring')
                        .doc(args['user_id'])
                        .collection('my_matches')
                        .doc(args['match_id'])
                        .collection('teams_players')
                        .snapshots(),
                    builder: (context, players_snapshot) {
                      batter_row = [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.teal[100],
                          ),
                          children: [
                            _customtext('Batsman'),
                            _customtext('R'),
                            _customtext('B'),
                            _customtext('4s'),
                            _customtext('6s'),
                            _customtext('SR'),
                          ],
                        ),
                      ];
                      bowler_row = [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.teal[100],
                          ),
                          children: [
                            _customtext('Bowler'),
                            _customtext('O'),
                            _customtext('M'),
                            _customtext('R'),
                            _customtext('W'),
                            _customtext('ER'),
                          ],
                        ),
                      ];
                      players_snapshot.data?.docs.forEach((doc) {
                        if (doc['team_name'] == ds!['batting_team']) {
                          if (doc['batting']['total_runs'] > 0 ||
                              doc['batting']['total_balls'] > 0) {
                            batter_row.add(
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc['player_name'],
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        Text(
                                          doc['batting']['status'],
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _customtext(
                                      doc['batting']['total_runs'].toString()),
                                  _customtext(
                                      doc['batting']['total_balls'].toString()),
                                  _customtext(
                                      doc['batting']['fours'].toString()),
                                  _customtext(
                                      doc['batting']['sixes'].toString()),
                                  _customtext(
                                      doc['batting']['strike_rate'].toString()),
                                ],
                              ),
                            );
                          }
                        } else {
                          if (int.parse(doc['bowling']['overs']
                                      .toString()
                                      .split('.')[0]) >
                                  0 ||
                              int.parse(doc['bowling']['overs']
                                      .toString()
                                      .split('.')[1]) >
                                  0) {
                            bowler_row.add(
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      doc['player_name'],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                  _customtext(
                                      doc['bowling']['overs'].toString()),
                                  _customtext(
                                      doc['bowling']['maiden'].toString()),
                                  _customtext(
                                      doc['bowling']['runs'].toString()),
                                  _customtext(
                                      doc['bowling']['wickets'].toString()),
                                  _customtext(doc['bowling']['economy_rate']
                                      .toString()),
                                ],
                              ),
                            );
                          }
                        }
                      });
                      batter_row.add(
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Extras (${ds!['Extra']['total_extras'].toString()})',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            _customtext('W\n' + ds['Extra']['wide'].toString()),
                            _customtext(
                                'Nb\n' + ds['Extra']['no_ball'].toString()),
                            _customtext(
                                'Lb\n' + ds['Extra']['leg_byes'].toString()),
                            _customtext('B\n' + ds['Extra']['byes'].toString()),
                            _customtext(''),
                          ],
                        ),
                      );
                      if (players_snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              // child: LinearProgressIndicator(

                              // ),
                              ),
                        );
                      } else {
                        return ExpansionTile(
                          collapsedBackgroundColor: Colors.grey[200],
                          backgroundColor: Colors.teal[300],
                          leading: _customtext(ds['batting_team']),
                          title: _customtext(
                              ds['Total']['total_score'].toString() +
                                  '/' +
                                  ds['Total']['total_wickets'].toString() +
                                  '(' +
                                  ds['Total']['total_overs'].toString() +
                                  '.' +
                                  ds['Total']['balls'].toString() +
                                  ')'),
                          // childrenPadding: EdgeInsets.all(10.0),

                          children: [
                            Table(
                              defaultColumnWidth: FlexColumnWidth(4.0),
                              columnWidths: {
                                0: FlexColumnWidth(9.0),
                                // 1: FlexColumnWidth(3.0),
                                // 2: FlexColumnWidth(3.0),
                                // 3: FlexColumnWidth(3.0),
                                // 4: FlexColumnWidth(3.0),
                                5: FlexColumnWidth(5.0),
                              },
                              children: batter_row,
                            ),
                            Table(
                              defaultColumnWidth: FlexColumnWidth(4.0),
                              columnWidths: {
                                0: FlexColumnWidth(9.0),
                                // 1: FlexColumnWidth(3.0),
                                // 2: FlexColumnWidth(3.0),
                                // 3: FlexColumnWidth(3.0),
                                // 4: FlexColumnWidth(3.0),
                                5: FlexColumnWidth(5.0),
                              },
                              children: bowler_row,
                            ),
                          ],
                        );
                      }
                    });
              },
            );
          }
        });
  }
}

//  TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.teal[100],
//                               ),
//                               children: [
//                                 _customtext('Batsman'),
//                                 _customtext('R'),
//                                 _customtext('B'),
//                                 _customtext('4s'),
//                                 _customtext('6s'),
//                                 _customtext('SR'),
//                               ],
//                             ),
//                             TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         ds['Batter1']['player_name'],
//                                         style: TextStyle(
//                                           fontSize: 16.0,
//                                           fontWeight: FontWeight.w800,
//                                           color: Colors.teal,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Not Out',
//                                         style: TextStyle(
//                                           fontSize: 13.0,
//                                           fontWeight: FontWeight.w800,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 _customtext(ds['Batter1']['total_runs'].toString()),
//                                 _customtext(
//                                     ds['Batter1']['total_balls'].toString()),
//                                 _customtext(ds['Batter1']['fours'].toString()),
//                                 _customtext(ds['Batter1']['sixes'].toString()),
//                                 _customtext(
//                                     ds['Batter1']['strike_rate'].toString()),
//                               ],
//                             ),
//                             TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         ds['Batter2']['player_name'],
//                                         style: TextStyle(
//                                           fontSize: 16.0,
//                                           fontWeight: FontWeight.w800,
//                                           color: Colors.teal,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Not Out',
//                                         style: TextStyle(
//                                           fontSize: 13.0,
//                                           fontWeight: FontWeight.w800,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 _customtext(ds['Batter2']['total_runs'].toString()),
//                                 _customtext(
//                                     ds['Batter2']['total_balls'].toString()),
//                                 _customtext(ds['Batter2']['fours'].toString()),
//                                 _customtext(ds['Batter2']['sixes'].toString()),
//                                 _customtext(
//                                     ds['Batter2']['strike_rate'].toString()),
//                               ],
//                             ),
//                             TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     'Extras (${ds['Extra']['total_extras'].toString()})',
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.teal,
//                                     ),
//                                   ),
//                                 ),
//                                 _customtext('W\n' + ds['Extra']['wide'].toString()),
//                                 _customtext(
//                                     'Nb\n' + ds['Extra']['no_ball'].toString()),
//                                 _customtext(
//                                     'Lb\n' + ds['Extra']['leg_byes'].toString()),
//                                 _customtext('B\n' + ds['Extra']['byes'].toString()),
//                                 _customtext(''),
//                               ],
//                             ),
//                             TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.teal[100],
//                               ),
//                               children: [
//                                 _customtext('Bowler'),
//                                 _customtext('O'),
//                                 _customtext('M'),
//                                 _customtext('R'),
//                                 _customtext('W'),
//                                 _customtext('ER'),
//                               ],
//                             ),
//                             TableRow(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     ds['Bowler']['player_name'],
//                                     style: TextStyle(
//                                       fontSize: 15.0,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.teal,
//                                     ),
//                                   ),
//                                 ),
//                                 _customtext(ds['Bowler']['overs'].toString()),
//                                 _customtext(ds['Bowler']['maiden'].toString()),
//                                 _customtext(ds['Bowler']['runs'].toString()),
//                                 _customtext(ds['Bowler']['wickets'].toString()),
//                                 _customtext(ds['Bowler']['economy_rate'].toString()),
//                               ],
//                             ),
                            // TableRow(
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //   ),
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Text(
                            //         'Usman',
                            //         style: TextStyle(
                            //           fontSize: 15.0,
                            //           fontWeight: FontWeight.w800,
                            //           color: Colors.teal,
                            //         ),
                            //       ),
                            //     ),
                            //     _customtext('0.5'),
                            //     _customtext('0'),
                            //     _customtext('10'),
                            //     _customtext('0'),
                            //     _customtext('18.00'),
                            //   ],
                            // ),