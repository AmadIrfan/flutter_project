// ignore_for_file: library_private_types_in_public_api

import '/features/my%20matches/toss.dart';
import '/res/components/customtaost.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MatchDetails extends StatefulWidget {
  const MatchDetails({Key? key}) : super(key: key);

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  var ball_type = '';
  final match_info_box = GetStorage('Match_Info');
  final TextEditingController _groundname = TextEditingController();
  final TextEditingController _overs = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget textfeilddesign(bordername, keytype, _controller) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: TextFormField(
            controller: _controller,
            keyboardType: keytype,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.isEmpty) {
                return 'required';
              }
              return null;
            },
            cursorColor: Colors.green,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(4)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              labelText: bordername,
              labelStyle: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  Widget createbutton(buttonname, onpress) {
    return GestureDetector(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(top: 80),
          child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.teal,
                  fixedSize: Size(175, 55)),
              onPressed: onpress,
              child: Text(
                buttonname,
              )),
        ),
      ]),
    );
  }

  Widget sheetlisttile(tilename) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ball_type = tilename;
        });
        Navigator.pop(context);
      },
      child: ListTile(
        title: Text(
          tilename,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
    );
  }

  DateTime pickedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Create Match",
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w500),
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
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: Text(
                "Match Details",
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 28.0,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                          ),
                          child: textfeilddesign("Ground Name",
                              TextInputType.emailAddress, _groundname)),
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                          ),
                          child: textfeilddesign(
                              "No. of Overs", TextInputType.number, _overs)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(18.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4)),
                  child: ListTile(
                    dense: true,
                    onTap: () {
                      showModalBottomSheet(
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    "Ball type",
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w700,
                                        fontSize: 19),
                                  ),
                                ),
                                sheetlisttile("Tennis Ball"),
                                sheetlisttile('Leather Ball'),
                                sheetlisttile('Hard Ball'),
                                sheetlisttile('Other')
                              ],
                            );
                          });
                    },
                    title: Text(
                      "Ball Type",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w500,
                          fontSize: 19),
                    ),
                    subtitle: Text(
                      ball_type,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.425,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        tileColor: Colors.grey[200],
                        dense: true,
                        onTap: _pickedDate,
                        title: Text(
                          "Date",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          pickedDate.toLocal().toString().split(' ')[0],
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        tileColor: Colors.grey[200],
                        dense: true,
                        onTap: _pickedTime,
                        title: Text(
                          "Time",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          time.format(context),
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.teal,
                      fixedSize: Size(110, 48)),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      if (ball_type.isNotEmpty) {
                        match_info_box.write('match_details', {
                          'ground_name': _groundname.text,
                          'overs': _overs.text,
                          'ball_type': ball_type,
                          'date': pickedDate.toLocal().toString().split(' ')[0],
                          'time': time.format(context),
                        }).then((value) {
                          // _groundname.clear();
                          // _overs.clear();
                          // ball_type = '';
                          // pickedDate = DateTime.now();
                          // time=TimeOfDay.now();
                          Get.to(
                            () => MatchToss(),
                            transition: Transition.rightToLeft,
                          );
                        });
                      } else {
                        customtoast('Ball type required');
                      }
                    }
                  },
                  child: Text('Next')),
            ),
          ]),
        ],
      ),
    );
  }

  _pickedDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                  secondary: Colors.grey,
                  surface: Colors.black12),
            ),
            child: child!);
      },
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickedTime() async {
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                  primary: Colors.grey, surface: Color(0xff303030)),
            ),
            child: child!);
      },
    );
    if (t != null)
      setState(() {
        time = t;
      });
  }
}
