import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/api/hubs_api.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../controller/user_controller.dart';
import '../model/goods_detail_model.dart';
import '../model/pay_order_model.dart';
import '../ui/pages/hubs/bubble_confirm_order_page.dart';
import '../utils/navigator_helper.dart';
import '../widget/tag/tag_bean.dart';

class BubbleTeaDetailCtr extends GetxController {
  var model = GoodsDetailModel(
    cpusize: [],
    ice: [],
    topping: [],
    sugar: [],
  ).obs;
  var sizeTags = <TagBean>[].obs;
  var iceTags = <TagBean>[].obs;
  var toppingTags = <TagBean>[].obs;
  var sugarTags = <TagBean>[].obs;

  var totalMoney = "0".obs;

  var quantity = 1.obs;

  var optionsRevision = 0.obs;

  var isLoading = true.obs;

  var loadError = ''.obs;

  int _requestSerial = 0;

  var showAddToCart = true.obs;

  late BuildContext cartContext;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> requestData(int? productId) async {
    final requestSerial = ++_requestSerial;
    isLoading.value = true;
    loadError.value = '';

    if (productId == null) {
      loadError.value = 'Product information is unavailable';
      isLoading.value = false;
      return;
    }

    try {
      final detail = await HubsApi.goodDetail(productId);
      if (requestSerial != _requestSerial) return;
      model.value = detail;

      sizeTags.assignAll(
        model.value.cpusize.map(
          (element) => TagBean(
            name: element.name,
            value: element.price.toStringAsFixed(2),
          ),
        ),
      );
      iceTags.assignAll(
        model.value.ice.map(
          (element) => TagBean(
            name: element.name,
            value: element.price.toStringAsFixed(2),
          ),
        ),
      );
      toppingTags.assignAll(
        model.value.topping.map(
          (element) => TagBean(
            name: element.name,
            value: element.price.toStringAsFixed(2),
          ),
        ),
      );
      sugarTags.assignAll(
        model.value.sugar.map(
          (element) => TagBean(
            name: element.name,
            value: element.price.toStringAsFixed(2),
          ),
        ),
      );

      initParamsAndPrice();
    } catch (_) {
      if (requestSerial == _requestSerial) {
        loadError.value =
            'Unable to load this product. Please check your connection.';
      }
    } finally {
      if (requestSerial == _requestSerial) {
        isLoading.value = false;
      }
    }
  }

  void initParamsAndPrice() {
    final result = findModelFromSelectTeaList(model.value);
    if (result != null) {
      showAddToCart.value = false;
      // 找到了
      model.value.selectSize = result.selectSize;
      model.value.selectIce = result.selectIce;
      model.value.selectSugar = result.selectSugar;
      model.value.selectTopping = result.selectTopping;
      _setQuantity(result.count);
    } else {
      showAddToCart.value = true;
      _setQuantity(1);
      if (sizeTags.isNotEmpty) {
        model.value.selectSize = sizeTags[0];
      }
      if (iceTags.isNotEmpty) {
        model.value.selectIce = iceTags[0];
      }
      if (sugarTags.isNotEmpty) {
        model.value.selectSugar = sugarTags[0];
      }
    }

    calculateTotalPrice(true);
    optionsRevision.value++;
  }

  GoodsDetailModel? findModelFromSelectTeaList(GoodsDetailModel model) {
    GoodsDetailModel? findModel = TabBubbleTeaCtr.find.selectTeaList
        .lastWhereOrNull((element) => element.id == model.id);
    return findModel;
  }

  void addToCart() {
    if (model.value.selectSize == null) {
      showToast("Please select at least one size");
      return;
    }
    if (model.value.selectIce == null) {
      showToast("Please select at least one size");
      return;
    }
    if (model.value.selectSugar == null) {
      showToast("Please select at least one size");
      return;
    }
    showAddToCart.value = false;
    calculateOutPrice();
  }

  void addMoney() {
    _setQuantity(quantity.value + 1);

    calculateTotalPrice(false);
    calculateOutPrice();
  }

  void minusMoney() {
    if (quantity.value > 1) {
      _setQuantity(quantity.value - 1);
      calculateTotalPrice(false);

      calculateOutPrice();
    } else {
      _setQuantity(1);
      showAddToCart.value = true;
      TabBubbleTeaCtr.find.selectTeaList.remove(model.value);
      calculateTotalPrice(false);

      if (TabBubbleTeaCtr.find.totalCount.value == 0) {
        TabBubbleTeaCtr.find.discount.value = "0.0";
        TabBubbleTeaCtr.find.selectTeaList.clear();
        dismissLoading();
      }
      TabBubbleTeaCtr.find.calculateTotal();
    }
  }

  void calculateOutPrice() {
    GoodsDetailModel cacheModel = GoodsDetailModel.deepCopy(model.value);
    cacheModel.count = model.value.count;

    bool isContains = TabBubbleTeaCtr.find.selectTeaList.contains(cacheModel);
    if (isContains) {
      TabBubbleTeaCtr.find.selectTeaList.remove(cacheModel);
    }
    TabBubbleTeaCtr.find.selectTeaList.add(cacheModel);

    TabBubbleTeaCtr.find.calculateTotal();
  }

  void calculateTotalPrice(bool isFound) {
    // 选择参数后的价格
    String paramsPrice = (model.value.selectSize?.value ?? "0")
        .add(model.value.selectIce?.value ?? "0")
        .add(model.value.selectSugar?.value ?? "0");
    if (model.value.selectTopping.length == 1) {
      paramsPrice = paramsPrice.add(model.value.selectTopping[0].value);
    } else if (model.value.selectTopping.length == 2) {
      paramsPrice = paramsPrice
          .add(model.value.selectTopping[0].value)
          .add(model.value.selectTopping[1].value);
    }

    totalMoney.value = (model.value.price ?? "0").add(paramsPrice);

    if (isFound) {
      // 查找匹配的 GoodsDetailModel 对象
      GoodsDetailModel? foundGoods = TabBubbleTeaCtr.find.selectTeaList
          .firstWhereOrNull((goods) => goods.equalsIgnoringCount(model.value));
      if (foundGoods != null) {
        showAddToCart.value = false;
        _setQuantity(foundGoods.count);
      } else {
        _setQuantity(1);
        showAddToCart.value = true;
      }
    }
  }

  void selectSize(TagBean tagBean, bool isAdd) {
    if (isAdd) {
      model.value.selectSize = tagBean;
      calculateTotalPrice(true);
    }
  }

  void selectIce(TagBean tagBean, bool isAdd) {
    model.value.selectIce = isAdd ? tagBean : null;
    calculateTotalPrice(true);
  }

  void selectSugar(TagBean tagBean, bool isAdd) {
    model.value.selectSugar = isAdd ? tagBean : null;
    calculateTotalPrice(true);
  }

  void selectToppings(TagBean tagBean, bool isAdd) {
    model.value.selectTopping.removeWhere(
      (element) =>
          element.name == tagBean.name && element.value == tagBean.value,
    );
    if (isAdd) {
      model.value.selectTopping.add(tagBean);
    }
    calculateTotalPrice(true);
  }

  void clearCart() {
    _setQuantity(1);
    showAddToCart.value = true;
    TabBubbleTeaCtr.find.clearTea();
  }

  void _setQuantity(int value) {
    model.value.count = value;
    quantity.value = value;
  }

  @override
  void onClose() {
    _requestSerial++;
    super.onClose();
  }
}
