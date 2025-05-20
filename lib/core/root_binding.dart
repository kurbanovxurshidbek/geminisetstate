import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controllers/home_controller.dart';
import '../controllers/starter_controller.dart';


class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StarterController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}