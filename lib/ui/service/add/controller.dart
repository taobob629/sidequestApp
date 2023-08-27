/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/service_detail_model.dart';
import 'package:wy/model/service_info_model.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/game/game_home_page.dart';
import 'package:wy/ui/frame/profile/other_profile/record/controller.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/ui/service/add/pro/view.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/profile/voice_widget.dart';
import 'package:wy/widget/route.dart';

import '../../../../config/app_pages.dart';
import '../../../utils/time_utils.dart';
import '../../../utils/toast_utils.dart';
import '../../common/dialog_date_time_picker.dart';
import '../skill/list/controller.dart';

class AddGamePageController extends GetxController {
  BuildContext? myContext;

  RxList<PriceRangeModel> priceRanges = RxList([]);
  RxList<FieldsItem> fieldItems = RxList([]);
  RxList<PriceRangeModel> mPriceRanges = RxList([]); //我选择的技能列表
  List<PriceRangeModel> mPriceRangesRemark = [];
  RxList<ServiceInfoModel> services = RxList([]);
  Rxn<ServiceInfoModel?> _platform = Rxn();
  Rxn<ServiceDetailModel?> _serviceModel = Rxn();

  ServiceInfoModel? get platform => _platform.value;
  Rxn<SkillItem?> _game = Rxn();

  SkillItem? get game => _game.value;
  TextEditingController teServiceIntro = TextEditingController();
  TextEditingController discordIdCtr = TextEditingController();
  RxString _background = RxString('');

  GameConfig? gameConfig;

  String get background => _background.value;

  set background(String value) {
    _background.value = value;
  }

  set game(SkillItem? value) {
    _game.value = value;
  }

  var id;
  var ifSelectDuration = false.obs;
  var selectTime = DateTime.now().obs;

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
    teServiceIntro.dispose();
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
  var gameLv = LevelItem(levelid: -1).obs;
  var isWswitch = 0;
  RxList gamePhotos = RxList();

  // 0:entritainment 1:technology
  var isTech = 0.obs;
  var language = 0.obs;

  getSkillInfo() async {
    serviceModel = await GamesApi.getSkillDetail(id);
    flog('serviceModel $serviceModel');
    background = serviceModel?.backGround ?? '';
    teServiceIntro.text = serviceModel?.des ?? '';
    voiceUrl = serviceModel?.voice ?? '';
    platformIndex =
        services.indexWhere((w) => w.id == serviceModel?.platfromId);
    platform = services[platformIndex];
    gameIndex =
        platform?.skill?.indexWhere((item) => item.id == serviceModel?.gameId);
    game = platform?.skill[gameIndex];
    gameLvIndex = game?.level?.indexWhere((w) => w.id == serviceModel?.levelId);
    if (gameLvIndex != -1) {
      gameLv.value = game?.level[gameLvIndex] ?? LevelItem(levelid: -1);
    }
    await getPriceRange(gameId: serviceModel?.skillid);
    isWswitch = serviceModel?.pwSkillAuth?.wswitch ?? 0;

    // fieldItems.addAll(serviceModel?.fieldItems ?? []);
    serviceModel?.fieldItems?.forEach((field) {
      var item =
          fieldItems?.firstWhereOrNull((item) => item.name == field.name);
      if (item != null) {
        flog('value ${field.value}');
        item.mSelects.addAll(field.value);
      }
    });
//    mPriceRanges.addAll(serviceModel?.serviceTypes ?? []);
    flog(' serviceModel?.serviceTypes ${serviceModel?.serviceTypes}');
    serviceModel?.serviceTypes.forEach((e) {
      e.curPrice = e.price;
      e.initData();
      mPriceRanges.add(e);
    });
    if (serviceModel?.pwSkillAuth?.thumb != null) {
      var result = '${serviceModel?.pwSkillAuth?.thumb}'.split(',');
      gamePhotos.addAll(result);
    }
  }

  getPriceRange({var gameId}) async {
    gameConfig = await GamesApi.getPriceRange(gameId ?? game?.id,
        levelId: gameLv.value.levelid);
    priceRanges.clear();
    mPriceRanges.clear();
    mPriceRangesRemark.clear();
    priceRanges.addAll(gameConfig?.priceRange ?? []);
    fieldItems.clear();
    fieldItems.addAll(gameConfig?.fields ?? []);
  }

