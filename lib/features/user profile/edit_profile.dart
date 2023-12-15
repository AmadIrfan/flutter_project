import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import '/features/user%20profile/profile_controller.dart';
import '/features/user%20profile/user_model.dart';
import '/res/components/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import '../../res/components/willpop.dart';
import '../home/home_page.dart';

class Editprofile extends StatefulWidget {
  final UserModel userData;
  final bool isedit;
  const Editprofile({Key? key, required this.userData, required this.isedit})
      : super(key: key);

  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _displayname = TextEditingController();
  TextEditingController _countryname = TextEditingController();
  TextEditingController _cityname = TextEditingController();

  String currentuserid = '';

  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        _displayname.text = widget.userData.UserName;
        _countryname.text = widget.userData.UserCountry;
        _cityname.text = widget.userData.UserCity;
      });
    }
  }

  Widget customtextformfield(lbltext, _controller, isreadonly) {
    // _controller.text = profileargs[0][_controllername].toString().trim();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_val) {
            if (_val!.isEmpty) {
              return 'required';
            }
            return null;
          },
          readOnly: isreadonly,
          controller: _controller,
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: lbltext,
            // alignLabelWithHint: false,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            filled: true,
            enabled: true,
            fillColor: Color(0xFFEEECEC),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController _profilecontroller = Get.put(ProfileController());
    return WillPopScope(
      onWillPop: () async {
        if (widget.isedit) {
          Navigator.pop(context);
        } else {
          onWillPop;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.isedit,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            widget.isedit ? 'Edit Profile' : 'Add Profile',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              if (widget.isedit) {
                Navigator.pop(context);
              } else {
                onWillPop;
              }
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          actions: [
            _profilecontroller.isworking.value
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                      // valueColor: AlwaysStoppedAnimation(Colors.red),
                      strokeWidth: 4.0,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _profilecontroller.isworking.value = true;
                          // if(path.isEmpty){
                          //   path = profileargs[0]['_profilepic'].toString();
                          // }
                        });
                        _profilecontroller.addUser(_displayname.text,
                            _countryname.text, _cityname.text, widget.isedit);
                      }
                    },
                    icon: Icon(Icons.check, color: Colors.black),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    filepicker().then((selectedpath) {
                      if (selectedpath.toString().isNotEmpty) {
                        setState(() {
                          _profilecontroller.path.value = selectedpath;
                          _profilecontroller.IsSelected.value = true;
                          // uploadFile(selectedpath.toString());
                        });
                      }
                    });
                  },
                  child: _profilecontroller.IsSelected.value
                      ? CircleAvatar(
                          radius: 50.0,
                          foregroundImage:
                              FileImage(File(_profilecontroller.path.value)),
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          foregroundImage: CachedNetworkImageProvider(
                              widget.userData.UserImage.toString()),
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.black26,
                        ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customtextformfield('Display Name', _displayname, false),
                    // customtextformfield('Email', _email, true),
                    customtextformfield('Country', _countryname, false),
                    customtextformfield('City', _cityname, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
