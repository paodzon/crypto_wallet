import 'package:frontend/controller/eth_controller.dart';
import 'package:get/get.dart';

class EthereumBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EthereumController());
  }
}
