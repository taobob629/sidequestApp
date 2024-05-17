import 'package:get/get.dart';
import 'package:sq_hub_app/api/hubs_api.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../model/goods_detail_model.dart';
import '../widget/tag/tag_bean.dart';

class BubbleTeaDetailCtr extends GetxController {
  var model =
      GoodsDetailModel(cpusize: [], ice: [], topping: [], sugar: []).obs;
  var sizeTags = <TagBean>[].obs;
  var iceTags = <TagBean>[].obs;
  var toppingTags = <TagBean>[].obs;
  var sugarTags = <TagBean>[].obs;

  var totalMoney = "0".obs;
  var count = 0.obs;

  late Map<String, dynamic> map;

  var showAddToCart = true.obs;

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

    totalMoney.value = model.value.price.toString();

    sizeTags.clear();
    model.value.cpusize.forEach((element) {
      sizeTags.add(
          TagBean(name: element.name, value: element.price.toStringAsFixed(2)));
    });
    iceTags.clear();
    model.value.ice.forEach((element) {
      iceTags.add(
          TagBean(name: element.name, value: element.price.toStringAsFixed(2)));
    });
    toppingTags.clear();
    model.value.topping.forEach((element) {
      toppingTags.add(
          TagBean(name: element.name, value: element.price.toStringAsFixed(2)));
    });
    sugarTags.clear();
    model.value.sugar.forEach((element) {
      sugarTags.add(
          TagBean(name: element.name, value: element.price.toStringAsFixed(2)));
    });

    if (sizeTags.isNotEmpty) {
      model.value.selectSize = sizeTags[0];
    }
    if (iceTags.isNotEmpty) {
      model.value.selectIce = iceTags[0];
    }
    if (sugarTags.isNotEmpty) {
      model.value.selectSugar = sugarTags[0];
    }
    if (toppingTags.isNotEmpty) {
      model.value.selectTopping.assign(toppingTags[0]);
    }
  }

  void addToCart() {
    showAddToCart.value = false;
    count.value++;
    calculatePrice();
  }

  void addMoney() {
    count.value++;
    totalMoney.value = (model.value.price ?? "0").mul(count.value.toString());

    calculatePrice();
  }

  void minusMoney() {
    if (count.value > 1) {
      count.value--;
      totalMoney.value = (model.value.price ?? "0").mul(count.value.toString());

      calculatePrice();
    }
  }

  void calculatePrice() {
    GoodsDetailModel cacheModel = GoodsDetailModel.deepCopy(model.value);
    cacheModel.count = count.value;

    final result =
    TabBubbleTeaCtr.find.selectTeaList.firstWhereOrNull((element) {
      if (cacheModel.selectTopping.length == 1) {
        return element.id == cacheModel.id &&
            element.brief == cacheModel.brief &&
            element.image == cacheModel.image &&
            element.price == cacheModel.price &&
            element.name == cacheModel.name &&
            element.selectSize?.name == cacheModel.selectSize?.name &&
            element.selectSize?.value == cacheModel.selectSize?.value &&
            element.selectIce?.name == cacheModel.selectIce?.name &&
            element.selectIce?.value == cacheModel.selectIce?.value &&
            element.selectIce?.name == cacheModel.selectIce?.name &&
            element.selectIce?.value == cacheModel.selectIce?.value &&
            element.selectSugar?.name == cacheModel.selectSugar?.name &&
            element.selectSugar?.value == cacheModel.selectSugar?.value &&
            element.selectTopping[0].name == cacheModel.selectTopping[0].name;
      } else {
        return element.id == cacheModel.id &&
            element.brief == cacheModel.brief &&
            element.image == cacheModel.image &&
            element.price == cacheModel.price &&
            element.name == cacheModel.name &&
            element.selectSize?.name == cacheModel.selectSize?.name &&
            element.selectSize?.value == cacheModel.selectSize?.value &&
            element.selectIce?.name == cacheModel.selectIce?.name &&
            element.selectIce?.value == cacheModel.selectIce?.value &&
            element.selectIce?.name == cacheModel.selectIce?.name &&
            element.selectIce?.value == cacheModel.selectIce?.value &&
            element.selectSugar?.name == cacheModel.selectSugar?.name &&
            element.selectSugar?.value == cacheModel.selectSugar?.value &&
            element.selectTopping[0].name == cacheModel.selectTopping[0].name &&
            element.selectTopping[1].name == cacheModel.selectTopping[1].name;
      }
    });
    if (result == null) {
      TabBubbleTeaCtr.find.selectTeaList.add(cacheModel);
    } else {
      TabBubbleTeaCtr.find.selectTeaList.remove(result);
      TabBubbleTeaCtr.find.selectTeaList.add(cacheModel);
    }

    TabBubbleTeaCtr.find.calculateTotal();
  }
}
