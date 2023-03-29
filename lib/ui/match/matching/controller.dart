import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
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

  void stopMatching() {
    StorageManager.clear(StorageManager.kCountDown);
    Get.back();

    // String text =
    //     '{"type":"match_order_boss","message":{"memberCode":"UK20021778","birthday":425692800,"levelNameEn":"Silver","sex":2,"nickname":"bob-prod2","avatar":"https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1671808367645.jpg","stars":0.00,"label":[],"age":39}}';
    // _dealMatchSuc(text);
  }

  void _formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    countTime.value = '$formattedMinutes:$formattedSeconds';
  }
}
