import 'package:get/get.dart';
import 'package:sq_hub_app/api/hubs_api.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../model/goods_detail_model.dart';
import '../widget/tag/tag_bean.dart';

class BubbleTeaDetailCtr extends GetxController {

  var model = GoodsDetailModel(cpusize: [], ice: [], topping: [], sugar: []).obs;
  var sizeTags = <TagBean>[].obs;
  var iceTags = <TagBean>[].obs;
  var toppingTags = <TagBean>[].obs;
  var sugarTags = <TagBean>[].obs;

  var totalMoney = "0".obs;
  var count = 1.obs;

  late Map<String, dynamic> map;

  @override
  void onInit() {
    super.onInit();

    map = Get.arguments as Map<String, dynamic>;
    requestData();
  }

  void requestData() async {
    showLoading();
    model.value = await HubsApi.goodDetail(map["id"]);
    dismissLoading();

    totalMoney.value = (model.value.price ?? "0").mul(count.value.toString());

    sizeTags.clear();
    model.value.cpusize.forEach((element) {
      sizeTags.add(TagBean(name: element, value: element));
    });
    iceTags.clear();
    model.value.ice.forEach((element) {
      iceTags.add(TagBean(name: element, value: element));
    });
    toppingTags.clear();
    model.value.topping.forEach((element) {
      toppingTags.add(TagBean(name: element, value: element));
    });
    sugarTags.clear();
    model.value.sugar.forEach((element) {
      sugarTags.add(TagBean(name: element, value: element));
    });
  }

  void addTea() {
    TabBubbleTeaCtr.find.addTea(map["index"]);
  }

  void addMoney() {
    count.value += 1;

    totalMoney.value = (model.value.price ?? "0").mul(count.value.toString());
  }

  void minusMoney() {
    if (count.value > 1) {
      count.value -= 1;

      totalMoney.value = (model.value.price ?? "0").mul(count.value.toString());
    }
  }
}
