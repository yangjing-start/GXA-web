import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/assets.dart';


class Sun extends StatelessWidget {
  const Sun({super.key,
    required Duration duration,
    required this.isFullSun,
  })  : _duration = duration;

  final Duration _duration;
  final bool isFullSun;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _duration,
      curve: Curves.easeInOut,
      left: 30.w,
      bottom: isFullSun ? -45.h : -120.h,
      child: SvgPicture.asset(Assets.matchPageSun),
    );
  }
}
