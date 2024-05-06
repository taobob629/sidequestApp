import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/hubs_api.dart';
import '../common/dialog_selector.dart';
import '../model/bubble_tea_store_model.dart';
import '../model/store_tea_model.dart';

class TabBubbleTeaCtr extends GetxController {
  static TabBubbleTeaCtr get find => Get.find();

  var teaList = <StoreTeaModel>[].obs;
  var storesList = <BubbleTeaStoreModel>[].obs;

  var selectTeaList = <StoreTeaModel>[].obs;
  var totalPrice = "0".obs;
  var currentSelectStore = BubbleTeaStoreModel().obs;

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
      HubsApi.getTeaList(storeId, "0"),
    ]);
    if (isShowLoading) dismissLoading();
    if (list.length > 1) {
      teaList.assignAll(list[1]);
    }
  }

  void addTea(int i) {
    final result = selectTeaList
        .firstWhereOrNull((element) => element.id == teaList[i].id);
    if (result == null) {
      selectTeaList.add(teaList[i]);
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
}
