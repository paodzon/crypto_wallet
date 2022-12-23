import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controller/eth_controller.dart';
import 'package:get/get.dart';

class Homepage extends GetView<EthereumController> {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Obx(() => controller.isLoading.isTrue
                  ? const CircularProgressIndicator()
                  : Text('Your Balance: ${controller.userBalance.value}')),
              IconButton(
                  onPressed: () => controller.getBalance(),
                  icon: const Icon(Icons.refresh, size: 20))
            ]),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller.amountController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Enter Amount'),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => controller
                      .depositCoin(int.parse(controller.amountController.text)),
                  child: const Text('Deposit')),
              ElevatedButton(
                  onPressed: () => controller.withdrawCoin(
                      int.parse(controller.amountController.text)),
                  child: const Text('Withdraw'))
            ],
          )
        ]),
      ),
    );
  }
}
