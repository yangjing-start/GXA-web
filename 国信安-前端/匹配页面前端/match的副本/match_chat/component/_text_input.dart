part of '../view.dart';

class _TextView extends StatelessWidget {
   const _TextView({
    required this.onSubmitted,
    required this.onEditingTap,
    required this.editingController,
    required this.focusNode,
    Key? key}) : super(key: key);
  final void Function(String)? onSubmitted;
  final void Function()? onEditingTap;
  final FocusNode focusNode;
  final TextEditingController? editingController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: ColoredBox(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white30
              : const Color(0xFF2A3942),
          child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.h),
            child: _TextInput(
              onSubmitted: onSubmitted,
              onEditingTap: onEditingTap,
              editingController: editingController,
              focusNode: focusNode,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  _TextInput(
      {required this.onSubmitted,
       required this.onEditingTap,
       required this.editingController,
       required this.focusNode,
      Key? key})
      : super(key: key);
  final void Function(String)? onSubmitted;
  final void Function()? onEditingTap;
  final FocusNode focusNode;
  final TextEditingController? editingController;

  final MatchChatLogic matchController = Get.find<MatchChatLogic>();

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      onSubmitted: onSubmitted,
      keyboardAppearance: Brightness.dark,
      style: TextStyle(fontSize: 15.sp),
      onTap: onEditingTap,
      minLines: 1,
      maxLines: 6,
      focusNode: focusNode,
      onEditingComplete: onEditingTap,
      controller: editingController,
      cursorColor: const Color(0xff5b92e2),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      selectionControls: Platform.isIOS
          ? CupertinoTextSelectionControls()
          : MaterialTextSelectionControls(),
      specialTextSpanBuilder: UpSpecialTextSpanBuilder(),
    );
  }
}
