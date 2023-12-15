import '/features/Scoring%20Page/wicket_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PlayerOut extends StatefulWidget {
  const PlayerOut({Key? key}) : super(key: key);

  @override
  _PlayerOutState createState() => _PlayerOutState();
}

class _PlayerOutState extends State<PlayerOut> {
  int _selectedRadio = 0;
  var args = Get.arguments;
  final player_info_box = GetStorage('player_info');

// Customized Radio ListTile
  Widget customRadioButton(iconName, String title, int value, onChangedFunc) {
    return RadioListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      tileColor: Colors.white,
      secondary: CircleAvatar(
        backgroundColor: Colors.teal,
        backgroundImage: AssetImage("assets/playerOut_icons/$iconName.png"),
      ),
      contentPadding: const EdgeInsets.fromLTRB(15, 6, 10, 6),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
      value: value,
      groupValue: _selectedRadio,
      onChanged: onChangedFunc,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  // custom sized box
  Widget customSizedBox = const SizedBox(
    height: 12,
  );

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Wicket",
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF424242),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: ListView(
                children: [
                  customRadioButton("bowled", "Bowled", 1, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                  customSizedBox,
                  customRadioButton("caught", "Caught", 2, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                  // customSizedBox,
                  // customRadioButton("caughtBehind", "Caught Behind", 3,
                  //     (newValue) {
                  //   setState(() {
                  //     _selectedRadio = newValue;
                  //   });
                  // }),
                  customSizedBox,
                  customRadioButton("stumped", "Stumped", 4, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                  customSizedBox,
                  customRadioButton("runOut", "Run Out", 5, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                  customSizedBox,
                  customRadioButton("lbw", "LBW", 6, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                  customSizedBox,
                  customRadioButton("hitWicket", "Hit Wicket", 7, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                  // customSizedBox,
                  // customRadioButton("retiredHurt", "Retired Hurt", 8,
                  //     (newValue) {
                  //   setState(() {
                  //     _selectedRadio = newValue;
                  //   });
                  // }),
                  // customSizedBox,
                  // customRadioButton("retiredOut", "Retired Out", 9, (newValue) {
                  //   setState(() {
                  //     _selectedRadio = newValue;
                  //   });
                  // }),
                  customSizedBox,
                  customRadioButton("retired", "Retired", 10, (newValue) {
                    setState(() {
                      _selectedRadio = newValue;
                    });
                  }),
                ],
              ),
            ),
          ),
          Container(
            width: widthSize,
            height: heightSize * 8.5 / 100,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
              onPressed: () {
                // Swicth based on wicket type
                switch (_selectedRadio) {
                  case 1:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                  case 2:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                  // case 3:
                  // Get.to(() => WicketType(wicketType: _selectedRadio));
                  // break;
                  case 4:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                  case 5:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                  case 6:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                  case 7:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                  // case 8:
                  //   Get.to(() => WicketType(wicketType: _selectedRadio));
                  //   break;
                  // case 9:
                  //   Get.to(() => WicketType(wicketType: _selectedRadio));
                  //   break;,

                  case 10:
                    Get.to(
                      () => WicketType(wicketType: _selectedRadio),
                      arguments: {
                        'inning_no': args['inning_no'],
                        'match_id': args['match_id'],
                        'team_name': args['team_name'],
                        'batters_names': args['batters_names'],
                      },
                    );
                    break;
                }
              },
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
