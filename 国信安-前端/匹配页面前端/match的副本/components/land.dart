import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';

class Land extends StatelessWidget {
  const Land({super.key});


  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -65.h,
      left: 0,
      right: 0,
      child: Image.asset(
        Assets.imageLandTreeLight,
        height: 430.h,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
