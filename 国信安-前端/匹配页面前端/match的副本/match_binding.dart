import 'package:get/get.dart';

import 'match_logic.dart';

class MatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MatchLogic());
  }
}
