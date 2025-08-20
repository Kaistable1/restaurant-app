import 'package:get/get.dart';

import '../controllers/streams_controller.dart';

class StreamsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoController>(
      () => VideoController(),
    );
  }
}
