/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/service_detail_model.dart';
import 'package:wy/model/service_info_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/my_profile/my_profile_page.dart';
import 'package:wy/ui/frame/profile/other_profile/record/controller.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/profile/voice_widget.dart';

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
  TextEditingController teServiceIntro = TextEditingController();
  RxString _background = RxString('');

  String get background => _background.value;

  set background(String value) {
    _background.value = value;
  }

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
    isShowVoice = showVoice();
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
    background=serviceModel?.backGround??'';
    teServiceIntro.text=serviceModel?.des??'';
    voiceUrl=serviceModel?.voice??'';
    platformIndex = services.indexWhere((w) => w.id == serviceModel?.platfromId);
    platform = services[platformIndex];
    gameIndex = platform?.skill?.indexWhere((item) => item.id == serviceModel?.gameId);
    game = platform?.skill[gameIndex];
    gameLvIndex = game?.level?.indexWhere((w) => w.id == serviceModel?.levelId);
    if (gameLvIndex != -1) gameLv = game?.level[gameLvIndex];
    await getPriceRange(gameId: serviceModel?.skillid);
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
    var desc=teServiceIntro.text;
    flog('priceRanges $mPriceRanges');
    if (!isEdit) {
      if (mPriceRanges.isEmpty) {
        EasyLoading.showToast('Please select service!'.tr);
        return;
      }
      var nameEmpty = mPriceRanges.firstWhereOrNull((element) {
        return element.name.isEmpty;
      });
      if (nameEmpty != null) {
        EasyLoading.showToast('Please input a name!'.tr);
        return;
      }
      if (desc.isEmpty) {
        EasyLoading.showToast('Please input a service intro!'.tr);
        return;
      }
      if(voiceUrl.isEmpty){
        EasyLoading.showToast('Please add a voice!'.tr);
        return;
      }
      if(background.isEmpty){
        EasyLoading.showToast('Please add a background!'.tr);
        return;
      }

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
      'fieldItems': buildFiledsParams(),
      'des':desc,
      'backGround':background,
      'voice':voiceUrl,
      // "des": beGoodAtCon.text,
    };
    http.post('/peiwan/app/service/addService', data: data).then((v) {
      EasyLoading.showToast('Submitted successfully'.tr);
      EasyLoading.dismiss();
      if (isEdit) {
        Get.back(result: true);
      } else {
        Get.back();
        Get.back();
        Get.back(result: true);
      }
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

  RxBool _isShowVoice = RxBool(false);

  bool get isShowVoice => _isShowVoice.value;

  set isShowVoice(bool value) {
    _isShowVoice.value = value;
  }

  RxString _voiceUrl = RxString('');

  String get voiceUrl => _voiceUrl.value;

  set voiceUrl(String value) {
    _voiceUrl.value = value;
  }

  bool showVoice() {
    //flog('UserController.find.userProfile.isAuth  ${UserController.find.userProfile.isAuth}');
    // flog('UserController.find.userProfile.voice.isEmpty  ${UserController.find.userProfile.voice}');
    return UserController.find.userProfile.isAuth == 0 &&
        UserController.find.userProfile.voice.isEmpty;
  }

  toRecordPage(BuildContext context,{int type=record_type_service}) {
    pickVoiceDialog(context, voiceUrl, (result) {
      flog('callback $result');
      if (result != null) voiceUrl = result;
      UserController.find.userProfile.voice = voiceUrl;
    },isServiceRecord: true,recordType: type);
    // Get.toNamed(AppPages.Record)?.then((value) {
    //   if (value != null){
    //     voiceUrl = value;
    //     UserController.find.userProfile.voice=voiceUrl;
    //   }
    // });
  }

  void deleteBackground() {
    background = '';
  }

  void selectBackground(BuildContext context) async {
    var status = await PermissionHelper.requestPhotosPermission(context);
    if (status == false) {
      return;
    }
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        EasyLoading.show();
        var url = await Common.uploadFile(value!, (p0, p1) => flog("$p0,$p1"));
        EasyLoading.dismiss();
        background = url;
      });
    } else {
      print('No image selected.');
    }
  }
  toBioPage(){
    Get.toNamed(AppPages.bio_page);
  }
}
