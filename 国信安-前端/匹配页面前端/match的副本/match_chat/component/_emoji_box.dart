part of '../view.dart';

class _EmojiContainer extends StatelessWidget {
  const _EmojiContainer({Key? key, required this.state, required this.logic}) : super(key: key);
  final MatchChatState state;
  final MatchChatLogic logic;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (state.isOpenEmoji) ? 300.h : 0,
      width: Get.width,
      child: GridView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        children: List.generate(
          40,
              (index) {
            return GestureDetector(
                onTap: () {
                  _addEmoji(index, logic.editingController);
                },
                child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('flutter_assets/assets/image/emoji/[汪汪].png')));
          },
        ),
      ),
    );
  }
  void _addEmoji(int index, TextEditingController editingController) {
    // final text = '[$index]';
    const text = '[汪汪]';
    final selection = editingController.selection;
    final start = selection.baseOffset;
    int end = selection.extentOffset;
    final value = editingController.value;

    if (selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }
      editingController.value = value.copyWith(
        text: newText,
        selection: selection.copyWith(
          baseOffset: end + text.length,
          extentOffset: end + text.length,
        ),
      );
    } else {
      editingController.value = TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ),
      );
    }
  }
}