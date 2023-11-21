import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/utils/index.dart';

class ScanPage extends StatelessWidget {

  final controller = Get.put(ScanPageController());
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Scan QR code".tr,
      body: Container(),
    );
  }
}

class ScanPageController extends GetxController {

  Future<void> scan() async {
    try {
      final result = await BarcodeScanner.scan(
          options: ScanOptions()
      );
      Get.back(result: result.rawContent);
    } on PlatformException catch (e) {
      flog(e.stacktrace);
    }
  }

  @override
  void onInit() {
    super.onInit();
    scan();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
