part of '../view.dart';
class _RecordVoiceButton extends StatelessWidget {
  const _RecordVoiceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MatchChatLogic>();
    final state = Get.find<MatchChatLogic>().state;
    return GetX<MatchChatLogic>(
      builder: (controller) {
        return GestureDetector(
          onTapDown: (result) {
            logic.startRecord();
          },
          onTapUp: (result) {
            logic.stopRecord();
          },
          onTapCancel: () {
            logic.cancelRecord();
          },
          child: Container(
              width: Get.width - 64.w - 33.w - 10.w - 28.r,
              height: 50.h,
              color: state.isRecording
                  ? Colors.grey[600]
                  : Colors.grey[200],
              child: Center(
                child: Text(
                  state.isRecording ? "松开 结束" : "按住 说话",
                  style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                ),
              )),
        );
      },
    );
  }
}