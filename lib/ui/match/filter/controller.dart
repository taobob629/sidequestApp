import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/match_api.dart';
import 'package:wy/config/app_pages.dart';

import '../../../image_utils.dart';
import '../../../model/login_model.dart';
import '../../../model/match_init_model.dart';
import '../../common/dialog_selector.dart';
import '../view/sphere_rotation.dart';

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
    _matchInitModel = await MatchApi.selfOrder();
    EasyLoading.dismiss();

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

  void selectSideKickTypes(tag) {
    if (!selectTags.contains(tag)) {
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
    // final result = await MatchApi.sendMatch(params);
    EasyLoading.dismiss();

    Get.toNamed(AppPages.side_kick_matching_page);
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
