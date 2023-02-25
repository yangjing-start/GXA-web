import 'dart:io';
import 'dart:math';

import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:second/ui/pages/match/match_chat/state.dart';

import '../../../../generated/assets.dart';
import '../../../widgets/Image_widget.dart';
import '../../../widgets/permisson_util.dart';
import '../../secondhand/goods_detail/goods_detail_view.dart';
import 'logic.dart';

part 'component/_text_input.dart';

part 'component/_record_voice_button.dart';

part 'component/_emoji_box.dart';

part 'component/_chat_detail_list.dart';

part 'component/_chat_box_painter.dart';



class MatchChatPage extends StatelessWidget {
  final logic = Get.put(MatchChatLogic());
  final state = Get
      .find<MatchChatLogic>()
      .state;

  MatchChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = (Get.height - Get.context!.mediaQueryPadding.top - 56);
    print('adsas');
    return WillPopScope(
      onWillPop: () {
        logic.showCancelConfirmDialog();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: logic.showCancelConfirmDialog,
          ),
        ),
        body: GetX<MatchChatLogic>(
          init: logic,
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                logic.unFocus(context);
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: logic.mainScrollController,
                    child: Column(
                      children: [
                        SizedBox(
                            height: height
                                - 50.h //底部输入框
                                - (state.isOpenKeyboard ? Get.context!
                                    .mediaQueryViewInsets.bottom : 0)
                                - (state.openEmoji ? 300.h : 0),
                            child: _ChatDetailList()),
                        coreView(context),
                        _EmojiContainer(
                          state: state, logic: logic,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10.w,
                    bottom: 50.h + (state.isOpenKeyboard ? Get.context!
                        .mediaQueryViewInsets.bottom : 0)
                        + (state.openEmoji ? 300.h : 0),
                    child: GestureDetector(
                      onTap: logic.scrollToBottom,
                      child: Visibility(
                        visible: (state.unReadCount > 0),
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              Assets.matchPageQipao,
                              width: 35.r,
                              height: 35.r,
                            ),
                            Positioned(
                              left: 11.r,
                              top: 5.r,
                              child: Text(
                                state.unReadCount.toString(),
                                style: TextStyle(fontSize: 15.r),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget coreView(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 400.h,
      ),
      width: Get.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: .4.w, color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                bool isGrant = await PermissionUtil.permissionWithCustomPopup(context: context, permission: MyPermission.microphone);
                if (!isGrant) {
                  return ;
                }
                logic.changeRecord();
              },
              icon: !state.isSound ? const Icon(Icons.mic,) : const Icon(
                Icons.keyboard,)),
          state.isSound
              ? const _RecordVoiceButton()
              : _TextView(
            onSubmitted: (value) async {},
            onEditingTap: () async {
              print('onEditingTap');
                    await logic.openKeyboard();
              if (state.isOpenEmoji) {
                logic.closeEmojis();
              }
            },
            editingController: logic.editingController,
            focusNode: logic.focusNode,
          ),
          InkWell(
              onTap: () async {
                await logic.sendImage(context);
              },
              child: const Icon(
                Icons.satellite,
              )),
          IconButton(
              onPressed: logic.switchBetweenEmojiAndKeyboard,
              icon: const Icon(
                Icons.tag_faces,
              )),
          state.isSound ? const SizedBox() : sendButton(logic.sendTextMessage)
        ],
      ),
    );
  }

  SizedBox sendButton(void Function() send) {
    return SizedBox(
      width: 55.w,
      height: 30.h,
      child: TextButton(
        onPressed: send,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 0.h,
            vertical: 2.h,
          ),
          backgroundColor: const Color(0xff5b92e2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
        ),
        child: Text(
          '发送',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
