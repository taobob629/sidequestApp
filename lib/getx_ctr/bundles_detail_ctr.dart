import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/home/tab_bundles_page.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/index_api.dart';
import '../model/bundles_detail_model.dart';
import '../ui/pages/home/bundle_confirm_order_page.dart';
import '../widget/tag/tag_bean.dart';

class BundlesDetailCtr extends GetxController {
  var model = BundlesDetailModel(
    stores: [],
    price: '0',
    originalPrice: '0',
  ).obs;

  late Map map;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    map = Get.arguments as Map;
    requestData();
  }

  void requestData() async {
    showLoading();
    model.value = await IndexApi.bundleDetail(map['id'].toString());
    dismissLoading();
    isLoading.value = false;
  }

  void addTea() async {
    TabBundlesPageController.find.addTea(map['index']);
    await Get.to(() => BundleConfirmOrderPage());
    TabBundlesPageController.find.clearTea();
  }
}
