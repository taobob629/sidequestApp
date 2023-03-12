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

class AddGamePageController extends GetxController {
  RxList<PriceRangeModel> priceRanges = RxList([]);
  RxList<PriceRangeModel> mPriceRanges = RxList([]); //我选择的技能列表
  RxList<ServiceInfoModel> services = RxList([]);
  ///是否编辑
  bool isEdit = false;

  initData() async {
   var result=await GamesApi.getGameServicesInfo(isEdit);
   services.addAll(result);

  }
  getPriceRange(var gameId) async {
    var result = await GamesApi.getPriceRange(7);
    flog('priceResult $result');
    priceRanges.clear();
    mPriceRanges.clear();
    priceRanges.addAll(result);
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

  addPriceRange() {
    if(priceRanges.isEmpty){
      return;
    }
    if (mPriceRanges.isEmpty) {
      mPriceRanges.add(priceRanges.first);
      EasyLoading.showToast('${'At most '.tr}${priceRanges.length}${' types can be added!'.tr} ');
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
