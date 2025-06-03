import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_info_model.dart';
import '../../../../../utils/toast_utils.dart';
import '../integral_detail_page.dart';

class IntegralRedemptionCtr extends GetxController
    with GetTickerProviderStateMixin {
  var selectStatus = 0.obs;

  var tabs = <String>[].obs;
  var goods = [].obs;
  var selectGoods = [].obs;

  var integralInfoModel =
      IntegralInfoModel(appSign: [], lvList: [], webSign: []).obs;

  @override
  void onInit() {
    super.onInit();

    requestPoints();
    requestData();
  }

  void requestPoints() async {
    final response = await http.get('/app/point/info');
    integralInfoModel.value = IntegralInfoModel.fromJson(response.data);
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/app/point/pointGoods');
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

  void exchange(id) async {
    final result = await Get.to(() => IntegralDetailPage(), arguments: id);
    if (result != null) {
      requestPoints();
    }
  }
}
