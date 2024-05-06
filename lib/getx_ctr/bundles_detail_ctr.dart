import 'package:get/get.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/index_api.dart';
import '../model/bundles_detail_model.dart';
import '../widget/tag/tag_bean.dart';

class BundlesDetailCtr extends GetxController {
  var tagList = <TagBean>[].obs;

  var model =
      BundlesDetailModel(stores: [], price: '0', originalPrice: '0').obs;

  var totalMoney = "0".obs;
  var count = 1.obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    model.value = await IndexApi.bundleDetail(Get.arguments.toString());
    dismissLoading();
    for (var element in model.value.stores) {
      tagList.add(TagBean(name: element, value: element));
    }

    totalMoney.value = model.value.price.mul(count.value.toString());
  }

  void addMoney() {
    count.value++;
    totalMoney.value = model.value.price.mul(count.value.toString());
  }

  void minusMoney() {
    if (count.value > 1) {
      count.value--;
      totalMoney.value = model.value.price.mul(count.value.toString());
    }
  }
}
