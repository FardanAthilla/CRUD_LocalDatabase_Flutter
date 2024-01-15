import 'package:get/get.dart';
import 'package:notebook/home_screen.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}