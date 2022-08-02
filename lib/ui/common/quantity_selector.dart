import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuantitySelector extends StatelessWidget {

  late final QuantitySelectorController controller;

  QuantitySelector({
    required String tag,
    required int initValue,
    required Function(int) onQuantityChanged}){
    controller = Get.put(
      QuantitySelectorController(
        initValue: initValue,
        onQuantityChanged: onQuantityChanged
      ),
      tag :tag
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: Colors.white10
      ),
      child: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => controller.minus(),
              child: Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    height: 2.0,
                    width: 14,
                    color: controller.quantity > 1 ? Colors.white : Colors.white38,
                  ),
                ),
              ),
            ),
            Container(
              width: 40,
              child: Center(
                child: Text("${controller.quantity}", style: TextStyle(color: Colors.white, fontSize: 15),)
              ),
            ),
            GestureDetector(
              onTap: () => controller.plus(),
              child: Icon(Icons.add, size: 24, color: Colors.white,)
            )
          ],
        );
      }),
    );
  }
}

class QuantitySelectorController extends GetxController {

  late Function(int) onQuantityChanged;
  var quantity = 1.obs;

  QuantitySelectorController({
    required int initValue,
    required this.onQuantityChanged
  }){
    this.quantity.value = initValue;
  }

  void minus() {
    if (quantity > 1) {
      quantity -= 1;
      onQuantityChanged.call(quantity.value);
    }
  }

  void plus() {
    quantity += 1;
    onQuantityChanged.call(quantity.value);
  }
}