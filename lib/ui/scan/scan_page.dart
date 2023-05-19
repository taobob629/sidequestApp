import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan/scan.dart';
import 'package:wy/ui/common/base_scaffold.dart';

class ScanPage extends StatelessWidget {

  final controller = Get.put(ScanPageController());
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Scan QR code".tr,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            child: ScanView(
              controller: controller.controller,
              scanAreaScale: .7,
              scanLineColor: Colors.green.shade400,
              onCapture: (data) {

                Get.back(result: data);
              },
            ),
        )
      ),
    );
  }
}

class ScanPageController extends GetxController {
  late ScanController controller;

  @override
  void onInit() {
    super.onInit();
    controller = ScanController();
  }

  @override
  void onClose() {
    super.onClose();
  }
}