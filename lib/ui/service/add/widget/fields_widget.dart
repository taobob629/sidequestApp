/**
    author:mac
    创建日期:2023/3/13
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/dialog_selector_multiple.dart';
import 'package:wy/utils/index.dart';

import '../add_game_page.dart';
import '../controller.dart';

class FieldsWidget extends GetView<AddGamePageController> {
  @override
  Widget build(BuildContext context) {
    var fields = controller.fieldItems;
    return Container(
      child: Obx(() => MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return fieldsItem(fields[index]);
            },
            itemCount: fields.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.transparent,
              height: 16.h,
            ),
          ))),
    );
  }

  var textColor = Color(0xFFB2B9C9);

  fieldsItem(FieldsItem field) {
    return Container(
      constraints: BoxConstraints(minHeight: 45.h),
      padding: itemPadding(),
      decoration: innerDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${field.name}'.tr,
            style: text_style(),
          ),
          8.horizontalSpace,
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Obx(() => Text(
                        '${field.displaySelect()}',
                        textAlign: TextAlign.right,
                        style: text_style(),
                      ))),
              InkWell(
                onTap: () {
                  choseDialog(field);
                },
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textColor,
                  size: 16,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  choseDialog(FieldsItem field) async {
    var result;
    var dialog;
    dialog = SelectorMutipleDialog(
      mode: field.type,
      initSelects:List.generate(field.mSelects.length, (i) {
        return VerifyField.fromJson({'name': '$i', 'label': field.value[i]});
      }),
      items: List.generate(field.value.length, (i) {
        return VerifyField.fromJson({'name': '$i', 'label': field.value[i]});
      }),
      title: "Select ${field.name}".tr,
      showInfo: true,
      showActions: true,
    );

    result = await Get.dialog(
      dialog,
      barrierColor: Colors.black26,
    );
    if (result != null) {
      field.mSelects.clear();
      field.mSelects.addAll(result);
    }
    flog('result $result');
  }

  TextStyle text_style() => TextStyle(
      color: textColor, fontSize: 12.sp, fontFamily: FONT_LIGHT, overflow: TextOverflow.ellipsis);
}
