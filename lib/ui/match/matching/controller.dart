import 'dart:async';

import 'package:get/get.dart';

class SideKickMatchingController extends GetxController {
  var sideKickTypes = [
    'Lengends',
    'Male',
  ];

  late Timer timer;
  int seconds = 0;
  var countTime = "00:00".obs;

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (v) {
      seconds++;
      _formatTime();
    });
  }

  void _formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    countTime.value = '$formattedMinutes:$formattedSeconds';
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }
}
