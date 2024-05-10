import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/hubs_api.dart';
import '../common/dialog_selector.dart';
import '../model/bubble_tea_store_model.dart';
import '../model/store_tea_model.dart';
import '../model/tea_category_model.dart';

class TabBubbleTeaCtr extends GetxController {
  static TabBubbleTeaCtr get find => Get.find();

  var teaList = <StoreTeaModel>[].obs;
  List<TeaCategoryModel> teaCategoryList = [];
  var categoryStr = "All Type".obs;
  var storesList = <BubbleTeaStoreModel>[].obs;

  var isShowDrinkNow = true.obs;
  var selectTeaList = <StoreTeaModel>[].obs;
  var totalPrice = "0".obs;
  var currentSelectStore = BubbleTeaStoreModel().obs;

  late BuildContext cartContext;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    storesList.value = await HubsApi.getStores();
    if (storesList.isNotEmpty) {
      currentSelectStore.value = storesList[0];
      requestStoreInDataByStoreId(storesList.first.id, false);
    }
  }

  void requestStoreInDataByStoreId(int? storeId, bool isShowLoading) async {
    if (isShowLoading) showLoading();
    final list = await Future.wait([
      HubsApi.getTeaBanners(storeId),
      HubsApi.getTeaList(storeId, 0),
      HubsApi.getTeaCategory(storeId),
    ]);
    if (isShowLoading) dismissLoading();
    if (list.length > 1) {
      teaList.assignAll(list[1]);
    }
    if (list.length > 2) {
      teaCategoryList.clear();
      teaCategoryList.add(TeaCategoryModel(id: 0, name: "All Type"));
      teaCategoryList.addAll(list[2]);
    }
  }

  void addTea(int i) {
    final result = selectTeaList
        .firstWhereOrNull((element) => element.id == teaList[i].id);
    if (result == null) {
      selectTeaList.add(teaList[i]);
      showSuccess("Successful.".tr);
    } else {
      showError("You've already added it.".tr);
    }

    totalPrice.value = selectTeaList.fold<String>(
        "0",
        (previousValue, element) =>
            previousValue.add(element.retailPrice ?? "0"));
  }

  void addMoney(int i) {
    selectTeaList[i].count.value += 1;
    calculateTotal();
  }

  void minusMoney(int i) {
    if (selectTeaList[i].count.value > 1) {
      selectTeaList[i].count.value -= 1;
      calculateTotal();
    }
  }

  void calculateTotal() {
    Decimal total = Decimal.parse("0");
    for (StoreTeaModel item in selectTeaList) {
      total += Decimal.parse(item.getTotalPrice());
    }
    totalPrice.value = total.toString();
  }

  void selectStore() async {
    final value = await Get.dialog(SelectorDialog(
      items: storesList,
      title: "Select Store".tr,
      showInfo: true,
    ));
    if (value != null) {
      currentSelectStore.value = value as BubbleTeaStoreModel;
      requestStoreInDataByStoreId(currentSelectStore.value.id, true);
    }
  }

  void clearTea() {
    selectTeaList.clear();
    dismissLoading();
  }

  void showCategoryDialog() async {
    final value = await Get.dialog(
      SelectorDialog(items: this.teaCategoryList, title: "Select Type".tr),
      barrierColor: Colors.black26,
    );
    if (value != null) {
      TeaCategoryModel model = value as TeaCategoryModel;
      categoryStr.value = model.name ?? '';
      showLoading();
      teaList.assignAll(
          await HubsApi.getTeaList(currentSelectStore.value.id, model.id));
      dismissLoading();
    }
  }
}
