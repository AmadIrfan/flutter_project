import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;

  Delegate(this.backgroundColor, this._title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          _title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class overs extends StatefulWidget {
  const overs({Key? key}) : super(key: key);

  @override
  _oversState createState() => _oversState();
}

class _oversState extends State<overs> {
  var args = Get.arguments;
  List numlist = [0, 1, 2, 3, 4, 5, 6, 'w', 0, 1, 2, 3, 4, 5, 6, 'w'];

  Widget _customcircleavatar(_txt, extra) {
    Color? circlecolor;
    if (_txt == '4') {
      circlecolor = Colors.green;
    } else if (_txt == '6') {
      circlecolor = Colors.purple;
    } else if (_txt.toString().toLowerCase() == 'w') {
      circlecolor = Colors.red;
    } else {
      circlecolor = Colors.blueGrey[800];
    }
    if (extra.toString() != ''){
      circlecolor = Colors.yellow[700];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 15.0,
              backgroundColor: circlecolor,
              child: Text(
                _txt,
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
              extra.toString(),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget customlisttile(Cleading, Ctitle, csubtitle) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListTile(
            leading: Text(
              Cleading,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                Ctitle,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: csubtitle,
            ),
          ),
        ),
        // Divider(
        //   indent: 115,
        //   thickness: 1.5,
        // ),
      ],
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
                return ExpansionTile(
                    collapsedBackgroundColor: Colors.grey[200],
                      // backgroundColor: Colors.teal[300],
                      collapsedTextColor: Colors.black,
                  title: Text(
                    docs![index]['batting_team'] + '\t' + "(${docs[index].id.toUpperCase()})",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      // color: Colors.black,
                    ),
                  ),
                  children: [
                    docs[index]['oversdata'].length == 0 ?
                    Center(
                      child: Text(
                        'No Overs Data',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    )
                    :
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: docs[index]['oversdata'].length,
                      itemBuilder: (context, overindex){
                            Map over = docs[index]['oversdata'][overindex.toString()];
                        return customlisttile(
                              "Over " + over['over_no'].toString()  + "\n" + over['total_runs'].toString() +" runs",
                              over['Bowler_name'] +" to " + over['Batter1_name'] + " ," + over['Batter2_name'],
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: over['every_ball'].length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, ballindex) {
                                      return _customcircleavatar(
                                          over['every_ball'][ballindex].toString().split('.')[0], over['every_ball'][ballindex].toString().split('.')[1]);
                                    },
                                  ),
                                ),
                              ),
                            );
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
  }
}




// SliverStickyHeader(
//           header: Container(
//             height: 60.0,
//             color: Colors.white,
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'India',
//               style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w500),
//             ),
//           ),
//           sliver: SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index1) {
//                 return customlisttile(
//                   "Over 1\n11 runs",
//                   "Fawad to Rana , player1",
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.05,
//                       child: ListView.builder(
//                           itemCount: numlist.length,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) {
//                             return customcircleavatar(numlist[index].toString());
//                           },
//                         ),
//                     ),
//                   ),
//                 );
//               },
//               childCount: 1,
//             ),
//           ),
//         ),
//  Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
            
//             customlisttile("Over 1\n11 runs", "Fawad to Rana , player1", 
//             Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Wrap(children: [
//                 customcircleavatar('0',), customcircleavatar('1',),customcircleavatar('6',),
//                 customcircleavatar('4',),
//                 ],
//               ),
//             ),
//           ),
//              Divider(
//                indent: 115,
//                thickness: 1.5,),
//                 Padding(
//                padding: const EdgeInsets.only(left: 15, top: 10),
//                child: Text(
//                   "India",
//                  style: TextStyle( 
//                    color:Colors.black,
//                    fontWeight: FontWeight.w500,
//                    fontSize: 16),
//                ),
//              ),
//               customlisttile("Over 1\n10 runs", "Fawad to Rana , palyer2", 
//             Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Wrap(children: [
//                 customcircleavatar('0',),customcircleavatar('1',),customcircleavatar('6',),
//                 customcircleavatar('4',), customcircleavatar('2',), customcircleavatar('4',),
//                  customcircleavatar('3',), customcircleavatar('W',),
//                 ],
//               ),
//             ),
//           ),
//            Divider(
//                indent: 115,
//                thickness: 1.5,),
//        ],),