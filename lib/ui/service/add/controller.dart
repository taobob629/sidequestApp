/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
import 'package:wy/ui/frame/game/game_home_page.dart';
import 'package:wy/ui/frame/profile/my_profile/my_profile_page.dart';
import 'package:wy/ui/frame/profile/other_profile/record/controller.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/profile/voice_widget.dart';
import 'package:image/image.dart' as img;

import '../../../../config/app_pages.dart';
import '../../../model/booking_model.dart';
import '../../../utils/toast_utils.dart';
import '../skill/list/controller.dart';

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

  var promotionSwitch = true.obs;

  List<BookingSelectModel> promotionList = [];
  var currentPromotion = BookingSelectModel().obs;

  List<BookingSelectModel> discountList = [];
  var currentDiscount = BookingSelectModel().obs;

  List<BookingSelectModel> orderFreeList = [];
  var currentOrderFree = BookingSelectModel().obs;

  List<BookingSelectModel> xAndYList = [];
  var currentBuyX = BookingSelectModel().obs;
  var currentGetY = BookingSelectModel().obs;

  @override
  void onInit() {
    super.onInit();
    isShowVoice = showVoice();

    BookingSelectModel model = BookingSelectModel();
    model.id = 0;
    model.name = "Discount";
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "1st Order Free";
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "Buy X Get Y Free";
    promotionList.add(model);
    currentPromotion.value = promotionList[0];

    model = BookingSelectModel();
    model.id = 0;
    model.name = "5% Off";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "10% Off";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "15% Off";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 3;
    model.name = "20% Off";
    discountList.add(model);
    currentDiscount.value = discountList[0];

    model = BookingSelectModel();
    model.id = 0;
    model.name = "30% Off";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "50% Off";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "80% Off";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 3;
    model.name = "100% Off";
    orderFreeList.add(model);
    currentOrderFree.value = orderFreeList[0];

    for (int i = 1; i <= 10; i++) {
      model = BookingSelectModel();
      model.id = i;
      model.name = "$i";
      xAndYList.add(model);
    }

    currentBuyX.value = currentGetY.value = xAndYList[0];
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
  LevelItem? gameLv;
  var isWswitch = 0;
  RxList gamePhotos = RxList();

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
    if (gameLvIndex != -1) gameLv = game?.level[gameLvIndex];
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
    var result = await GamesApi.getPriceRange(gameId ?? game?.id,
        levelId: gameLv?.levelid);
    priceRanges.clear();
    mPriceRanges.clear();
    priceRanges.addAll(result?.priceRange ?? []);
    fieldItems.clear();
    fieldItems.addAll(result?.fields ?? []);
  }

  onPriceUnitChange(int index, PriceRangeModel model) {
    if (mPriceRanges[index] == model) return;
    if (mPriceRanges.contains(model)) {
      showToast('Service type already exist');
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
      showToast(
          '${'At most '.tr}${priceRanges.length}${' types can be added!'.tr} ');
      return;
    }

    //查看还有什么类型的没有被添加
    var item = priceRanges
        .firstWhereOrNull((element) => !mPriceRanges.contains(element));
    if (item != null) {
      mPriceRanges.add(item);
    }
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
    
    updateService();
  }

  updateService() async {
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
        showToast(
            'Please upload a picture as the service cover image!'.tr);
        return;
      }
    }
    showLoading();
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
      'des': desc,
      'backGround': background,
      'voice': voiceUrl,
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
        Get.until(
            (route) => Get.currentRoute.contains(AppPages.ServiceAndOrders));
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
        UserController.find.userProfile.voice?.isEmpty==true;
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
    mPriceRanges?.clear();
    gamePhotos?.clear();
    getSkillInfo();
  }
}
