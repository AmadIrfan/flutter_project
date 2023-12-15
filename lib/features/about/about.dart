import 'package:flutter/material.dart';
import '/features/about/team_scorer.dart';
import '/features/about/term_of_use.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({Key? key}) : super(key: key);

  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: Text(
            "About",
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
        body: Center(
            child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.height * 0.33,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Scorer Edge for\nAndroid\n",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
            ),
            Text('Version',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20.0,
                )),
            Text(
              '1.0.0\n\nScorer Edge for Android is built using open source software:\nlicenses.\n\nAll rights reserved.\n',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(
            //         (MaterialPageRoute(builder: (context) => Team_scorer())));
            //   },
            //   child: Text(
            //     'Team Scorer Edge \n',
            //     style: TextStyle(
            //       color: Colors.teal,
            //       fontSize: 18.0,
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  (MaterialPageRoute(
                    builder: (context) => const term_of_use(),
                  )),
                );
              },
              child: const Text(
                'Terms of Use',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18.0,
                ),
              ),
            )
          ]),
        )));
  }
}