  onPriceUnitChange(int index, PriceRangeModel model) {
    if (mPriceRanges[index] == model) return;
    // if (mPriceRanges.contains(model)) {
    //   showToast('Service type already exist');
    //   return;
    // }
    mPriceRangesRemark = List.from(mPriceRanges);

    mPriceRanges[index] = model;
    mPriceRanges[index].initData();

    PriceRangeModel cacheModel = PriceRangeModel.fromJson(model.toJson());
    cacheModel.unit = model.unit;
    cacheModel.initData();
    mPriceRangesRemark[index] = cacheModel;
  }

  void showSelectTime() {
    Get.dialog<DateTime?>(
        DateTimePickerDialog(
          format: "dd-MMM-yyyy HH:mm",
          initDateTime: selectTime.value,
          minuteDivider: 30,
          ifSkip: true,
        ),
        barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        ifSelectDuration.value = true;
        this.selectTime.value = value;
      }
    });
  }

  removePriceRange(int index) {
    mPriceRanges.removeAt(index);
    mPriceRangesRemark.removeAt(index);
  }

  toAddServiceTypePage() {
    Get.toNamed(AppPages.AddServiceType, arguments: game?.name);
  }

  addPriceRange() {
    if (priceRanges.isEmpty) {
      return;
    }
    if (mPriceRanges.isEmpty) {
      priceRanges.first.initData();
      mPriceRanges.add(priceRanges.first);
      return;
    }
    if (((gameLv.value.levelid >= (gameConfig?.techLevel ?? 0)) &&
            (gameConfig?.techLevel ?? 0) > 0) &&
        isTech.value == 0 &&
        mPriceRanges.length == 1) {
      showToast('SideKicker can only add one service type'.tr);
      return;
    }

    if (mPriceRanges.length >= 5) {
      showToast('${'At most '.tr}${'5 types can be added!'.tr} ');
      return;
    }

    //查看还有什么类型的没有被添加
    var item = priceRanges.first;
    PriceRangeModel model = PriceRangeModel.fromJson(item.toJson());
    model.initData();
    mPriceRanges.add(model);
  }

  confirm() {
    Get.back();
    this.mPriceRanges.refresh();
  }

  bioUpdate() {
    if (voiceUrl.isEmpty) {
      showToast('Please add a voice!'.tr);
      return;
    }
    var desc = teServiceIntro.text;
    if (desc.isEmpty) {
      showToast('Please input a service intro!'.tr);
      return;
    }

    updateService(true);
  }

  updateService(bool flag) async {
    var desc = teServiceIntro.text;
    //flog('priceRanges $mPriceRanges');
    if (!isEdit) {
      if (mPriceRanges.isEmpty) {
        showToast('Please select service!'.tr);
        return;
      }
      var nameEmpty = mPriceRanges.firstWhereOrNull((element) {
        return element.name.isEmpty;
      });
      if (nameEmpty != null) {
        showToast('Please input a name!'.tr);
        return;
      }
      if (background.isEmpty) {
        showToast('Please upload a picture as the service cover image!'.tr);
        return;
      }
    }
    if (flag || isTech.value == 0) {
      jumpProOrSubmit(desc);
      return;
    }
    await Get.to(() => ProInterviewPage(false));
    jumpProOrSubmit(desc);
  }

  void jumpProOrSubmit(String desc) {
    showLoading();

    List<LocalPriceRangeBean> priceRangeList = [];
    LocalPriceRangeBean rangeModel;
    if (mPriceRangesRemark.isEmpty) {
      mPriceRangesRemark = List.from(mPriceRanges);
    }
    mPriceRangesRemark.forEach((element) {
      Map discount = {};
      if (element.currentPromotion.value.id == 0) {
        // Discount
        discount = {
          'type': 1,
          'discount':
          int.parse(element.currentDiscount.value.name.split('%')[0]),
          'enable': element.promotionSwitch.value ? 1 : 0,
        };
      } else if (element.currentPromotion.value.id == 1) {
        // 1st OrderFree
        discount = {
          'type': 3,
          'discount':
          int.parse(element.currentOrderFree.value.name.split('%')[0]),
          'enable': element.promotionSwitch.value ? 1 : 0,
        };
      } else if (element.currentPromotion.value.id == 2) {
        // Buy X Get Y
        discount = {
          'type': 2,
          'buy': element.currentBuyX.value.name,
          'get': element.currentGetY.value.name,
          'enable': element.promotionSwitch.value ? 1 : 0,
        };
      }

      rangeModel = LocalPriceRangeBean(
        unit: element.unit,
        price: element.curPrice == 0 ? element.gameCoinMin : element.curPrice,
        name: element.name,
        discount: jsonEncode(discount),
      );
      priceRangeList.add(rangeModel);
    });

    var data = {
      if (isEdit) "id": id,
      "skillid": game?.id,
      "thumb": gamePhotos.join(','),
      "levelid": gameLv.value.id,
      "wswitch": isWswitch,
      "coinid": 0,
      // "coin": priceRangeCon.text,
      'serviceTypes': priceRangeList,
      'fieldItems': buildFiledsParams(),
      'des': desc,
      'backGround': background,
      'voice': voiceUrl,
      'isTech': isTech.value,
      'language': language.value == 0 ? 'Chinese' : 'English',
      'discordId': discordIdCtr.text,
      'interviewDate': (selectTime.value.millisecondsSinceEpoch) ~/ 1000,
      // "des": beGoodAtCon.text,
    };
    http.post('/peiwan/app/service/addService', data: data).then((v) {
      dismissLoading();
      showToast('Submitted successfully'.tr);
      if (isEdit) {
        var route = Get.currentRoute;
        flog(
            'route $route  AppPages.bio_page ${AppPages.bio_page}  333 ${route == AppPages.bio_page}');
        Get.back(result: true);
        // if(route==AppPages.bio_page){
        //   Get.back();
        //   Get.back(result: true);
        // }else {
        //   Get.back(result: true);
        // }
      } else {
        Get.until((route) => Get.currentRoute.contains(AppPages.SkillList));
        SkillListPageController skillListPageController =
        Get.find<SkillListPageController>();
        skillListPageController.onRefresh();
        Get.to(
              () => GameHomePage(),
          arguments: {
            "liveid": v.data['liveid'],
            "skillId": v.data['skillId'],
            "gameId": v.data['gameId'],
            "avatar": v.data['avatar'],
            "nickName": v.data['nickName'],
            "sex": v.data['sex'],
            "age": v.data['age'],
            "uk": v.data['uk'],
            "price": v.data['price'],
            "unit": v.data['unit'],
          },
        );
      }
    }).catchError((e) {
      flog('e $e');
      showToast(e);
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
        UserController.find.userProfile.voice?.isEmpty == true;
  }

  toRecordPage(BuildContext context, {int type = record_type_service}) {
    pickVoiceDialog(context, voiceUrl, (result) {
      flog('callback $result');
      if (result != null) voiceUrl = result;
    }, isServiceRecord: true, recordType: type);
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(() => CropPage(
                image: _image,
                ifFixedSize: true,
              ))!
          .then((value) async {
        showLoading();
        var url = await Common.uploadFile(value!, (p0, p1) => flog("$p0,$p1"));
        dismissLoading();
        background = url;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<File> _resizeImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    final resizedImage = img.copyResize(image!, width: 672, height: 375);
    final resizedFile = await file.writeAsBytes(img.encodeJpg(resizedImage));
    return resizedFile;
  }

  toBioPage() {
    if (mPriceRanges.isEmpty) {
      showToast('Please select at least one Service Type.'.tr);
      return;
    }

    var nameEmpty = mPriceRanges.firstWhereOrNull((element) {
      return element.name.isEmpty;
    });
    if (nameEmpty != null) {
      showToast('Please input a name!'.tr);
      return;
    }

    Get.toNamed(AppPages.bio_page, preventDuplicates: false)?.then((refresh) {
      if (refresh) {
        if (isEdit) onRefresh();
      }
    }).catchError((e) {
      flog('catchError $e');
    });
  }

  onRefresh() {
    mPriceRanges.clear();
    mPriceRangesRemark.clear();
    gamePhotos.clear();
    getSkillInfo();
  }
}
