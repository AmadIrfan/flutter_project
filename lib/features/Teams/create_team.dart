import 'dart:io';

import '/features/Teams/team_controller.dart';
import '/features/Teams/team_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/res/components/file_picker.dart';

class create_team extends StatefulWidget {
  final TeamModel teamData;
  final bool isedit;
  final String teamid;
  const create_team(
      {Key? key,
      required this.teamData,
      required this.isedit,
      required this.teamid})
      : super(key: key);

  @override
  _create_teamState createState() => _create_teamState();
}

Widget textfeilddesign(bordername, _controller, _hinttext,
    {max_length = 250, min_length = 1}) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: TextFormField(
        controller: _controller,
        cursorColor: Colors.green,
        validator: (val) {
          if (val!.isEmpty) {
            return 'required';
          }
          if (val.length < min_length) {
            return 'Minimum length should be $min_length characters';
          }
          if (val.length > max_length) {
            return 'Max Length exceeding';
          }
        },
        // maxLength: max_length,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: _hinttext,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(4)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          labelText: bordername,
          labelStyle: TextStyle(
              color: Colors.grey[900],
              fontSize: 18.0,
              fontWeight: FontWeight.w600),
        )),
  );
}

class _create_teamState extends State<create_team> {
  // var args = Get.arguments;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _teamname = TextEditingController();
  TextEditingController _teamlocation = TextEditingController();
  TextEditingController _teamshortname = TextEditingController();

  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        // currentuserid = currentUser.uid;
        _teamname.text = widget.teamData.teamName;
        _teamlocation.text = widget.teamData.teamLocation;
        _teamshortname.text = widget.teamData.teamShortName;
        // downloadURL = args[0]['img_url'];
      });
    }
  }

  final TeamController controller = Get.put(TeamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.isedit ? 'Edit Team' : 'Create Team',
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: controller.inprogress.value
                ? CircularProgressIndicator(
                    color: Colors.teal,
                  )
                : IconButton(
                    onPressed: controller.inprogress.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                controller.inprogress.value = true;
                              });
                              controller.addteam(
                                  _teamname.text,
                                  _teamlocation.text,
                                  _teamshortname.text,
                                  widget.isedit,
                                  widget.teamid);
                            }
                          },
                    icon: Icon(
                      Icons.check,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              filepicker().then((selectedpath) {
                if (selectedpath.toString().isNotEmpty) {
                  // setState(() {
                  controller.filepath.value = selectedpath;
                  controller.IsSelected.value = true;
                  // uploadFile(selectedpath.toString());
                  // });
                }
              });
            },
            child: Obx(
              () => controller.IsSelected.value
                  ? CircleAvatar(
                      radius: 50.0,
                      foregroundImage:
                          FileImage(File(controller.filepath.value)),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      radius: 50.0,
                      foregroundImage:
                          CachedNetworkImageProvider(widget.teamData.imgUrl),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black26,
                    ),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: textfeilddesign(
                      "Team Name", _teamname, 'Star Cricket Club',
                      min_length: 3)),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: textfeilddesign(
                      "Team Location", _teamlocation, 'Bhakkar')),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: textfeilddesign(
                      "Team Short Name", _teamshortname, 'SCC',
                      max_length: 3)),
            ],
          ),
        ),
        Spacer(),
      ]),
    );
  }
}
