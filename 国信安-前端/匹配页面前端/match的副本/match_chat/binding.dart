import 'package:get/get.dart';
import 'package:second/ui/pages/match/match_chat/logic.dart';


class MatchChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MatchChatLogic());
  }
}
