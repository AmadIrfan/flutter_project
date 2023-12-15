import 'package:flutter/material.dart';

class Commentry extends StatefulWidget {
  const Commentry({Key? key}) : super(key: key);

  @override
  _CommentryState createState() => _CommentryState();
}

class _CommentryState extends State<Commentry> {

  List commentry_list = [
    {
      'runs' : '0',
      'comment' : 'Rana to usman, no ball, no runs',
      'ball' : '0.4' ,
      'isextra' : true,
    },
    {
      'runs' : '1',
      'comment' : 'Rana to usman, no runs',
      'ball' : '0.5' ,
      'isextra' : false,
    },
    {
      'runs' : '1',
      'comment' : 'Rana to usman, wide ball, 1 run',
      'ball' : '1.0' ,
      'isextra' : true,
    },
  ];

  Widget _customcircleavatar(_txt, [bool isextra = false]) {
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
    if (isextra) {
      circlecolor = Colors.yellow[700];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
    );
  }

  Widget custom_commentry(ball_text, leading_text, title_text, [bool extra = false]){
    return ListTile(
          leading: _customcircleavatar(leading_text, extra),
          title:  Text(
          title_text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          ball_text,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey[300],
                        ),
                    child: TabBar(
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      indicatorWeight: 0.0,
                      physics: BouncingScrollPhysics(),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.teal,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: '1st Innings'),
                        Tab(text: '2nd Innings'),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.65, //height of TabBarView
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                          ),
                      child: TabBarView(children: <Widget>[
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.builder(
                            itemCount: commentry_list.length,
                            itemBuilder: (context, index){
                              return custom_commentry(commentry_list[index]['ball'], commentry_list[index]['runs'], commentry_list[index]['comment'], commentry_list[index]['isextra']);
                            },
                          ),
                        ),
                        Container(
                          child: ListView.builder(
                            itemCount: commentry_list.length,
                            itemBuilder: (context, index){
                              return custom_commentry(commentry_list[index]['ball'], commentry_list[index]['runs'], commentry_list[index]['comment'], commentry_list[index]['isextra']);
                            },
                          ),
                        ),
                      ]))
                ]),
          ),
        ),
      ],
    );
  }
}
