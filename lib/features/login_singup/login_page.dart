import '/features/login_singup/controllers/auth_controller.dart';
import '/features/login_singup/wavy_design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../res/components/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WavyDesign2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: heightSize * 75 / 100,
                  decoration: const BoxDecoration(
                    color: Color(0x22009688),
                  ),
                ),
              ),
              ClipPath(
                clipper: WavyDesign3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: heightSize * 75 / 100,
                  decoration: const BoxDecoration(
                    color: Color(0x44009688),
                  ),
                ),
              ),
              ClipPath(
                clipper: WavyDesign1(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/scorerEdgeLogo.png',
                            width: widthSize * 40 / 100,
                            height: heightSize * 20 / 100),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "Scorer Edge",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: heightSize * 5 / 100),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: heightSize * 75 / 100,
                  decoration: const BoxDecoration(
                    color: Color(0xff009688),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  _authController.signInWithGoogle();
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      customText(
                          title: 'Continue with Google',
                          fontsize: 20.0,
                          fontweight: FontWeight.w500,
                          fontcolor: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.5.h,
              )
            ],
          )),
        ],
      ),
    );
  }
}
