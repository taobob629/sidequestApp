import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/match_api.dart';

import '../../../model/beans/JumpMatchSucBean.dart';

class SideKickMatchSucController extends GetxController {
  var showOrHide = false.obs;

  var selectItemList = <JumpMatchSucBean>[].obs;

  var playerList = <JumpMatchSucBean>[].obs;

  late JumpMatchSucBean bean;

  @override
  void onInit() {
    super.onInit();

    bean = Get.arguments as JumpMatchSucBean;

    playerList.add(bean);
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
    await MatchApi.cancelAcceptMatchOrder(bean.orderId, bean.ifPlayer);
    EasyLoading.dismiss();

    if (bean.ifPlayer == true) {
      Get.back();
    }
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
  }
}
