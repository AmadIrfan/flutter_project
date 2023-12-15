// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class term_of_use extends StatefulWidget {
  const term_of_use({Key? key}) : super(key: key);

  @override
  _term_of_useState createState() => _term_of_useState();
}

class _term_of_useState extends State<term_of_use> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          "Terms Of Use",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w500),
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
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.height * 0.4,
          // child: ScrollConfiguration(
          //   behavior: ,
          child: ListView(physics: BouncingScrollPhysics(), children: [
            Text("\nTerms of Use",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500)),
            Divider(
              thickness: 2,
            ),
            RichText(
                text: TextSpan(
              text: "\nPLEASE READ THESE TERMS OF USE CAREFULLY\n",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text:
                      "BY CONTINUING TO USE THE SOFTWARE YOU ARE CONFIRMING THAT YOU ACCEPT THESE TERMS OF USE AND YOU AGREE TO COMPLY WITH THEM. IF YOU DO NOT AGREE TO THESE TERMS OF USE YOU MUST NOT USE THE SOFTWARE.\n\n",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 19.0,
                  ),
                ),
                TextSpan(
                    text: "Privacy.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        " All personal information provided or obtained through the Apps will be kept secure and processed in accordance with our Privacy Statements & Policy. If you enter any personal information about any other person into the Scorer Edge App, it is your responsibility to ensure they understand how their information will be used..\n\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.0,
                    )),
                TextSpan(
                    text: "Ownership of materials.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        " The Apps, the design of them and the materials on them, or provided to you through them, are protected by copyright, trade mark and other intellectual property rights and laws throughout the world and are owned by, or are licensed to us and/or third parties.\n\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.0,
                    )),
                TextSpan(
                    text: "Availability.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        " These Apps are provided free of charge, as is and as available. We do not make any guarantee that they will be error free. We reserve the right to modify, suspend or withdraw the Apps or any of their features at any time without notice and without incurring any liability.\n\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.0,
                    )),
                TextSpan(
                    text: "Update and Change.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        "From time to time we may automatically update or change the Software to improve performance, enhance functionality, reflect changes to the operating system or address security issues. Alternatively, we may ask you to update the Software for these reasons\n\nIf you choose not to install such updates or if you opt out of automatic updates you may not be able to continue using the Software..\n\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.0,
                    )),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
