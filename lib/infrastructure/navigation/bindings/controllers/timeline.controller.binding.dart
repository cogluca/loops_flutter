import 'package:get/get.dart';

import '../../../../presentation/timeline/controllers/timeline.controller.dart';

class TimelineControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimelineController>(
      () => TimelineController(),
    );
  }
}
