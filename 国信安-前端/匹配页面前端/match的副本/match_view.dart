import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../widgets/gesture_widget.dart';
import '../../widgets/heart_paint.dart';
import 'components/land.dart';
import 'components/sun.dart';
import 'components/tabs.dart';
import 'match_logic.dart';

class MatchPage extends StatefulWidget {
  MatchPage({Key? key}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final logic = Get.find<MatchLogic>();

  final state = Get
      .find<MatchLogic>()
      .state;

  bool isFullSun = false;

  bool isDayMood = true;

  final Duration _duration = Duration(seconds: 1);

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
  bool _isDark = false;
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
    return GetX<MatchLogic>(
      init: logic,
      initState: (_) {},
      builder: (logic) {
        return Scaffold(
          body: AnimatedContainer(
            onEnd: () {
              setState(() {
                _isDark = !_isDark;
              });
            },
            duration: _duration,
            curve: Curves.linear,
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
                Positioned(
                  bottom: -65.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    _isDark ? Assets.imageLandTreeLight : Assets.imageLandTreeDark,
                    key: ValueKey(_isDark),
                    height: 430.h,
                    fit: BoxFit.fitHeight,
                  ),),
                Center(
                    child: Container(
                      color: Colors.transparent,
                      height: 400.h,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          matchButton(),
                          listenButton(),
                          talkButton(),
                          interruptButton(),
                          AnimatedPositioned(
                            left: state.heartPosition,
                            bottom: 100.h,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 500),
                            child: CustomPaint(
                              size: Size(400.r, 400.r),
                              painter: Heart(
                                  Colors.pink, Colors.transparent, 0, true),
                            ),
                          ),
                          AnimatedPositioned(
                            right: state.heartPosition,
                            bottom: 100.h,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 500),
                            child: CustomPaint(
                              size: Size(400.r, 400.r),
                              painter: Heart(
                                  Colors.pink, Colors.transparent, 0, false),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AnimatedPositioned listenButton() {
    return AnimatedPositioned(
      top: state.listenTopPosition,
      left: state.listenLeftPosition,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: 50.r,
        height: 50.r,
        child: InkWell(
          onTap: (){
            if(state.isLaunch){
              return;
            }
            changeMood(0);
            logic.chooseListen();
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            opacity: state.listenOpacity,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20.r)),
              width: double.infinity,
              child: Center(
                child:
                 Icon(Icons.star, color: Colors.white, size: 32.r,),
                // Text(
                //   "听",
                //   style: TextStyle(
                //       color: Colors.indigoAccent,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 15.sp),
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedPositioned talkButton() {
    return AnimatedPositioned(
      top: state.talkTopPosition,
      right: state.talkRightPosition,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: 50.r,
        height: 50.r,
        child: InkWell(
          onTap: (){
            if(state.isLaunch){
              return;
            }
            changeMood(1);
            logic.chooseTalk();
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            opacity: state.talkOpacity,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(20.r)),
              width: double.infinity,
              child: Center(
                child:
                Icon(Icons.shield_moon_outlined, color: Colors.white, size: 32.r,),
                // Text(
                //   "说",
                //   style: TextStyle(
                //       color: Colors.greenAccent,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 15.sp),
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  StatefulBuilder matchButton() {
    return StatefulBuilder(
      builder: (context, setstate) =>
          Positioned(
            top: 60.h,
            left: (MediaQuery
                .of(context)
                .size
                .width - 200.w) / 2,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ]),
              width: 200.r,
              height: 200.r,
              child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.2)
                      .animate(CurvedAnimation(parent: logic.scaleController, curve: Curves.easeOut)),
                  child: GestureDetector(
                    onTap:logic.launch,
                    child: AnimatedContainer(
                      width: 200.r,
                      height: 200.r,
                      decoration: BoxDecoration(
                        color: state.matchButtonColor,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      curve: Curves.linear,
                      duration: const Duration(seconds: 1),
                      child: Center(
                        child: AnimatedCrossFade(
                          crossFadeState: !state.shouldMatch ? CrossFadeState
                              .showFirst : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 500),
                          firstChild: Text(
                            "开始匹配",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          secondChild: Text(
                            "匹配中...",
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ),
    );
  }

  Positioned interruptButton() {

    return Positioned(
      left: (Get.width - 70.w) / 2,
      bottom: 20.h,
      child: SingleGestureDetector(
        tapAction: logic.interrupt,
        tapDuration: 2,
        againAction: () {},
        child: Container(
          padding: EdgeInsets.only(top: 20.h),
          width: 70.w,
          height: 60.h,
          child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
              opacity:state.interruptButtonOpacity,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10.r)),
                width: double.infinity,
                height: 200.r,
                child: Center(
                  child: Text(
                    '退出',
                    style: TextStyle(fontSize: 20.sp, color: Colors.black87),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
