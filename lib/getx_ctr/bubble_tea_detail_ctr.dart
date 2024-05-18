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
  var count = 1.obs;

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

    calculateTotalPrice();
  }

  void addToCart() {
    showAddToCart.value = false;
    calculateOutPrice();
  }

  void addMoney() {
    count.value++;

    calculateTotalPrice();
    calculateOutPrice();
  }

  void calculateTotalPrice() {
    // 选择参数后的价格
    String paramsPrice = (model.value.selectSize?.value ?? "0")
        .add(model.value.selectIce?.value ?? "0")
        .add(model.value.selectSugar?.value ?? "0")
        .add(model.value.selectTopping[0].value);
    if (model.value.selectTopping.length > 1) {
      paramsPrice = (model.value.selectSize?.value ?? "0")
          .add(model.value.selectIce?.value ?? "0")
          .add(model.value.selectSugar?.value ?? "0")
          .add(model.value.selectTopping[0].value)
          .add(model.value.selectTopping[1].value);
    }

    totalMoney.value =
        (model.value.price ?? "0").add(paramsPrice).mul(count.value.toString());
  }

  void minusMoney() {
    if (count.value > 1) {
      count.value--;
      calculateTotalPrice();

      calculateOutPrice();
    } else {
      count.value = 1;
      calculateTotalPrice();
      showAddToCart.value = true;

      TabBubbleTeaCtr.find.selectTeaList.clear();
      TabBubbleTeaCtr.find.calculateTotal();
    }
  }

  void calculateOutPrice() {
    GoodsDetailModel cacheModel = GoodsDetailModel.deepCopy(model.value);
    cacheModel.count = count.value;

    bool isContains = TabBubbleTeaCtr.find.selectTeaList.contains(cacheModel);
    if (isContains) {
      TabBubbleTeaCtr.find.selectTeaList.remove(cacheModel);
    }
    TabBubbleTeaCtr.find.selectTeaList.add(cacheModel);

    TabBubbleTeaCtr.find.calculateTotal();
  }

  void selectSize(TagBean tagBean) {
    model.value.selectSize = tagBean;
    calculateTotalPrice();
  }

  void selectIce(TagBean tagBean) {
    model.value.selectIce = tagBean;
    calculateTotalPrice();
  }

  void selectSugar(TagBean tagBean) {
    model.value.selectSugar = tagBean;
    calculateTotalPrice();
  }

  void selectToppings(TagBean tagBean, bool isAdd) {
    model.value.selectTopping.removeWhere((element) =>
        element.name == tagBean.name && element.value == tagBean.value);
    if (isAdd) {
      model.value.selectTopping.add(tagBean);
    }
    calculateTotalPrice();
  }
}
