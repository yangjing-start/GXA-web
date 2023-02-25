import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second/ui/pages/match/match_logic.dart';

class MatchChatState {

  
  late String roomId = Get.find<MatchLogic>().state.roomId;
  late String selfId = Get.find<MatchLogic>().state.selfId;
  late String oppositeId = Get.find<MatchLogic>().state.oppositeId;
  final RxInt _unReadCount = 0.obs;
  int get unReadCount => _unReadCount.value;
  set unReadCount(int value) {
    _unReadCount.value = value;
  }
  late bool isQuited = false;
  final RxInt _matchType = 0.obs;
  final Rx<String> avatar1 = "https://pic4.zhimg.com/v2-b2225a535c4cde5c250f729785eff9a1_r.jpg?source=1940ef5c".obs;
  final Rx<String> avatar2 = "https://pic4.zhimg.com/v2-3c4fedb22de08c696d32d799756c4f5b_r.jpg?source=1940ef5c".obs;
  late final RxList<ChatRecord> _records;
  List<ChatRecord> get records => _records;
  set records(List<ChatRecord> value) {
    _records.value = value;
  }
  late Animation<double> scaleAnimation;
  late AnimationController scaleController;
  final appDocPath = "".obs;
  final filePath = "".obs;
  final RxBool _openEmoji = false.obs;
  bool get isOpenEmoji => _openEmoji.value;
  set isOpenEmoji(bool value) {
    _openEmoji.value = value;
  }
  final RxBool _openKeyboard = false.obs;
  bool get isOpenKeyboard => _openKeyboard.value;
  set isOpenKeyboard(bool value) {
    _openKeyboard.value = value;
  }
  final RxBool _isSound = false.obs;
  final RxBool _isRecording = false.obs;

  var beginTime = DateTime.now();
  var endTime = DateTime.now();

  bool get isRecording => _isRecording.value;
  set isRecording(bool value) {
    _isRecording.value = value;
  }
  bool get isSound => _isSound.value;
  set isSound(bool value) {
    _isSound.value = value;
  }
  bool get openEmoji => _openEmoji.value;


  int get recordsLength => _records.length;
  int get matchType => _matchType.value;

  MatchChatState() {
    _records = <ChatRecord>[].obs;
  }
}
class ChatRecord {
  int sender;
  dynamic content;
  String avatarUrl;
  String? filePath;
  String? voiceFilePath;
  String id;
  RxBool hasUploaded = false.obs;
  RxBool hasSend = false.obs;
  RxBool isError = false.obs;
  RxDouble progress = 0.0.obs;
  bool? isVoice;

  bool? isImage;
  bool? isText;
  String? voiceLength;
  String? imageUrl;
  String? voiceUrl;
  ChatRecord(
      {required this.sender,
        this.content,
        required this.avatarUrl,
        this.filePath,
        this.voiceFilePath,
        this.isImage,
        this.isVoice,
        this.isText,
        this.imageUrl,
        this.voiceUrl,
        required this.id, this.voiceLength});

  @override
  String toString() {

    return 'ChatRecord{sender: $sender, content: $content, avatarUrl: $avatarUrl, filePath: $filePath, voiceFilePath: $voiceFilePath, id: $id, hasUploaded: $hasUploaded, hasSend: $hasSend, isError: $isError, progress: $progress, isVoice: $isVoice, isImage: $isImage, isText: $isText, voiceLength: $voiceLength, imageUrl: $imageUrl, voiceUrl: $voiceUrl}';

  }
}