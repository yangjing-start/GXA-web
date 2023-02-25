import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'land.dart';
import 'sun.dart';
import 'tabs.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isFullSun = false;
  bool isDayMood = true;
  Duration _duration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isFullSun = true;
      });
    });
  }

  void changeMood(int activeTabNum) {
    if (activeTabNum == 0) {
      setState(() {
        isDayMood = true;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isFullSun = true;
        });
      });
    } else {
      setState(() {
        isFullSun = false;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isDayMood = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> lightBgColors = [
      Color(0xFF8C2480),
      Color(0xFFCE587D),
      Color(0xFFFF9485),
      if (isFullSun) Color(0xFFFF9D80),
    ];
    var darkBgColors = const [
      Color(0xFF0D1441),
      Color(0xFF283584),
      Color(0xFF376AB2),
    ];
    return AnimatedContainer(
      duration: _duration,
      curve: Curves.easeInOut,
      width: double.infinity,
      height: Get.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDayMood ? lightBgColors : darkBgColors,
        ),
      ),
      child: Stack(
        children: [
          Sun(duration: _duration, isFullSun: isFullSun,),
          const Land(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Tabs(
                    press: (value) {
                      changeMood(value);
                    },
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Good Morning",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  const Text(
                    "Enter your Informations below",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 50.h),

                  SizedBox(height: 25.h),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
