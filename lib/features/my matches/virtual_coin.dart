import 'dart:math';
import 'package:flutter/material.dart';

class VirtualCoin extends StatefulWidget {
  const VirtualCoin({Key? key}) : super(key: key);

  @override
  _VirtualCoinState createState() => _VirtualCoinState();
}

class _VirtualCoinState extends State<VirtualCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  stopRotation() {
    animationController.stop();
  }

  startRotation() {
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  int coinNumber = 0;

  void coinSate() {
    setState(() {
      coinNumber = 0;
    });
    startRotation();
    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() {
        if (animationController.isAnimating) {
          coinNumber = Random().nextInt(2) + 1;
        }
      });
    });
  }

  Widget customText(headOrtail) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: headOrtail,
          style: const TextStyle(
              height: 2,
              color: Colors.teal,
              fontSize: 30,
              fontWeight: FontWeight.w600),
          children: const <TextSpan>[
            TextSpan(
                text: "\n Tap on the coin to flip again",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            // TextSpan(
            //     text: "\n Head or Tail",
            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff424242),
        elevation: 0,
        title: const Text(
          'Coin',
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            (coinNumber == 0)
                ? Text(
                    "Head or Tail?",
                    style: TextStyle(
                        height: 3,
                        color: Colors.teal,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  )
                : (coinNumber == 1)
                    ? customText("It's Head")
                    : customText("It's Tail"),
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () {
                coinSate();
              },
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: AnimatedBuilder(
                    animation: animationController,
                    child: Image(
                      image: AssetImage('assets/coin/coin$coinNumber.png'),
                    ),
                    builder: (BuildContext context, Widget? _widget) {
                      return Transform.rotate(
                        angle: animationController.value * 12.52,
                        child: _widget,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
