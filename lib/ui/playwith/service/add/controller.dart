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
import 'package:wy/utils/utils.dart';

class AddGamePageController extends GetxController {
  RxList<PriceRangeModel> priceRanges = RxList([]);
  RxList<PriceRangeModel> mPriceRanges = RxList([]); //我选择的技能列表
  getPriceRange(var gameId) async {
    var result = await GamesApi.getPriceRange(7);
    flog('priceResult $result');
    priceRanges.clear();
    mPriceRanges.clear();
    priceRanges.addAll(result);
  }

  onPriceUnitChange(int index, PriceRangeModel model) {
    if (mPriceRanges.contains(model)) {
      EasyLoading.showToast('已经存在改类型');
      return;
    }
    mPriceRanges[index - 1] = model;
  }

  addPriceRange() {
    if (mPriceRanges.isEmpty || mPriceRanges.length >= priceRanges.length) {
      mPriceRanges.add(priceRanges.first);
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
