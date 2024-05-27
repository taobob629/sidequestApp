import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/api/coupon_api.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/hubs_api.dart';
import '../common/dialog_selector.dart';
import '../model/bubble_tea_store_model.dart';
import '../model/coupon_model.dart';
import '../model/goods_detail_model.dart';
import '../model/store_tea_model.dart';
import '../model/tea_category_model.dart';
import '../service/location_service.dart';
import '../utils/geolocator_utils.dart';
import '../widget/tag/tag_bean.dart';
import 'bubble_tea_detail_ctr.dart';

class TabBubbleTeaCtr extends GetxController {
  static TabBubbleTeaCtr get find => Get.find();

  var teaList = <StoreTeaModel>[].obs;
  List<TeaCategoryModel> teaCategoryList = [];
  var categoryStr = "All/Select Type".obs;
  var storesList = <BubbleTeaStoreModel>[].obs;

  // 购物车dialog是否在显示, true显示，反之
  bool isShowCartDialog = false;
  var isShowDrinkNow = true.obs;
  var selectTeaList = <GoodsDetailModel>[].obs;
  var totalCount = 0.obs;
  var totalPrice = "0".obs;
  // 优惠券前的总价
  String yhTotalPrice = "0";
  var currentSelectStore = BubbleTeaStoreModel().obs;
  var distances = 0.0.obs;
  var showAddToCart = true.obs;
  var discount = "0.0".obs;
  CouponsListModel? selectCouponModel;

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
      if (currentSelectStore.value.map != null) {
        List<String> latLog = currentSelectStore.value.map!.split(", ");

        // (51.5074, 0.1278)是伦敦的经纬度
        distances.value = GeolocatorUtils.calculateDistance(
          LocationService().position?.latitude ?? 51.5074,
          LocationService().position?.longitude ?? 0.1278,
          double.parse(latLog[0]),
          double.parse(latLog[1]),
        );
      }

      requestStoreInDataByStoreId(storesList.first.id, false);
    }
  }

  String getPrice(GoodsDetailModel model) {
    String paramsPrice = (model.selectSize?.value ?? "0")
        .add(model.selectIce?.value ?? "0")
        .add(model.selectSugar?.value ?? "0");
    if (model.selectTopping.length == 1) {
      paramsPrice = paramsPrice.add(model.selectTopping[0].value);
    } else if (model.selectTopping.length == 2) {
      paramsPrice = paramsPrice
          .add(model.selectTopping[0].value)
          .add(model.selectTopping[1].value);
    }
    return (model.price ?? "0").add(paramsPrice);
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

  void addMoney(int i) {
    selectTeaList[i].count += 1;
    calculateTotal();
  }

  void minusMoney(int i) {
    if (selectTeaList[i].count > 1) {
      selectTeaList[i].count -= 1;
    } else {
      GoodsDetailModel? foundGoods = selectTeaList.firstWhereOrNull(
          (goods) => goods.equalsIgnoringCount(selectTeaList[i]));
      if (foundGoods != null) {
        selectTeaList.remove(foundGoods);
      }
      if (selectTeaList.isEmpty) {
        selectCouponModel = null;
        discount.value = "0.0";
        if (Get.isRegistered<BubbleTeaDetailCtr>()) {
          BubbleTeaDetailCtr.find.showAddToCart.value = true;
        }
        dismissLoading();
      }
    }
    calculateTotal();
  }

  void calculateTotal() {
    selectTeaList.refresh();
    totalCount.value = 0;
    Decimal total = Decimal.parse("0");
    for (GoodsDetailModel item in selectTeaList) {
      totalCount += item.count;

      String paramsPrice = (item.selectSize?.value ?? "0")
          .add(item.selectIce?.value ?? "0")
          .add(item.selectSugar?.value ?? "0");
      if (item.selectTopping.length == 1) {
        paramsPrice = paramsPrice.add(item.selectTopping[0].value);
      } else if (item.selectTopping.length > 1) {
        paramsPrice = paramsPrice
            .add(item.selectTopping[0].value)
            .add(item.selectTopping[1].value);
      }

      total += Decimal.parse(
          (item.price ?? "0").add(paramsPrice).mul(item.count.toString()));
    }
    if (selectTeaList.isEmpty) {
      discount.value = "0.0";
    }
    totalPrice.value = total.toString().minus(discount.value);
    yhTotalPrice = totalPrice.value;
    // 查询优惠券
    // HubsApi.getVouchers(currentSelectStore.value.id);
  }

  void selectStore() async {
    final value = await Get.dialog(SelectorDialog(
      items: storesList,
      title: "Select Store".tr,
      showInfo: true,
    ));
    if (value != null) {
      currentSelectStore.value = value as BubbleTeaStoreModel;
      if (currentSelectStore.value.map != null) {
        List<String> latLog = currentSelectStore.value.map!.split(",");

        // (51.5074, 0.1278)是伦敦的经纬度
        distances.value = GeolocatorUtils.calculateDistance(
          LocationService().position?.latitude ?? 51.5074,
          LocationService().position?.longitude ?? 0.1278,
          double.parse(latLog[0]),
          double.parse(latLog[1]),
        );
      }

      requestStoreInDataByStoreId(currentSelectStore.value.id, true);
    }
  }

  void clearTea() {
    if (Get.isRegistered<BubbleTeaDetailCtr>()) {
      BubbleTeaDetailCtr.find.showAddToCart.value = true;
    }

    selectCouponModel = null;
    discount.value = "0.0";
    selectTeaList.clear();
    calculateTotal();
    dismissLoading();
  }

  void showCategoryDialog() async {
    final value = await Get.dialog(
      SelectorDialog(items: this.teaCategoryList, title: "Select Category".tr),
      barrierColor: Colors.black26,
    );
    if (value != null) {
      TeaCategoryModel model = value as TeaCategoryModel;
      if (model.name?.contains("All Type") == true) {
        categoryStr.value = 'All/Select Type';
      } else {
        categoryStr.value = model.name ?? '';
      }
      showLoading();

      teaList.assignAll(
          await HubsApi.getTeaList(currentSelectStore.value.id, model.id));
      dismissLoading();
    }
  }

  List<Map<String, dynamic>> getGoodsListMap() {
    List<Map<String, dynamic>> goodsList = [];
    selectTeaList.forEach((element) {
      List<String> toppingList = [];
      if (element.selectTopping.length == 1) {
        toppingList.add(element.selectTopping[0].name);
      } else if (element.selectTopping.length == 2) {
        toppingList.add(element.selectTopping[0].name);
        toppingList.add(element.selectTopping[1].name);
      }

      Map<String, dynamic> map = {
        "id": element.id,
        "num": element.count,
        "commodityId": element.commodityId,
        "specifications": jsonEncode({
          "CupSize": element.selectSize?.name,
          "Ice": element.selectIce?.name,
          "Sugar": element.selectSugar?.name,
          "DrinkExtra": toppingList,
          "FoodExtra": []
        }),
      };
      goodsList.add(map);
    });
    return goodsList;
  }

  void selectCoupon(CouponsListModel couponModel) async {
    selectCouponModel = couponModel;
    showLoading();
    final result = await CouponApi.calculateOrder(
      storeId: currentSelectStore.value.id ?? 0,
      goodsList: getGoodsListMap(),
      couponId: TabBubbleTeaCtr.find.selectCouponModel?.id,
    );
    dismissLoading();

    if(result != null) {
      discount.value = result;
      totalPrice.value = yhTotalPrice.minus(result);
    }
  }
}
