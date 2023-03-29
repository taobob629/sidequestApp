import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/match_api.dart';
import 'package:wy/config/app_pages.dart';

import '../../../image_utils.dart';
import '../../../model/beans/JumpMatchSucBean.dart';
import '../../../model/login_model.dart';
import '../../../model/match/matching_model.dart';
import '../../../model/match_init_model.dart';
import '../../../model/send_match_model.dart';
import '../../common/dialog_selector.dart';

class SideKickMatchController extends GetxController {
  late MatchInitModel _matchInitModel;

  var category = ''.obs;
  var unit = ''.obs;
  var language = <String>[].obs;
  var others = <Language>[].obs;
  var game = ''.obs;
  List<Game> games = [];
  List<Language> selectTags = [];
  String? gid;

  TextEditingController minPriceCtr = TextEditingController(text: '2');
  TextEditingController maxPriceCtr = TextEditingController(text: '20');
  TextEditingController requestsPriceCtr = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    EasyLoading.show();
    requestData();
  }

  void requestData() async {
    final result = await MatchApi.selfOrder();
    EasyLoading.dismiss();

    if (result['orderId'] > 0) {
      // 已经有订单了，只是匹配中的时候出去了，再次回来
      MatchingModel matchingModel = MatchingModel.fromJson(result);
      if (matchingModel.players.isNotEmpty) {
        // 已经有匹配好的接单人了
        List<JumpMatchSucBean> beans = [];
        matchingModel.players.forEach((element) {
          JumpMatchSucBean bean = JumpMatchSucBean(
            memberCode: element.memberCode,
            orderId: matchingModel.orderId.toString(),
            avatar: element.avatar,
            nickname: element.nickname,
            sex: element.sex,
            age: element.age,
            stars: element.stars,
            levelNameEn: element.levelNameEn,
            tags: matchingModel.types,
            category: matchingModel.category,
            game: matchingModel.game,
            priceRange: '${matchingModel.minPrice}~${matchingModel.maxPrice}',
            unit: matchingModel.unit,
            launguage: matchingModel.language,

            skillAuthId: element.skillAuthId,
            liveuid: element.liveuid,
            serviceItemId: element.serviceItemId,
          );
          beans.add(bean);
        });
        Get.offAndToNamed(
          AppPages.side_kick_match_suc_page,
          arguments: beans,
        );
      } else {
        // 继续在倒计时界面
        _jumpMatchingPage(
          language: matchingModel.language,
          orderId: matchingModel.orderId,
          tags: matchingModel.types,
          category: matchingModel.category,
          unit: matchingModel.unit,
          game: matchingModel.game,
          minPrice: matchingModel.minPrice.toString(),
          maxPrice: matchingModel.maxPrice.toString(),
          optional: '',
        );
      }
    } else {
      _matchInitModel = MatchInitModel.fromJson(result);

      others.value = _matchInitModel.others;
      if (others.isNotEmpty) {
        selectTags.add(others[0]);
      }
      if (_matchInitModel.services.isNotEmpty == true) {
        category.value = _matchInitModel.services[0].category;
        games = _matchInitModel.services[0].games;
        game.value = games[0].name;
        gid = games[0].id;
      }
      if (_matchInitModel.unit.isNotEmpty == true) {
        unit.value = _matchInitModel.unit[0].value;
      }
      if (_matchInitModel.language.isNotEmpty == true) {
        language.assign(_matchInitModel.language[0].value);
      }
    }
  }

  void selectSideKickTypes(tag) {
    if (selectTags.contains(tag)) {
      selectTags.remove(tag);
    } else {
      selectTags.add(tag);
    }
  }

  void matching() async {
    if (minPriceCtr.text.isEmpty) {
      EasyLoading.showToast('Please enter the min price');
      return;
    }
    if (maxPriceCtr.text.isEmpty) {
      EasyLoading.showToast('Please enter the max price');
      return;
    }
    if (double.parse(maxPriceCtr.text) < double.parse(minPriceCtr.text)) {
      EasyLoading.showToast('The max price cannot be lower than the min price');
      return;
    }

    EasyLoading.show();
    StringBuffer languageStr = StringBuffer();
    for (int i = 0; i < language.length; i++) {
      if (i == language.length - 1) {
        languageStr.write('${language[i]}');
      } else {
        languageStr.write('${language[i]},');
      }
    }

    Map tagsMap = {};
    selectTags.forEach((element) {
      tagsMap[element.name] = element.value;
    });

    Map params = {
      "gid": gid,
      "minPrice": minPriceCtr.text,
      "maxPrice": maxPriceCtr.text,
      "unit": unit.value,
      "language": languageStr.toString(),
      "types": json.encode(tagsMap),
      "requests": requestsPriceCtr.text,
    };
    final result = await MatchApi.sendMatch(params);
    EasyLoading.dismiss();

    _jumpMatchingPage(
      language: languageStr.toString(),
      orderId: result,
      tags: selectTags,
      category: category.value,
      unit: unit.value,
      game: game.value,
      minPrice: minPriceCtr.text,
      maxPrice: maxPriceCtr.text,
      optional: requestsPriceCtr.text,
    );
  }

  void _jumpMatchSucPage(String language, int orderId) {
    // JumpMatchSucBean bean = JumpMatchSucBean(
    //   memberCode: matchOperationModel.memberCode,
    //   orderId: orderId.toString(),
    //   avatar: matchOperationModel.avatar,
    //   nickname: matchOperationModel.nickname,
    //   sex: matchOperationModel.sex,
    //   age: matchOperationModel.age,
    //   stars: matchOperationModel.stars,
    //   levelNameEn: matchOperationModel.levelNameEn,
    //   tags: matchOperationModel.orderInfo.types,
    //   skillAuthId: matchOperationModel.skillAuthId,
    //   liveuid: matchOperationModel.liveuid,
    //   serviceItemId: matchOperationModel.serviceItemId,
    //   category: model.category,
    //   game: model.game,
    //   priceRange: '${model.minPrice}~${model.maxPrice}',
    //   unit: model.unit,
    //   launguage: model.language,
    // );
    // bean.ifPlayer = false;
    // Get.offAndToNamed(
    //   AppPages.side_kick_match_suc_page,
    //   arguments: bean,
    // );
  }

  void _jumpMatchingPage({
    required String language,
    required int orderId,
    required List<Language> tags,
    required String category,
    required String unit,
    required String game,
    required String minPrice,
    required String maxPrice,
    required String optional,
  }) {
    SendMatchModel model = SendMatchModel(
      gid: gid == null ? 0 : int.parse(gid!),
      category: category,
      language: language,
      unit: unit,
      game: game,
      minPrice: minPrice,
      maxPrice: maxPrice,
      optional: optional,
      orderId: orderId,
      tags: tags,
    );
    Get.offAndToNamed(AppPages.side_kick_matching_page, arguments: model);
  }

  Widget selectLanguage() {
    return Obx(
      () => ListView.separated(
        itemCount: language.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) => Container(
          decoration: BoxDecoration(
            color: Color(0x1affffff),
            borderRadius: BorderRadius.circular(15.r),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          child: Row(
            children: [
              Text(
                language[i],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              4.horizontalSpace,
              GestureDetector(
                onTap: () {
                  if (language.contains(language[i])) {
                    language.remove(language[i]);
                  }
                },
                child: Image.asset(
                  ImageUtils.iconShanchu,
                  width: 14.w,
                  height: 14.w,
                ),
              ),
            ],
          ),
        ),
        separatorBuilder: (c, i) => 10.horizontalSpace,
      ),
    );
  }

  void selectItem(String flag) async {
    var items;
    switch (flag) {
      case 'Category':
        items = List.generate(_matchInitModel.services.length, (i) {
          return VerifyField.fromJson({
            'name': '${_matchInitModel.services[i].id}',
            'label': '${_matchInitModel.services[i].category}',
          });
        });
        break;
      case 'Game':
        items = List.generate(games.length, (i) {
          return VerifyField.fromJson({
            'name': '${games[i].id}',
            'label': '${games[i].name}',
          });
        });
        break;
      case 'Unit':
        items = List.generate(_matchInitModel.unit.length, (i) {
          return VerifyField.fromJson({
            'name': '${_matchInitModel.unit[i].name}',
            'label': '${_matchInitModel.unit[i].value}',
          });
        });
        break;
      case 'Language':
        items = List.generate(_matchInitModel.language.length, (i) {
          return VerifyField.fromJson({
            'name': '${_matchInitModel.language[i].name}',
            'label': '${_matchInitModel.language[i].value}',
          });
        });
        break;
    }

    final result = await Get.dialog(
      SelectorDialog(
        items: items,
        title: "Select $flag".tr,
        showInfo: true,
      ),
      barrierColor: Colors.black26,
    );
    if (result != null) {
      VerifyField verifyField = result as VerifyField;
      switch (flag) {
        case 'Category':
          category.value = verifyField.label;
          _matchInitModel.services.forEach((element) {
            if (verifyField.label == element.category) {
              games = element.games;
              game.value = games[0].name;
              gid = games[0].id;
            }
          });
          break;
        case 'Game':
          game.value = verifyField.label;
          gid = verifyField.name;
          break;
        case 'Unit':
          unit.value = verifyField.label;
          break;
        case 'Language':
          if (!language.contains(verifyField.label)) {
            language.add(verifyField.label);
          }
          break;
      }
    }
  }
}
