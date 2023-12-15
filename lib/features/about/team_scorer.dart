// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Team_scorer extends StatefulWidget {
  const Team_scorer({Key? key}) : super(key: key);

  @override
  _Team_scorerState createState() => _Team_scorerState();
}

class _Team_scorerState extends State<Team_scorer> {
  _createEmail()async{
   final Uri params =Uri(
     scheme: 'mailto',
     path: 'cricket.scorer1123@gmail.com',
   );
  launch(params.toString());
  }
  Widget customgrid(name, title, image) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          foregroundImage: AssetImage(image),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Text(name,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16.0,
              )),
        ),
        Text(title,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16.0,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: Text(
            "Team",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView(
            children: [
              Center(
                child: Text('TEAM',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    )),
              ),
              Text('SCORER EDGE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  controller: ScrollController(keepScrollOffset: false),
                  children: [
                    customgrid("Ahtsham Mehboob", "Flutter Developer",
                        "assets/images/images (43).jpeg"),
                    customgrid("Sami Ullah", "Flutter Developer",
                        "assets/images/images (43).jpeg"),
                    customgrid("Fizza Chauhdary", "Flutter Developer",
                        "assets/images/images (4).png"),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile( 
                        onTap: () {
                          _createEmail();
                        },
                     enabled: true,
                        leading: Image(image: AssetImage('assets/images/th.jpg'),
                        color: null,
                        fit: BoxFit.cover,
                        alignment:Alignment.center,
                        width: 37,
                        height: 27,), 
                        // ImageIcon(
                        //   AssetImage("images/th.jpg",))
                          
                        
                        title: Text(
                          "Contact us",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[700],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
