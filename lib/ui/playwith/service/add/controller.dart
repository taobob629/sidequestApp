/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/service_info_model.dart';
import 'package:wy/utils/utils.dart';

import '../../../../config/app_pages.dart';

class AddGamePageController extends GetxController {
  RxList<PriceRangeModel> priceRanges = RxList([]);
  RxList<FieldsItem> fieldItems = RxList([]);
  RxList<PriceRangeModel> mPriceRanges = RxList([]); //我选择的技能列表
  RxList<ServiceInfoModel> services = RxList([]);
  Rxn<ServiceInfoModel?> _platform = Rxn();

  ServiceInfoModel? get platform => _platform.value;
  SkillItem? game;

  set platform(ServiceInfoModel? value) {
    _platform.value = value;
  }

  ///是否编辑
  bool isEdit = false;

  initData() async {
    var result = await GamesApi.getGameServicesInfo(isEdit);
    services.addAll(result);
  }

  getPriceRange(var gameId) async {
    var result = await GamesApi.getPriceRange(gameId);
    priceRanges.clear();
    mPriceRanges.clear();
    priceRanges.addAll(result?.priceRange ?? []);
    fieldItems.clear();
    fieldItems.addAll(result?.fields ?? []);
  }

  onPriceUnitChange(int index, PriceRangeModel model) {
    if (mPriceRanges[index] == model) return;
    if (mPriceRanges.contains(model)) {
      EasyLoading.showToast('已经存在改类型');
      return;
    }
    mPriceRanges[index] = model;
  }

  removePriceRange(int index) {
    mPriceRanges.removeAt(index);
  }

  toAddServiceTypePage() {
    Get.toNamed(AppPages.AddServiceType, arguments:game?.name);
  }

  addPriceRange() {
    if (priceRanges.isEmpty) {
      return;
    }
    if (mPriceRanges.isEmpty) {
      mPriceRanges.add(priceRanges.first);
      return;
    }
    if (mPriceRanges.length >= priceRanges.length) {
      EasyLoading.showToast('${'At most '.tr}${priceRanges.length}${' types can be added!'.tr} ');
      return;
    }

    //查看还有什么类型的没有被添加
    var item = priceRanges.firstWhereOrNull((element) => !mPriceRanges.contains(element));
    if (item != null) {
      mPriceRanges.add(item);
    }
  }
}
