import 'package:get/get.dart';

import '../../../../presentation/Backlog/controllers/backlog.controller.dart';

class BacklogControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BacklogController>(
      () => BacklogController(),
    );
  }
}
