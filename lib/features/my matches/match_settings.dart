import '/features/my%20matches/toss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MatchSettings extends StatefulWidget {
  const MatchSettings({Key? key}) : super(key: key);

  @override
  _MatchSettingsState createState() => _MatchSettingsState();
}

class _MatchSettingsState extends State<MatchSettings> {
  bool _isChecked1 = true;
  bool _isChecked2 = true;
  bool _isEnabled1 = true;
  final TextEditingController _wideRuns = TextEditingController(text: '1');
  bool _isChecked3 = true;
  bool _isChecked4 = true;
  bool _isEnabled2 = true;
  final TextEditingController _noBallRuns = TextEditingController(text: '1');

  final match_info_box = GetStorage('Match_Info');

// Custom CheckBox
  Widget customCheckBox(leadingText, isChecked, onChangeFunc) {
    return Theme(
      data: ThemeData(
          checkboxTheme: const CheckboxThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
      )),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
        activeColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.grey[100],
        title: Text(
          leadingText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        value: isChecked,
        onChanged: onChangeFunc,
      ),
    );
  }

// Custom TextField
  Widget customTextField(labelText, isEnabled, controllerName, onSavedFunc) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: TextFormField(
        enabled: isEnabled,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
          labelText: labelText,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        controller: controllerName,
        onSaved: onSavedFunc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Create Match",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff424242),
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
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                height: heightSize * 0.1,
                child: const Text(
                  "Match Setting",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                  child: ListView(
                children: [
                  customCheckBox('Wide', _isChecked1, (value) {
                    setState(() {
                      _isChecked1 = !_isChecked1;
                      _isEnabled1 = !_isEnabled1;
                    });
                  }),
                  SizedBox(
                    height: heightSize * 3 / 100,
                  ),
                  customCheckBox(
                    'Re-Ball for Wide',
                    _isChecked2,
                    _isEnabled1
                        ? (value) {
                            setState(() {
                              _isChecked2 = !_isChecked2;
                            });
                          }
                        : null,
                  ),
                  SizedBox(
                    height: heightSize * 3 / 100,
                  ),
                  customTextField(
                    "Wide Runs",
                    _isEnabled1,
                    _wideRuns,
                    (value) {
                      _wideRuns.text = value!;
                    },
                  ),
                  SizedBox(
                    height: heightSize * 3 / 100,
                  ),
                  customCheckBox('No Ball', _isChecked3, (value) {
                    setState(() {
                      _isChecked3 = !_isChecked3;
                      _isEnabled2 = !_isEnabled2;
                    });
                  }),
                  SizedBox(
                    height: heightSize * 3 / 100,
                  ),
                  customCheckBox(
                    'Re-Ball for No Ball',
                    _isChecked4,
                    _isEnabled2
                        ? (value) {
                            setState(() {
                              _isChecked4 = !_isChecked4;
                            });
                          }
                        : null,
                  ),
                  SizedBox(
                    height: heightSize * 3 / 100,
                  ),
                  customTextField(
                    "No Ball Runs",
                    _isEnabled2,
                    _noBallRuns,
                    (value) {
                      _noBallRuns.text = value!;
                    },
                  ),
                ],
              )),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          fixedSize: Size(110, 48)),
                      onPressed: () {
                        match_info_box.write('match_settings', {
                          'wide': _isEnabled1,
                          're_ball_for_wide': _isChecked2,
                          'wide_runs': _wideRuns.text,
                          'no_ball': _isEnabled2,
                          're_ball_for_no_ball': _isChecked4,
                          'no_ball_runs': _noBallRuns.text,
                        }).then((value) {
                          Get.to(
                            () => MatchToss(),
                            transition: Transition.rightToLeft,
                          );
                        });
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
