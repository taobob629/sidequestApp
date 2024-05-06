import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/colorful_button.dart';
import '../../../../../common/dialog_selector.dart';
import '../../../../../common/paixs_fun.dart';
import '../../../../../config/app_color.dart';
import '../../../../../model/beans/game_role_bean.dart';
import '../../../../../model/selector_item.dart';
import '../../../../../res/dimens.dart';
import '../../../../../utils/toast_utils.dart';
import '../../../../../widget/paixs_widget.dart';
import '../../../../../widget/scaffold_widget.dart';
import '../../../../../widget/views.dart';
import '../../../login/auth_input_view.dart';
import '../controller.dart';

class ProInterviewPage extends GetView<AddGamePageController> {

  final bool flag;

  ProInterviewPage(this.flag);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Interview'.tr),
      ),
      body: contentPadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthInputView(
                tips: "Discord ID".tr,
                editingController: controller.discordIdCtr,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,
              itemBg(
                PWidget.row([
                  PWidget.text(
                    'What Time'.tr,
                    [AppColor.whiteGray],
                  ),
                  Obx(() => PWidget.text(
                        controller.ifSelectDuration.value
                            ? formatDate(controller.selectTime.value,
                                [dd, '/', M, '/', yyyy, ' ', HH, ':', nn])
                            : '',
                        [Color(0xFFB2B9C9), 12.sp],
                        {'ali': 1, 'exp': true},
                      )),
                  rightJtView(16, AppColor.whiteGray),
                ]),
                fun: controller.showSelectTime,
              ),
              20.verticalSpace,
              itemBg(
                PWidget.row([
                  PWidget.text(
                    'Language'.tr,
                    [AppColor.whiteGray],
                  ),
                  Obx(() => PWidget.text(
                        controller.language.value == 0
                            ? 'Chinese'.tr
                            : 'English'.tr,
                        [Color(0xFFB2B9C9), 12.sp],
                        {'ali': 1, 'exp': true},
                      )),
                  rightJtView(16, AppColor.whiteGray),
                ]),
                fun: () async {
                  List<SelectorItem> items = [];
                  GameRoleBean bean = GameRoleBean();
                  bean.id = 0;
                  bean.name = 'Chinese'.tr;
                  items.add(bean);

                  bean = GameRoleBean();
                  bean.id = 1;
                  bean.name = 'English'.tr;
                  items.add(bean);

                  var res = await Get.dialog(
                    SelectorDialog(
                      items: items,
                      title: "Select Language".tr,
                      showInfo: true,
                    ),
                    barrierColor: Colors.black26,
                  );
                  if (res != null) {
                    controller.language.value = res.id;
                  }
                },
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.horizontalSpace,
                  Text(
                    'Info：'.tr,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'After applying for an appointment, please go to the SideKick homepage to enter the SideKick Official DC. Wait in the assessment channel 5minutes before the assessment time, if you are not in the DC at the stipulated time, the appointment will be canceled automatically.'.tr,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              40.verticalSpace,
              ColorfulButton(
                child: Text(
                  flag ? "Next".tr : "Confirm".tr,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "DIN", fontSize: 18),
                ),
                height: 48,
                borderRadius: 40.r,
                onTap: () {
                  if (!controller.ifSelectDuration.value) {
                    showToast('Please select what time.');
                    return;
                  }
                  if (flag) {
                    controller.toAddServiceTypePage();
                  } else {
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 48, Colors.white10],
        {'br': 16.r, 'pd': PFun.lg(0, 0, 16, 14), 'fun': fun});
  }
}
