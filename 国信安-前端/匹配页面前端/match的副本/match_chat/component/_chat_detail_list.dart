part of '../view.dart';

class _ChatDetailList extends StatelessWidget {
  _ChatDetailList();

  final logic = Get.find<MatchChatLogic>();
  final state = Get
      .find<MatchChatLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    return GetX<MatchChatLogic>(
      init: logic,
      builder: (matchController) {
        return AnimatedList(
            controller: matchController.scrollController,
            key: logic.$key,
            initialItemCount: state.recordsLength,
            itemBuilder: (context, index, animation) {
              return ScaleTransition(
                key: ValueKey(state.records[index].id),
                alignment: state.records[index].sender == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                scale: animation,
                child: GestureDetector(
                  onLongPress: () {
                    if(state.records[index].content == null){
                      return;
                    }
                    showBottomSheet(index, state.records[index].content,
                        state.records[index].sender);
                  },
                  onTap: () {
                    if (state.records[index].voiceFilePath != null || state.records[index].voiceUrl != null) {
                      if (state.records[index].voiceUrl == null) {
                        matchController.playRecord(state.records[index]
                            .voiceFilePath!);
                      } else {
                        matchController.playRecord(state.records[index]
                            .voiceUrl!);
                      }
                    }
                  },
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.w),
                    child: Row(
                      mainAxisAlignment: state.records[index].sender == 0
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        state.records[index].sender == 0
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              state.matchType == 0
                                  ? state.avatar1.value
                                  : state.avatar2.value),
                        )
                            : Container(),

                        Obx(() {
                          return state.records[index].sender == 1
                              ? state.records[index].isError.value == true
                              ? Icon(Icons.error, color: Colors.red, size: 20.r,)
                              : (state.records[index].hasSend.value != true || state.records[index].hasUploaded.value != true)
                              ? CircularProgressIndicator(value: state.records[index].progress.value)
                              : Container()
                              : Container();
                        }),

                        Obx(() {
                          return SizedBox(
                            child: (state.records[index].filePath != null ||
                                state.records[index].imageUrl != null)
                            //图片消息
                                ? Container(
                              constraints: BoxConstraints(
                                maxHeight: 450.h,
                                maxWidth: 260.w,
                              ),
                              margin: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: state.records[index].filePath != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: HeroImage(
                                    filePath: state.records[index].filePath,
                                    isCover: true,
                                    tag: DateTime.now().microsecondsSinceEpoch.toString(),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: HeroImage(
                                    url: state.records[index].imageUrl,
                                    isCover: true,
                                    tag: DateTime.now().microsecondsSinceEpoch.toString(),
                                ),
                              ),
                            )
                            //语音消息
                                : (state.records[index].voiceFilePath != null ||
                                state.records[index].voiceUrl != null)
                                ? Container(
                                    padding: EdgeInsets.all(11.r),
                                    alignment: state.records[index].sender != 0
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                                    height: 40.h,
                                    width: int.parse(state.records[index].content) >
                                        40
                                        ? 200.w
                                        : int.parse(state.records[index].content) <= 4
                                        ? 70.w
                                        : int.parse(state.records[index].content) *
                                        16.w,
                                    decoration: BoxDecoration(
                                        color: state.records[index].sender == 0
                                            ? Colors.greenAccent
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(10.r)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (state.records[index].sender != 0)
                                          Text(
                                              "${state.records[index].content == "0"
                                                  ? "1"
                                                  : state.records[index].content}”"),
                                        Transform.rotate(
                                          angle: state.records[index].sender == 0
                                              ? pi / 2
                                              : pi / 2 * 3,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 6.w),
                                            child: const Icon(Icons.wifi),
                                          ),
                                        ),
                                        if (state.records[index].sender == 0)
                                          Text(
                                              "${state.records[index].content == "0"
                                                  ? "1"
                                                  : state.records[index].content}”"),
                                ],
                              ),
                            )
                            //文字消息
                                : Container(
                                    constraints: BoxConstraints(
                                      maxHeight: 480.h,
                                      maxWidth: 260.w,
                                    ),
                                    padding: EdgeInsets.all(7.r),
                                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                                    decoration: BoxDecoration(
                                        color: state.records[index].sender == 0
                                            ? Colors.greenAccent
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(10.r)),
                                    child: ExtendedText(
                                          "${state.records[index].content}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                      specialTextSpanBuilder: UpSpecialTextSpanBuilder(),
                                    ),
                            ),
                          );
                        }),

                        Obx(() {
                          return state.records[index].sender == 0
                              ? state.records[index].isError.value == true
                              ? Icon(Icons.error, color: Colors.red, size: 20.r,)
                              : (state.records[index].hasSend.value != true || state.records[index].hasUploaded.value != true)
                              ? CircularProgressIndicator(value: state.records[index].progress.value) : Container()
                              : Container();
                        }),

                        state.records[index].sender == 1
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              state.matchType == 1
                                  ? state.avatar1.value
                                  : state.avatar2.value),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void showBottomSheet(int index, String text, int sender) {
    Get.bottomSheet(
        Wrap(
          children: [
            sender == 1
                ? ListTile(
              leading: const Icon(Icons.backspace_outlined),
              title: const Text("撤回消息"),
              onTap: () {
                Get.back();
                String id = state.records[index].id;
                int sender = state.records[index].sender;
                logic.removeAt(index);
                logic.$key.currentState?.removeItem(index, (context, animation) {
                  return logic.cancelMessageView(sender, animation);
                }, duration: const Duration(milliseconds: 200));
                logic.sendCancelMessageToServer(id);
              },
            )
                : Container(),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("复制内容"),
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                SmartDialog.showToast("已复制");
                Get.back();
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey);
  }

}
