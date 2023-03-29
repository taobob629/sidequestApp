import 'dart:async';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/match_api.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/event_bus/beans/match_event.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../../model/beans/JumpMatchSucBean.dart';
import '../../../model/match/match_operation_model.dart';
import '../../../model/send_match_model.dart';

class SideKickMatchingController extends GetxController {
  late Timer timer;
  int seconds = 60 * 15;
  var countTime = "00:00".obs;

  late SendMatchModel model;

  StreamSubscription? subscription;

  @override
  void onInit() {
    super.onInit();

    model = Get.arguments as SendMatchModel;

    String? count = StorageManager.getCountDown();
    if (count != null) {
      seconds = (60 * 15) -
          DateTime.now().difference(DateTime.parse(count)).inSeconds;
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

    subscription = eventBus.on<MatchEvent>().listen((event) {
      _dealMatchSuc(event.msg.textElem!.text!);
    });
  }

  void _dealMatchSuc(String str) {
    Map<String, dynamic> map = json.decode(str);
    switch (map["type"]) {
      case 'match_order_boss':
        timer.cancel();
        subscription?.cancel();
        subscription = null;
        StorageManager.clear(StorageManager.kCountDown);

        MatchOperationModel matchOperationModel =
            MatchOperationModel.fromJson(map["message"]);

        JumpMatchSucBean bean = JumpMatchSucBean(
          memberCode: matchOperationModel.memberCode,
          orderId: matchOperationModel.orderId.toString(),
          avatar: matchOperationModel.avatar,
          nickname: matchOperationModel.nickname,
          sex: matchOperationModel.sex,
          age: matchOperationModel.age,
          stars: matchOperationModel.stars,
          levelNameEn: matchOperationModel.levelNameEn,
          tags: matchOperationModel.orderInfo.types,
          skillAuthId: matchOperationModel.skillAuthId,
          liveuid: matchOperationModel.liveuid,
          serviceItemId: matchOperationModel.serviceItemId,
          category: model.category,
          game: model.game,
          priceRange: '${model.minPrice}~${model.maxPrice}',
          unit: model.unit,
          launguage: model.language,
        );
        bean.ifPlayer = false;
        Get.offAndToNamed(
          AppPages.side_kick_match_suc_page,
          arguments: bean,
        );
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    subscription?.cancel();
    subscription = null;
  }

  void stopMatching() async {
    EasyLoading.show();
    MatchApi.stopMatch(model.orderId).whenComplete(() => EasyLoading.dismiss());

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
