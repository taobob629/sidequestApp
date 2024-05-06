import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../utils/toast_utils.dart';

class IntegralRedemptionCtr extends GetxController
    with GetTickerProviderStateMixin {
  var selectStatus = 0.obs;

  int? points;

  var tabs = <String>[].obs;
  var goods = [].obs;
  var selectGoods = [].obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    points = Get.arguments;
    showLoading();
    final response = await http.get('/web/app/integral/pointGoods');
    dismissLoading();
    Map<String, dynamic> goodsMap = response.data;
    tabs.value = goodsMap.keys.toList();
    goods.value = goodsMap.values.toList();
    selectGoods.value = goods[0];
  }

  void selectTab(int i) {
    selectStatus.value = i;
    selectGoods.value = goods[i];
  }
}
