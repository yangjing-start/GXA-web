import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide MultipartFile,FormData;
import 'package:logger/logger.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:second/core/message/match/cancel_message_entity.dart';
import 'package:second/core/message/message.dart';
import 'package:second/core/net/api/upload_api.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../core/Utils/B64.dart';
import '../../../../core/message/match/image_message_entity.dart';
import '../../../../core/message/match/quit_message_entity.dart';
import '../../../../core/message/match/text_message_entity.dart';
import '../../../../core/message/match/voice_message_entity.dart';
import '../../../../core/utils/image_compress_util.dart';
import '../../../../main.dart';
import '../../../../service/global_socket.dart';
import '../../secondhand/goods_detail/goods_detail_view.dart';
import '../match_logic.dart';
import 'state.dart';
import 'dart:convert' as convert;

class MatchChatLogic extends GetxController implements EmojiTextFiledLogic{
  final MatchChatState state = MatchChatState();
  final GlobalState globalState = Get.find<GlobalLogic>().state;
  final Logger logger = Logger();
  FlutterSoundRecorder flutterSoundRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0.0,
  );
  final ScrollController mainScrollController = ScrollController();
  final TextEditingController editingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<AnimatedListState> $key = GlobalKey();
  @override
  void onInit() {
    GlobalSocketService.addEvent(Message.MATCH_CHAT_TEXT_MESSAGE.toString(), (message) {
      if(scrollController.hasClients && checkVisibility){
        state.unReadCount +=  1;
      }
      addRecordToView(ChatRecord(
          sender: 0, isText: true,
          content: convert.utf8.decode(
              convert.base64Decode(B64.hex2b64(message['content'] as String))),
          avatarUrl: state.avatar1.value,
          id: message['id']));
    });

    GlobalSocketService.addEvent(Message.MATCH_QUIT_MESSAGE.toString(), (message) {
      otherQuit();
      _showQuitDialog();
    });

    GlobalSocketService.addEvent(Message.MATCH_CHAT_IMAGE_MESSAGE.toString(), (message) {
      if(scrollController.hasClients &&checkVisibility){
        state.unReadCount +=  1;
      }
      addRecordToView(ChatRecord(
          sender: 0,
          imageUrl: convert.utf8.decode(convert.base64Decode(B64.hex2b64(message['imageUrl'] as String))),
          avatarUrl: state.avatar1.value,
          isImage: true,
          id: message['id']));
    });

    GlobalSocketService.addEvent(Message.MATCH_CHAT_VOICE_MESSAGE.toString(), (message) {
      if(scrollController.hasClients &&checkVisibility){
        state.unReadCount +=  1;
      }
      addRecordToView(ChatRecord(
          sender: 0,
          voiceUrl: convert.utf8.decode(convert.base64Decode(B64.hex2b64(message['voiceUrl'] as String))),
          avatarUrl: state.avatar1.value,
          isVoice: true,
          voiceLength: message['length'],
          id: message['id']));
    });

    GlobalSocketService.addEvent(Message.MATCH_CHAT_CANCEL_MESSAGE.toString(), (message) {
      if(scrollController.hasClients && checkVisibility){
        state.unReadCount +=  1;
      }
      int? index = getRecordIndex(message['cancelMessageId'] as String);
      if (index == null) {
        SmartDialog.showToast("出现未知错误 请联系管理员");
        return;
      }

      // $key.currentState?.removeItem(index, (context, animation) {
      //   return cancelMessageView(index, animation);
      // }, duration: const Duration(milliseconds: 200));
      // Future.delayed(const Duration(milliseconds: 300), () {
      //   state.records.removeAt(index);
      // });
      int sender = state.records[index].sender;
      removeAt(index);
      $key.currentState?.removeItem(index, (context, animation) {
        return cancelMessageView(sender, animation);
      }, duration: const Duration(milliseconds: 200));
    });

    GlobalSocketService.addEvent(Message.RESPONSE_MESSAGE.toString(), (message) {
      if(message["responseMessageType"] == Message.MATCH_CHAT_CANCEL_MESSAGE){
        logger.e("撤回消息");
        return;
      }
      int? index = getRecordIndex(message['messageId'] as String);
      if(index == null){
        SmartDialog.showToast("出现未知错误 !!!!!!!! ${message['messageId']}" );
      }else{
        state.records[index].hasSend.value = true;
      }
    });

    // GlobalSocketService.addEvent("MatchChat", (message){
    //   final responseBody = json.decode(message);
    //   logger.e(responseBody.toString());
    //   logger.d(scrollController.hasClients ? "hasClients" : "noClients");
    //   if (Message.MATCH_CHAT_TEXT_MESSAGE   == (responseBody['messageType'] as int)){
    //     if(scrollController.hasClients && checkVisibility){
    //       state.unReadCount +=  1;
    //     }
    //     addRecordToView(ChatRecord(
    //         sender: 0, isText: true,
    //         content: convert.utf8.decode(
    //             convert.base64Decode(B64.hex2b64(responseBody['content'] as String))),
    //         avatarUrl: state.avatar1.value,
    //         id: responseBody['id']));
    //   }
    //   if (Message.MATCH_QUIT_MESSAGE        == (responseBody['messageType'] as int)){
    //     otherQuit();
    //     _showQuitDialog();
    //   }
    //   if (Message.MATCH_CHAT_IMAGE_MESSAGE  == (responseBody['messageType'] as int)){
    //     if(scrollController.hasClients &&checkVisibility){
    //       state.unReadCount +=  1;
    //     }
    //     addRecordToView(ChatRecord(
    //         sender: 0,
    //         imageUrl: convert.utf8.decode(convert.base64Decode(B64.hex2b64(responseBody['imageUrl'] as String))),
    //         avatarUrl: state.avatar1.value,
    //         isImage: true,
    //         id: responseBody['id']));
    //   }
    //   if (Message.MATCH_CHAT_VOICE_MESSAGE  == (responseBody['messageType'] as int)){
    //     if(scrollController.hasClients &&checkVisibility){
    //       state.unReadCount +=  1;
    //     }
    //     addRecordToView(ChatRecord(
    //         sender: 0,
    //         voiceUrl: convert.utf8.decode(convert.base64Decode(B64.hex2b64(responseBody['voiceUrl'] as String))),
    //         avatarUrl: state.avatar1.value,
    //         isVoice: true,
    //         voiceLength: responseBody['length'],
    //         id: responseBody['id']));
    //   }
    //   if (Message.MATCH_CHAT_CANCEL_MESSAGE == (responseBody['messageType'] as int)){
    //     if(scrollController.hasClients &&checkVisibility){
    //       state.unReadCount +=  1;
    //     }
    //     int? index = getRecordIndex(responseBody['cancelMessageId'] as String);
    //     if (index == null) {
    //       SmartDialog.showToast("出现未知错误 请联系管理员");
    //     } else {
    //       if (index == state.records.length - 1) {
    //         $key.currentState?.removeItem(index, (context, animation) {
    //           double rpx = MediaQuery.of(context).size.width / 750;
    //           return cancelMessageView(index, animation, rpx);
    //         }, duration: const Duration(milliseconds: 200));
    //         Future.delayed(const Duration(milliseconds: 300), () {
    //           state.records.removeAt(index);
    //         });
    //       } else {
    //         state.records.removeAt(index);
    //         $key.currentState?.removeItem(index, (context, animation) {
    //           double rpx = MediaQuery.of(context).size.width / 750;
    //           return cancelMessageView(index, animation, rpx);
    //         }, duration: const Duration(milliseconds: 200));
    //       }
    //     }
    //   }
    //   if (Message.RESPONSE_MESSAGE          == (responseBody['messageType'] as int)){
    //     logger.i('收到回执 ');
    //     logger.i('messageId : ${responseBody['messageId']}');
    //     for (var element in state.records) {
    //       logger.w(element);
    //     }
    //     int? index = getRecordIndex(responseBody['messageId'] as String);
    //     if(index == null){
    //       SmartDialog.showToast("出现未知错误 !!!!!!!! ${responseBody['messageId']}" );
    //     }else{
    //       state.records[index].hasSend.value = true;
    //     }
    //   }
    // });
    print('onInit');
    super.onInit();
  }
  @override
  void onReady() {
    print('onReady');
    scrollController.addListener(() {
      if(scrollController.hasClients && checkVisibility){
        state.unReadCount = 0;
      }
    });
    super.onReady();
  }
  @override
  void onClose() {
    print('onClose');
    flutterSoundPlayer.closePlayer();
    flutterSoundRecorder.closeRecorder();
    focusNode.dispose();
    editingController.dispose();
    logger.close();
    scrollController.dispose();
    mainScrollController.dispose();
    state.records.clear();
    super.onClose();
  }


  void showCancelConfirmDialog() {
    Get.defaultDialog(
      title: "是否要退出？",
      titleStyle: const TextStyle(color: Colors.black54, fontSize: 20),
      middleText: "退出后数据将不会被保留",
      textConfirm: "返回",
      confirmTextColor: Colors.white,
      textCancel: "确认",
      cancelTextColor: Colors.greenAccent,
      onConfirm: () => Get.back(),
      onCancel: quitRoom,
    );
  }

  bool get checkVisibility =>
      scrollController.position.maxScrollExtent - scrollController.position.pixels
          >
          //整个屏幕的高度 - 顶部的状态栏高度 - 顶部的导航栏高度 - 底部的输入框高度 = 中间的聊天框高度
            (Get.height  - Get.context!.mediaQueryPadding.top - 56 - 50.h) / 5;

  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    state.unReadCount = 0;
  }

  @override
  void openEmojis() => state.isOpenEmoji = true;

  @override
  void closeEmojis() => state.isOpenEmoji = false;

  @override
  void switchBetweenEmojiAndKeyboard() async {
    if (!state.isOpenKeyboard) {
      openEmojis();
      //以当前位置下滑300。h
     scrollController.animateTo(scrollController.position.pixels + 300.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      if (!state.isOpenEmoji) {
        await closeKeyboard();
        openEmojis();
        scrollController.animateTo(scrollController.position.pixels + 300.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);

      }
    }
  }

  @override
  Future<void> openKeyboard()async{
    await SystemChannels.textInput.invokeMethod('TextInput.show');
    state.isOpenKeyboard = true;
  }

  @override
  Future<void> closeKeyboard()async{
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    state.isOpenKeyboard = false;
  }

  @override
  void unFocus(BuildContext context){
    if (!state.isOpenKeyboard && !state.openEmoji) {
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    closeKeyboard();
    closeEmojis();
  }


  // 发送图片
  Future<dynamic> sendImage(BuildContext context) async {
    List<AssetEntity>? imageList = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        textDelegate: AssetPickerTextDelegate(),
        maxAssets: 1,
        requestType: RequestType.image,
        pageSize: 100,
        previewThumbnailSize: ThumbnailSize(300, 300),
      ),
    );
    if (imageList == null) {
      return;
    }
    File? image = await imageList[0].file;
    if (image!.lengthSync() > 10 * 1024 * 1024) {
      SmartDialog.showToast("图片过大，请重新选择");
      return null;
    }
    image = await ImageCompressUtil().imageCompressAndGetFile(image);
    String id = globalState.uuid.v4();
    ChatRecord chatRecord = ChatRecord(
        sender: 1,
        content: "",
        isImage: true,
        avatarUrl: state.avatar2.value,
        filePath: image.absolute.path,
        id: id);

    addRecordToViewFromSelf(chatRecord);
    Future.delayed(const Duration(milliseconds: 10000), () {
      int? index = getRecordIndex(id);
      if(index != null){
        if(state.records[index].hasSend.value != true || state.records[index].hasUploaded.value != true){
          state.records[index].isError.value = true;
        };
      }
    });
    String imageUrl = "";
    try {
      imageUrl = await sendImageToOSS(chatRecord);
      if(imageUrl == ""){
        chatRecord.isError.value = true;
        SmartDialog.showToast("图片上传失败sss");
        return;
      }
      sendImageToServer(imageUrl, id);
    } catch (e) {
      logger.e(e);
      chatRecord.isError.value = true;
      SmartDialog.showToast("图片上传失败aaaaa");
      return;
    }
  }
  void sendImageToServer(String imageUrl, String id) {
    ImageMessageEntity imageMessageEntity = ImageMessageEntity();
    imageMessageEntity.imageUrl = B64.b64tohex(base64Encode(utf8.encode(imageUrl)));;
    imageMessageEntity.to = state.oppositeId;
    imageMessageEntity.from = state.selfId;
    imageMessageEntity.token = "noToken";
    imageMessageEntity.createTime = DateTime.now().microsecondsSinceEpoch.toString();
    imageMessageEntity.id = id;
    imageMessageEntity.roomId = state.roomId;
    imageMessageEntity.messageType = Message.MATCH_CHAT_IMAGE_MESSAGE;
    GlobalSocketService.send(imageMessageEntity);
  }
  Future<String> sendImageToOSS(ChatRecord chatRecord) async{
    String imageUrl = "";

    try{
      FormData formData;
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(chatRecord.filePath!),
      });
      UploadApi api = UploadApi(
          url: 'http://${GetPlatform.isIOS ? iosLocalHost : currentHost}:8889/image'
      );
      await api.request(
          body: formData,
          successCallBack: (data) {
            imageUrl = data.toString();
            chatRecord.hasUploaded.value = true;
          },
          errorCallBack: (error) {
            SmartDialog.showToast("图片上传失败!!");
          },
          onReceiveProgress: (int count, int total) {
            chatRecord.progress.value = count / total;
          }
      );
    }catch(e){
      logger.e(e);
      SmartDialog.showToast("图片上传失败asd");
    }
    return imageUrl;
  }

  // 发送语音
  Future<void> stopRecord() async {
    state.isRecording = false;
    String? uri = await flutterSoundRecorder.getRecordURL(path: state.filePath.value);
    await flutterSoundRecorder.closeRecorder();
    int length = state.endTime.difference(state.beginTime).inSeconds;
    if(length > 10){
      _showTimeOutDialog();
      if (File(state.filePath.value).existsSync()) {
        File(state.filePath.value).deleteSync();
      }
    }else{
      try {
        String id = globalState.uuid.v4();
        //不管有没有上传成功现在View层添加
        ChatRecord chatRecord = ChatRecord(
            sender: 1,
            content: length.toString(),
            avatarUrl: state.avatar2.value,
            id: id,
            voiceFilePath: uri);
        addRecordToViewFromSelf(chatRecord);
        //十秒之内没有上传成功就显示失败
        Future.delayed(const Duration(milliseconds: 10000), () {
          int? index = getRecordIndex(id);
          if(index != null){
            if(state.records[index].hasSend.value != true || state.records[index].hasUploaded.value != true){
              state.records[index].isError.value = true;
            };
          }
        });
        //上传语音
        String voiceUrl = "";
        try {
          voiceUrl = await sendVoiceToOSS(chatRecord);
          if(voiceUrl == ""){
            chatRecord.isError.value = true;
            SmartDialog.showToast("语音上传失败");
            return;
          }
          sendVoiceToServer(voiceUrl, length, voiceUrl);
        } catch (e) {
          logger.e(e);
          chatRecord.isError.value = true;
          SmartDialog.showToast("语音上传失败aaaaa");
          return;
        }
      } catch (e) {
        SmartDialog.showToast("发送失败");
      }
    }
    // playRecord(state.filePath.value);
  }
  void sendVoiceToServer(String id, int length, String voiceUrl){
    VoiceMessageEntity voiceMessageEntity = VoiceMessageEntity();
    voiceMessageEntity.token = "noToken";
    voiceMessageEntity.roomId = state.roomId;
    voiceMessageEntity.from = Get.find<MatchLogic>().state.selfId;
    voiceMessageEntity.createTime = DateTime.now().millisecondsSinceEpoch.toString();
    voiceMessageEntity.messageType = Message.MATCH_CHAT_VOICE_MESSAGE;
    voiceMessageEntity.id = id;
    voiceMessageEntity.voiceUrl = B64.b64tohex(base64Encode(utf8.encode(voiceUrl)));
    voiceMessageEntity.length = length;
    GlobalSocketService.send(voiceMessageEntity);
  }
  Future<String> sendVoiceToOSS(ChatRecord chatRecord) async {
    String voiceUrl = "";
    try{
      FormData formData;
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(chatRecord.filePath!),
      });
      UploadApi api = UploadApi(
          url: 'http://${GetPlatform.isIOS ? iosLocalHost : currentHost}:8889/voice'
      );
      await api.request(
          body: formData,
          successCallBack: (data) {
            voiceUrl = data.toString();
            chatRecord.hasUploaded.value = true;
          },
          errorCallBack: (error) {
            SmartDialog.showToast("语音上传失败");
          },
          onReceiveProgress: (int count, int total) {
            chatRecord.progress.value = count / total;
          }
      );
    }catch(e){

      SmartDialog.showToast("语音上传失败!!!");
    }
    return voiceUrl;
  }

  // 发送文字
  void sendTextMessage() {
    if (editingController.text.isEmpty) {
      SmartDialog.showToast("请输入内容");
      return;
    } else {
      if (editingController.text.length > 200) {
        SmartDialog.showToast("输入内容过长");
        return;
      }
      String id = globalState.uuid.v4();
      ChatRecord chatRecord = ChatRecord(
          sender: 1,
          content: editingController.text,
          avatarUrl: state.avatar1.value,
          isText: true,
          id: id);
      editingController.text = "";
      addRecordToViewFromSelf(chatRecord);

      state.records[state.records.length - 1].hasUploaded.value = true;
      state.records[state.records.length - 1].hasSend.value = false;
      sendTextToServer(chatRecord);
      Future.delayed(const Duration(milliseconds: 10000), () {
        int? index = getRecordIndex(id);
        if(index != null){
          if(state.records[index].hasSend.value != true || state.records[index].hasUploaded.value != true){
            state.records[index].isError.value = true;
          };
        }
      });
    }
  }
  void sendTextToServer(ChatRecord chatRecord) {
    MatchTextMessageEntity matchTextMessageEntity = MatchTextMessageEntity();
    matchTextMessageEntity.token = "noToken";
    matchTextMessageEntity.roomId = state.roomId;
    matchTextMessageEntity.from = state.selfId;
    matchTextMessageEntity.to = state.oppositeId;
    matchTextMessageEntity.createTime = DateTime.now().microsecondsSinceEpoch.toString();
    matchTextMessageEntity.messageType = Message.MATCH_CHAT_TEXT_MESSAGE;
    matchTextMessageEntity.id = chatRecord.id;
    matchTextMessageEntity.content =  B64.b64tohex(base64Encode(utf8.encode(chatRecord.content)));
    GlobalSocketService.send(matchTextMessageEntity);

  }

  // 发送退出
  void quitRoom() {
    if (!state.isQuited) {
      sendQuitMessageToServer();
    }
    Get.find<MatchLogic>().state.isLaunch = false;
    state.isQuited = false;
    Get.back();
  }
  void sendQuitMessageToServer(){
    QuitMessageEntity quitMessageEntity = QuitMessageEntity();
    quitMessageEntity.token = "noToken";
    quitMessageEntity.roomId = state.roomId;
    quitMessageEntity.from = Get.find<MatchLogic>().state.selfId;
    quitMessageEntity.createTime = DateTime.now().millisecondsSinceEpoch.toString();
    quitMessageEntity.messageType = Message.MATCH_QUIT_MESSAGE;
    quitMessageEntity.to = state.oppositeId;
    quitMessageEntity.id = globalState.uuid.v4();
    GlobalSocketService.send(quitMessageEntity);
  }

  // 发送撤回
  void sendCancelMessageToServer(String cancelMessageId){
    CancelMessageEntity cancelMessageEntity = CancelMessageEntity();
    cancelMessageEntity.token = "noToken";
    cancelMessageEntity.roomId = state.roomId;
    cancelMessageEntity.from = state.selfId;
    cancelMessageEntity.to = state.oppositeId;
    cancelMessageEntity.cancelMessageId = cancelMessageId;
    cancelMessageEntity.createTime = DateTime.now().microsecondsSinceEpoch.toString();
    cancelMessageEntity.id = globalState.uuid.v4();
    cancelMessageEntity.messageType = Message.MATCH_CHAT_CANCEL_MESSAGE;
    GlobalSocketService.send(cancelMessageEntity);
  }


  Future<dynamic> _showQuitDialog() {
    return Get.defaultDialog(
      title: "对方已退出",
      titleStyle: const TextStyle(color: Colors.black54, fontSize: 20),
      middleText: "",
      textConfirm: "再看看",
      confirmTextColor: Colors.white,
      textCancel: "退出",
      cancelTextColor: Colors.greenAccent,
      onConfirm: () => Get.back(),
      onCancel: () {
        Get.find<MatchLogic>().state.isLaunch = false;
        Get.back();
      },
    );
  }

  Future<dynamic> _showTimeOutDialog() {
    return Get.defaultDialog(
      title: "语音时长不能超过60秒",
      titleStyle: const TextStyle(color: Colors.black54, fontSize: 20),
      middleText: "",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      textCancel: "退出",
      cancelTextColor: Colors.greenAccent,
      onConfirm: () => Get.back(),
      onCancel: () {
        Get.back();
      },
    );
  }

  void onEditingComplete() {
     openKeyboard();
    if (state.openEmoji) {
      closeEmojis();
    }
  }

  void removeAt(int index) => state.records.removeAt(index);

  void otherQuit() => state.isQuited = true;

  void changeRecord() {
    state.isSound = !state.isSound;
  }

  void startRecord() async {
    state.isRecording = true;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String fileType = ".mp4";
    if (Platform.isIOS) {
      fileType = ".m4a";
    }
    state.filePath.value = fileName + fileType;
    flutterSoundRecorder = (await flutterSoundRecorder.openRecorder())!;
    logger.e("开始录音");
    state.beginTime = DateTime.now();
    await flutterSoundRecorder.startRecorder(toFile: state.filePath.value);
    state.endTime = DateTime.now();
  }

  void playRecord(String filePath) async {
    bool isPlaying = flutterSoundPlayer.isPlaying;
    flutterSoundPlayer = (await flutterSoundPlayer.openPlayer())!;
    if (isPlaying) {
      await flutterSoundPlayer.stopPlayer().then((_) => {isPlaying = false});
    } else {
      await flutterSoundPlayer
          .startPlayer(fromURI: filePath)
          .then((_) async => {isPlaying = true});
    }
  }

  void cancelRecord() async {
    state.isRecording = false;
    await flutterSoundRecorder.closeRecorder();
    if (File(state.filePath.value).existsSync()) {
      File(state.filePath.value).deleteSync();
    }
  }

  int? getRecordIndex(String id) {
    int? index;
    for (int i = 0; i < state.records.length; i++) {
      state.records[i].id == id ? logger.w("asdasda") : null;
      if (state.records[i].id == id) {
        return i;
      }
    }
    return index;
  }
  void addRecordToViewFromSelf(ChatRecord chatRecord) {

    state.records.add(chatRecord);//第二次进入这个页面的时候会有问题
    for (var element in state.records) {
      print(element.toString());}

    $key.currentState?.insertItem(state.records.length - 1,
        duration: const Duration(milliseconds: 200));
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    });
  }
  void addRecordToView(ChatRecord chatRecord) {
    state.records.add(chatRecord);
    $key.currentState?.insertItem(state.records.length - 1,
        duration: const Duration(milliseconds: 200));

    if(scrollController.hasClients &&checkVisibility){
      //如果正在看上面的信息就不滑动到最低下
      return;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.hasClients ? scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.linear) : null;
    });
  }

   ScaleTransition cancelMessageView(int sender, Animation<double> animation) {
    return ScaleTransition(
      key: UniqueKey(),
      alignment: sender == 1
          ? Alignment.centerRight
          : Alignment.centerLeft,
      scale: animation,
      child: Row(
        mainAxisAlignment: sender == 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          sender == 0
              ? CircleAvatar(
            backgroundImage: NetworkImage(
                state.matchType == 0 ? state.avatar1.value :  state.avatar2.value),
          )
              : Container(),

          //MessageContent
          Container(
            width: 70.w,
            padding: EdgeInsets.all(7.r),
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            decoration: BoxDecoration(
                color: sender == 0
                    ? Colors.greenAccent
                    : Colors.grey,
                borderRadius: BorderRadius.circular(10.r)
            ),
            child: Text(" ",style: TextStyle(fontSize: 14.sp,),),
          ),

          sender == 1
              ? CircleAvatar(
            backgroundImage: NetworkImage(
                state.matchType == 1 ?state.avatar1.value :  state.avatar2.value),
          )
              : Container(),
        ],
      ),
    );
  }

}
