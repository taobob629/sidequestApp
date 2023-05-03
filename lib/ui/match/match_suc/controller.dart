import 'dart:async';
import 'dart:convert';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/match_api.dart';
import 'package:wy/model/beans/jump_match_suc_bean.dart';

import '../../../event_bus/beans/match_event.dart';
import '../../../event_bus/event_bus.dart';
import '../../../model/match/match_operation_model.dart';
import '../../../utils/toast_utils.dart';
import '../../common/dialog_show_info.dart';
import '../../controller/user_controller.dart';
import '../../frame/main_page.dart';
import '../../frame/profile/other_profile/mdoel/player_info_mdoel.dart';
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
      _dealMsg(event.msg.customElem!.data!);
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
        if (bean.uid != UserController.find.userProfile.pwId) {
          Get.back();
          showInfoDialog(map['content']);
        }
        break;

      case 'match_order_boss':
        // 通知boos，有人进来了
        MatchOperationModel matchOperationModel = MatchOperationModel.fromJson(map["message"]);
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
    showLoading();
    await MatchApi.cancelAcceptMatchOrder(bean.orderId, bean.uid == UserController.find.userProfile.pwId);
    dismissLoading();

    Get.back();
  }

  void playGame() async {
    showLoading();
    List<Map<String, int>> params = [];
    selectItemList.forEach((item) {
      Map<String, int> map = {"skillAuthId": item.skillAuthId, "liveuid": item.liveuid, "serviceItemId": item.serviceItemId, "nums": UserController.find.nums};

      params.add(map);
    });

    final result = await MatchApi.playGame(params);
    dismissLoading();
    if (result != null) {
      List<ServiceItem> serviceItems = result.serviceItems;
      serviceItems.forEach((element) {
        element.num.value = UserController.find.nums;
      });

      var uk = await Get.to(
          () => MulitablePlayOrderPage(
                serviceItemList: serviceItems,
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
