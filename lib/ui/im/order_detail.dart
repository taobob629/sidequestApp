import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/base_scaffold.dart';

class OrderDetail extends StatelessWidget {

  final controller = Get.put(OrderDetailController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Play Order Detail",
      body: Stack(
        children: [
          Positioned(
            left: 0,right: 0,top: 0,bottom: 0,
            child: SingleChildScrollView(
              child: Obx(()=>Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(height: 120,)
                ],
              ))
            ),
          ),
        ],
      )
    );
  }
}

class OrderDetailController extends GetxController {

}