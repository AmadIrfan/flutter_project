import 'package:cached_network_image/cached_network_image.dart';
import '/features/my%20matches/selectopeners.dart';
import '/features/my%20matches/virtual_coin.dart';
import '/res/components/customtaost.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MatchToss extends StatefulWidget {
  const MatchToss({Key? key}) : super(key: key);

  @override
  _MatchTossState createState() => _MatchTossState();
}

class _MatchTossState extends State<MatchToss> {
  String firstTeamName = "First Team Name";
  String secondTeamName = "Second Team Name";
  String firstTeamLogo =
      "http://greenacrescricket.co.uk/wp-content/uploads/2016/10/profile-images.jpg"; // dummy Logo by team 1
  String secondTeamLogo =
      "http://greenacrescricket.co.uk/wp-content/uploads/2016/10/profile-images.jpg"; // dummy logo by team 2
  int _isSelectedTeam = 0;
  int _selectedRadio = 0;

  final match_info_box = GetStorage('Match_Info');

  @override
  void initState() {
    super.initState();
    setState(() {
      firstTeamName = match_info_box.read('team1info')['team_name'];
      firstTeamLogo = match_info_box.read('team1info')['imgurl'];
      secondTeamName = match_info_box.read('team2info')['team_name'];
      secondTeamLogo = match_info_box.read('team2info')['imgurl'];
    });
  }

// Custom Image Button
  Widget customImageButton(teamName, teamLogo, onPressedFunc, isSelected) {
    return MaterialButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage: CachedNetworkImageProvider(teamLogo),
            child: Icon(
              Icons.group,
              color: Colors.white,
              size: 45.0,
            ),
          ),
          const SizedBox(height: 15),
          Text(teamName, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      onPressed: onPressedFunc,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isSelected, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

// Custom Radio Button
  Widget customRadioButton(String title, int value, onChangedFunc) {
    return RadioListTile(
      contentPadding: const EdgeInsets.only(top: 5, right: 0, left: 0),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      groupValue: _selectedRadio,
      onChanged: onChangedFunc,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Create Match",
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w500),
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
      body: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Container(
          height: heightSize,
          width: widthSize,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                height: heightSize * 0.1,
                child: const Text(
                  "Toss",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have coin? "),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const VirtualCoin());
                          },
                          child: const Text(
                            "Virtual Toss",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WHO WON THE TOSS?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Divider(
                            thickness: 1.0,
                          ),
                          SizedBox(
                              height: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: customImageButton(
                                        firstTeamName, firstTeamLogo, () {
                                      setState(() {
                                        _isSelectedTeam = 1;
                                      });
                                    },
                                        (_isSelectedTeam == 1)
                                            ? Colors.teal
                                            : Colors.transparent),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: customImageButton(
                                        secondTeamName, secondTeamLogo, () {
                                      setState(() {
                                        _isSelectedTeam = 2;
                                      });
                                    },
                                        (_isSelectedTeam == 2)
                                            ? Colors.teal
                                            : Colors.transparent),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WON THE TOSS & ELECTED TO?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Divider(
                            thickness: 1.0,
                          ),
                          customRadioButton("Batting", 1, (newValue) {
                            setState(() {
                              _selectedRadio = newValue;
                              print(_selectedRadio);
                            });
                          }),
                          const Divider(
                            thickness: 1.0,
                          ),
                          customRadioButton("Fielding", 2, (newValue) {
                            setState(() {
                              _selectedRadio = newValue;
                              print(_selectedRadio);
                            });
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          fixedSize: Size(110, 48)),
                      onPressed: () {
                        var toss_won_team = '';
                        var toss_decision = '';
                        if (_isSelectedTeam != 0) {
                          if (_selectedRadio != 0) {
                            if (_isSelectedTeam == 1) {
                              toss_won_team = firstTeamName;
                            } else if (_isSelectedTeam == 2) {
                              toss_won_team = secondTeamName;
                            }
                            if (_selectedRadio == 1) {
                              toss_decision = 'Batting';
                            } else if (_selectedRadio == 2) {
                              toss_decision = 'Fielding';
                            }
                            match_info_box.write('toss', {
                              'toss_winner_team': toss_won_team,
                              'toss_decision': toss_decision,
                            }).then((value) {
                              Get.to(
                                () => select_openers(),
                                transition: Transition.rightToLeft,
                                arguments: {
                                  'inning_no': 'inning1',
                                  'match_id': '',
                                  'team1_id': '',
                                  'team2_id': '',
                                },
                              );
                            });
                          } else {
                            customtoast('Toss decision required');
                            //toss decision
                          }
                        } else {
                          customtoast('Select Team');
                          //select team
                        }
                      },
                      child: Text('Next')),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

// Container(
//                 height: heightSize / 10,
//                 color: Colors.white,
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     customMaterialButton("Back", Icons.arrow_back_rounded, () {
//                       Get.to(() => const MatchSettings());
//                     }),
//                     Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: customMaterialButton(
//                             "Create Match", Icons.create_outlined, () {
//                           Get.to(() => select_openers());
//                         })),
//                   ],
//                 ),
//               ),