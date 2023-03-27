import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wy/event_bus/beans/match_event.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../../model/match_init_model.dart';
import '../filter/controller.dart';

class SideKickMatchingController extends GetxController {
  var sideKickTypes = [
    'Lengends',
    'Male',
  ];

  late Timer timer;
  int seconds = 60 * 15;
  var countTime = "00:00".obs;

  List<Language> others = [];

  StreamSubscription? subscription;

  @override
  void onInit() {
    super.onInit();

    String? count = StorageManager.getCountDown();
    if (count != null) {
      seconds = (60 * 15) - DateTime.now().difference(DateTime.parse(count)).inSeconds;
    } else {
      StorageManager.setCountDown(DateTime.now().toString());
    }
    timer = Timer.periodic(const Duration(seconds: 1), (v) {
      if (seconds > 0) {
        seconds--;
        _formatTime();
      } else {
        timer.cancel();
        stopMatching();
      }
    });

    final ctr = Get.find<SideKickMatchController>();
    others = ctr.others;

    subscription = eventBus.on<MatchEvent>().listen((event) {

    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    subscription?.cancel();
    subscription = null;
  }

  void stopMatching() {
    StorageManager.clear(StorageManager.kCountDown);
    Get.back();
  }

  void _formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    countTime.value = '$formattedMinutes:$formattedSeconds';
  }
}
