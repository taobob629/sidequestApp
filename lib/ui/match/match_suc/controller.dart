import 'dart:async';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/match_api.dart';

import '../../../event_bus/beans/match_event.dart';
import '../../../event_bus/event_bus.dart';
import '../../../model/beans/JumpMatchSucBean.dart';
import '../../../model/match/match_operation_model.dart';
import '../../../utils/storage_manager.dart';
import '../../controller/user_controller.dart';
import '../../frame/main_page.dart';
import '../../frame/profile/play_order/play_order_page.dart';

class SideKickMatchSucController extends GetxController {

  var showOrHide = false.obs;

  var selectItemList = <JumpMatchSucBean>[].obs;

  var playerList = <JumpMatchSucBean>[].obs;

  late JumpMatchSucBean bean;

  StreamSubscription? subscription;

  @override
  void onInit() {
    super.onInit();

    final beans = Get.arguments as List<JumpMatchSucBean>;
    playerList.assignAll(beans);

    bean = playerList[0];

    subscription = eventBus.on<MatchEvent>().listen((event) {
      _dealMsg(event.msg.textElem!.text!);
    });
  }

  void _dealMsg(String str) {
    Map<String, dynamic> map = json.decode(str);
    switch (map["type"]) {
      case 'match_order_player_cancel':
        // 接单人取消
        final memberCode = map["message"]["removeUser"];
        playerList.removeWhere((element) => element.memberCode == memberCode);
        break;

      case 'match_order_boss_cancel':
        // 发单人取消，接单人如果还在这个页面则关闭
        if (bean.uid != UserController.find.userProfile.value.pwId) {
          Get.back();
        }
        break;

      case 'match_order_boss':
        // 通知boos，有人进来了
        MatchOperationModel matchOperationModel =
            MatchOperationModel.fromJson(map["message"]);

        JumpMatchSucBean sucBean = JumpMatchSucBean(
          distance: matchOperationModel.distance,
          uid: matchOperationModel.orderInfo.uid,
          price: matchOperationModel.price,
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
          category: bean.category,
          game: bean.game,
          priceRange: bean.priceRange,
          unit: bean.unit,
          launguage: bean.launguage,
        );

        if (!playerList.contains(sucBean)) {
          playerList.add(sucBean);
        }
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
    subscription?.cancel();
    subscription = null;
  }

  void showOrHideWidget() {
    showOrHide.value = !showOrHide.value;
  }

  void selectItem(int index) {
    if (selectItemList.contains(playerList[index])) {
      selectItemList.remove(playerList[index]);
    } else {
      selectItemList.add(playerList[index]);
    }
  }

  void cancelOrder() async {
    EasyLoading.show();
    await MatchApi.cancelAcceptMatchOrder(
        bean.orderId, bean.uid == UserController.find.userProfile.value.pwId);
    EasyLoading.dismiss();

    Get.back();
  }

  void playGame() async {
    EasyLoading.show();
    List<Map<String, int>> params = [];
    selectItemList.forEach((item) {
      Map<String, int> map = {
        "skillAuthId": item.skillAuthId,
        "liveuid": item.liveuid,
        "serviceItemId": item.serviceItemId,
      };

      params.add(map);
    });

    final result = await MatchApi.playGame(params);
    EasyLoading.dismiss();
    if (result != null) {
      var uk = await Get.to(
          () => MulitablePlayOrderPage(
                serviceItemList: result.serviceItems,
              ),
          arguments: bean.orderId);
      // flog('$res', 'Get.to(()=>PlayOrder');
      if (uk != null) {
        Get.back();
        if (uk == 0) {
          MainPageController.find.currentIndex.value = 3;
          MainPageController.find.controller.jumpToPage(3);
        } else {
          UserController.find.jumpChat(uk);
        }
      }
    }
  }
}
