/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/service_detail_model.dart';
import 'package:wy/model/service_info_model.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/utils/utils.dart';

import '../../../../config/app_pages.dart';

class AddGamePageController extends GetxController {
  RxList<PriceRangeModel> priceRanges = RxList([]);
  RxList<FieldsItem> fieldItems = RxList([]);
  RxList<PriceRangeModel> mPriceRanges = RxList([]); //我选择的技能列表
  RxList<ServiceInfoModel> services = RxList([]);
  Rxn<ServiceInfoModel?> _platform = Rxn();
  Rxn<ServiceDetailModel?> _serviceModel = Rxn();

  ServiceInfoModel? get platform => _platform.value;
  Rxn<SkillItem?> _game = Rxn();

  SkillItem? get game => _game.value;

  set game(SkillItem? value) {
    _game.value = value;
  }

  var id;

  ServiceDetailModel? get serviceModel => _serviceModel.value;
 late PrivacyCheckController privacyCheckController;

  set serviceModel(ServiceDetailModel? value) {
    _serviceModel.value = value;
  }

  set platform(ServiceInfoModel? value) {
    _platform.value = value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    privacyCheckController.dispose();
    flog('onClose ---${privacyCheckController.check()}');
  }

  ///是否编辑
  RxBool _isEdit = RxBool(false);

  bool get isEdit => _isEdit.value;

  set isEdit(bool value) {
    _isEdit.value = value;
    _isEdit.refresh();
  }

  var platformIndex;

  initData() async {
    var result = await GamesApi.getGameServicesInfo(isEdit);
    services.addAll(result);
    if (isEdit) getSkillInfo();
  }

  var gameIndex;
  var gameLvIndex;
  LevelItem? gameLv;
  var isWswitch = 0;
  RxList gamePhotos = RxList();

  getSkillInfo() async {
    serviceModel = await GamesApi.getSkillDetail(id);
    flog('serviceModel $serviceModel');
    platformIndex = services.indexWhere((w) => w.id == serviceModel?.platfromId);
    platform = services[platformIndex];
    gameIndex = platform?.skill?.indexWhere((item) => item.id == serviceModel?.gameId);
    game = platform?.skill[gameIndex];
    gameLvIndex = game?.level?.indexWhere((w) => w.id == serviceModel?.levelId);
    if (gameLvIndex != -1) gameLv = game?.level[gameLvIndex];
    await getPriceRange(gameId: serviceModel?.gameId);
    isWswitch = serviceModel?.pwSkillAuth?.wswitch ?? 0;

    // fieldItems.addAll(serviceModel?.fieldItems ?? []);
    serviceModel?.fieldItems?.forEach((field) {
      var item = fieldItems?.firstWhereOrNull((item) => item.type == field.type);
      if (item != null) {
        flog('value ${field.value}');
        item.mSelects.addAll(field.value);
      }
    });
//    mPriceRanges.addAll(serviceModel?.serviceTypes ?? []);
    flog(' serviceModel?.serviceTypes ${serviceModel?.serviceTypes}');
    serviceModel?.serviceTypes?.forEach((e) {
      e.curPrice = e.price;
      mPriceRanges?.add(e);
    });
    if (serviceModel?.pwSkillAuth?.thumb != null) {
      var result = '${serviceModel?.pwSkillAuth?.thumb}'.split(',');
      gamePhotos.addAll(result);
    }
  }

  getPriceRange({var gameId}) async {
    var result = await GamesApi.getPriceRange(gameId ?? game?.id, levelId: gameLv?.levelid);
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
    Get.toNamed(AppPages.AddServiceType, arguments: game?.name);
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

  confirm() {
    Get.back();
    this.mPriceRanges.refresh();
  }

  updateService() async {
    flog('priceRanges $mPriceRanges');
    if (mPriceRanges.isEmpty) {
      EasyLoading.showToast('Please select service!');
      return;
    }
    EasyLoading.show();
    var data = {
      if (isEdit) "id": id,
      "skillid": game?.id,
      "thumb": gamePhotos.join(','),
      "levelid": gameLv == null ? '' : gameLv?.id,
      "wswitch": isWswitch,
      "coinid": 0,
      // "coin": priceRangeCon.text,
      'serviceTypes': mPriceRanges,
      'fieldItems': buildFiledsParams()
      // "des": beGoodAtCon.text,
    };
    http.post('/peiwan/app/service/addService', data: data).then((v) {
      EasyLoading.showToast('Submitted successfully'.tr);
      EasyLoading.dismiss();
      Get.back(result: true);
     // Get.until((route) => route.settings.name == AppPages.ServiceAndOrders,);
    }).catchError((e) {
      flog('e $e');
      EasyLoading.showToast(e);
    }).whenComplete(() {});
  }

  List? buildFiledsParams() {
    if (fieldItems.isEmpty) return [];
    var list = [];
    fieldItems.forEach((item) {
      if (item.mSelects.isNotEmpty) {
        var itemCopy = FieldsItem.fromJson(item.toJson2());
        list.add(itemCopy);
      }
    });
    flog(' fielditems ${list}');
    return list;
  }
}
