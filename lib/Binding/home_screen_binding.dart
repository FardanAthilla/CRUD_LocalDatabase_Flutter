import 'package:get/get.dart';
import 'package:notebook/Controller/home_controller.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}