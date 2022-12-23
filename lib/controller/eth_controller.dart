import 'package:flutter/cupertino.dart';
import 'package:frontend/app/utils/eth_utils.dart';
import 'package:get/get.dart';

class EthereumController extends GetxController {
  RxDouble userBalance = 0.0.obs;
  RxBool isLoading = false.obs;
  TextEditingController amountController = TextEditingController();
  final EthereumUtils ethUtils = EthereumUtils();

  @override
  void onInit() {
    ethUtils.initialSetup();
    getBalance();
    super.onInit();
  }

  Future getBalance() async {
    try {
      final response = await ethUtils.getBalance();
      userBalance.value = double.parse(response.toString());
      print(userBalance);
    } catch (err) {
      return err;
    }
  }

  Future withdrawCoin(int amount) async {
    isLoading.value = true;
    try {
      if (amount < userBalance.value) {
        userBalance.value = userBalance.value - amount;
        final response = await ethUtils.withdrawCoin(amount);
        print(response);
        isLoading.value = false;
        return response;
      } else {
        return null;
      }
    } catch (err) {
      isLoading.value = false;
      return err;
    }
  }

  Future depositCoin(int amount) async {
    isLoading.value = true;
    try {
      userBalance.value = userBalance.value + amount;
      final response = await ethUtils.depositCoin(amount);
      isLoading.value = false;
      return response;
    } catch (err) {
      isLoading.value = false;
      return err;
    }
  }
}
