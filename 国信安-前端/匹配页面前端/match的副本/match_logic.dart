import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:second/core/message/match/interrupt_message_entity.dart';
import 'package:second/core/router/router.dart';
import 'package:second/main.dart';
import 'package:second/service/global_socket.dart';
import 'package:second/service/shared_preference.dart';

import '../../../core/message/match/launch_message_entity.dart';
import '../../../core/message/message.dart';
import 'match_chat/view.dart';
import 'match_state.dart';

class MatchLogic extends GetxController with GetTickerProviderStateMixin{
  final MatchState state = MatchState();
  late final AnimationController scaleController;
  final globalState = Get.find<GlobalLogic>().state;

  @override
  void onInit() {
    scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    state.selfId = SPService.getString(SPKey.schoolAccount)!;

    GlobalSocketService.addEvent(Message.MATCH_SUCCESS_MESSAGE.toString(), (message)async{
      scaleController.stop();
      state.heartPosition = (Get.width/2) - 200.w;
      state.shouldMatch = false;
      //等待❤合并️
      await Future.delayed(const Duration(milliseconds: 700), () {
        String roomId = message['roomId'].toString();
        state.roomId = roomId;
        state.oppositeId = state.matchType == "1" ? message['listenId'].toString() : message['talkId'].toString();
        Get.to(() => MatchChatPage(), transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
      });
      //进入聊天界面之后再复原❤
      Future.delayed(const Duration(milliseconds: 700), () {
        state.heartPosition = 400;
        state.interruptButtonOpacity = 0.0;
      });
    });
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    scaleController.dispose();
    super.onClose();
  }



  Future<dynamic> showMustSetDialog() {
    return Get.defaultDialog(
      title: "请选择要充当的角色",
      titleStyle: const TextStyle(color: Colors.black54, fontSize: 20),
      textConfirm: "确认",
      middleText: "",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
  void wantListen() => state.matchType = "1";

  void wantTalk() => state.matchType = "0";

  void chooseTalk(){
    if (state.isLaunch) {
      return;
    }
    wantTalk();
    state.listenLeftPosition = state.initialHonPosition;
    state.listenTopPosition = state.initialTopPosition;
    state.listenOpacity = state.initialOpacity;
    state.talkTopPosition = 100.h;
    state.talkRightPosition = (Get.width - 50.w) / 2;
    state.talkOpacity = 0.0;
    state.matchButtonColor = Colors.pinkAccent;
  }

  void chooseListen(){
    if (state.isLaunch) {
      return;
    }
    wantListen();
    state.talkTopPosition = state.initialTopPosition;
    state.talkRightPosition = state.initialHonPosition;
    state.talkOpacity = state.initialOpacity;
    state.listenLeftPosition = (Get.width - 50.w) / 2;
    state.listenTopPosition = 100.h;
    state.listenOpacity = 0.0;
    state.matchButtonColor = Colors.amberAccent;
  }

  void launch(){
    if(state.isLaunch){
      return;
    }

    if (state.listenOpacity == state.initialOpacity &&
        state.talkOpacity == state.initialOpacity) {
      showMustSetDialog();
      return;
    }
    state.isLaunch = true;
    state.interruptButtonOpacity = 1;
    state.shouldMatch = true;

    LaunchMessageEntity launchMessageEntity = LaunchMessageEntity();
    launchMessageEntity.matchType = state.matchType;
    launchMessageEntity.token = SPService.getString(SPKey.token) ?? "noToken";
    launchMessageEntity.from = state.selfId;
    launchMessageEntity.id = globalState.uuid.v4();
    launchMessageEntity.createTime = DateTime.now().millisecondsSinceEpoch.toString();
    launchMessageEntity.messageType = Message.MATCH_LAUNCH_MESSAGE;
    GlobalSocketService.send(launchMessageEntity);


    scaleController.repeat(reverse: true);
  }

  void interrupt(){

    state.interruptButtonOpacity = 0.0;
    state.shouldMatch = false;

    InterruptMessageEntity interruptMessageEntity = InterruptMessageEntity();
    interruptMessageEntity.matchType = state.matchType;
    interruptMessageEntity.token = SPService.getString(SPKey.token) ?? "noToken";
    interruptMessageEntity.from = state.selfId;
    interruptMessageEntity.id = globalState.uuid.v4();
    interruptMessageEntity.createTime = DateTime.now().millisecondsSinceEpoch.toString();
    interruptMessageEntity.messageType = Message.MATCH_INTERRUPT_MESSAGE;
    GlobalSocketService.send(interruptMessageEntity);

    state.isLaunch = false;
    scaleController.stop();
  }
}
