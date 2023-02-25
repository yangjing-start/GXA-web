import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MatchState {

  late String selfId;
  late String roomId;
  late String oppositeId;
  final RxDouble _interruptButtonOpacity = 0.0.obs;
  final RxDouble _initialTopPosition = 0.0.obs;
  final RxDouble _initialHonPosition = 80.0.obs;
  final RxDouble _initialOpacity = 1.0.obs;
  final RxDouble _listenOpacity = 1.0.obs;
  final RxDouble _talkOpacity = 1.0.obs;
  final RxDouble _listenTopPosition = 0.0.obs;
  final RxDouble _listenLeftPosition = 80.0.obs;
  final RxDouble _talkTopPosition = 0.0.obs;
  final RxDouble _talkRightPosition = 80.0.obs;
  final RxDouble _heartPosition = 400.0.obs;
  final Rx<MaterialAccentColor> _matchButtonColor = Colors.cyanAccent.obs;
  final RxBool _shouldMatch = false.obs;
  final RxBool _isLaunch = false.obs;
  final RxString _matchType = "0".obs;
  MatchState() {
    ///Initialize variables
  }

  String get matchType => _matchType.value;
  set matchType(String value) => _matchType.value = value;

  double get initialTopPosition => _initialTopPosition.value;
  set initialTopPosition(double value) => _initialTopPosition.value = value;
  double get initialHonPosition => _initialHonPosition.value;
  set initialHonPosition(double value) => _initialHonPosition.value = value;
  double get initialOpacity => _initialOpacity.value;
  set initialOpacity(double value) => _initialOpacity.value = value;
  double get listenOpacity => _listenOpacity.value;
  set listenOpacity(double value) => _listenOpacity.value = value;
  double get talkOpacity => _talkOpacity.value;
  set talkOpacity(double value) => _talkOpacity.value = value;
  double get listenTopPosition => _listenTopPosition.value;
  set listenTopPosition(double value) => _listenTopPosition.value = value;
  double get listenLeftPosition => _listenLeftPosition.value;
  set listenLeftPosition(double value) => _listenLeftPosition.value = value;
  double get talkTopPosition => _talkTopPosition.value;
  set talkTopPosition(double value) => _talkTopPosition.value = value;
  double get talkRightPosition => _talkRightPosition.value;
  set talkRightPosition(double value) => _talkRightPosition.value = value;
  double get heartPosition => _heartPosition.value;
  set heartPosition(double value) => _heartPosition.value = value;
  MaterialAccentColor get matchButtonColor => _matchButtonColor.value;
  set matchButtonColor(MaterialAccentColor value) => _matchButtonColor.value = value;
  bool get shouldMatch => _shouldMatch.value;
  set shouldMatch(bool value) => _shouldMatch.value = value;
  bool get isLaunch => _isLaunch.value;
  set isLaunch(bool value) => _isLaunch.value = value;
  double get interruptButtonOpacity => _interruptButtonOpacity.value;
  set interruptButtonOpacity(double value) => _interruptButtonOpacity.value = value;

}
