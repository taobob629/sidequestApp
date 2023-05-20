import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class GroupProfileAddOpt extends TIMUIKitStatelessWidget {
  GroupProfileAddOpt({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final model = Provider.of<TUIGroupProfileModel>(context);

    String addOpt = "未知".tr;

    final groupAddOpt = model.groupInfo?.groupAddOpt;
    switch (groupAddOpt) {
      case GroupAddOptType.V2TIM_GROUP_ADD_ANY:
        addOpt = "自动审批".tr;
        break;
      case GroupAddOptType.V2TIM_GROUP_ADD_AUTH:
        addOpt = "管理员审批".tr;
        break;
      case GroupAddOptType.V2TIM_GROUP_ADD_FORBID:
        addOpt = "禁止加群".tr;
        break;
    }

    final actionList = [
      {"label": "禁止加群".tr, "id": GroupAddOptType.V2TIM_GROUP_ADD_FORBID},
      {"label": "自动审批".tr, "id": GroupAddOptType.V2TIM_GROUP_ADD_ANY},
      {"label": "管理员审批".tr, "id": GroupAddOptType.V2TIM_GROUP_ADD_AUTH}
    ];

    _handleActionTap(int addOpt) async {
      model.setGroupAddOpt(addOpt).then((res) {});
      Navigator.pop(
        context,
        "cancel",
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
      decoration: BoxDecoration(
          color: theme.weakBackgroundColor,
          border: Border(
              bottom: BorderSide(
                  color:
                      theme.weakDividerColor ?? CommonColor.weakDividerColor))),
      child: InkWell(
        onTap: () async {
          showCupertinoModalPopup<String>(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                title: Text("加群方式".tr),
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      "cancel",
                    );
                  },
                  child: Text('Cancel'.tr),
                  isDefaultAction: false,
                ),
                actions: actionList
                    .map((e) => CupertinoActionSheetAction(
                          onPressed: () {
                            _handleActionTap(e["id"] as int);
                          },
                          child: Text(
                            e["label"] as String,
                          ),
                          isDefaultAction: false,
                        ))
                    .toList(),
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "加群方式".tr,
              style: TextStyle(fontSize: 16, color: theme.darkTextColor),
            ),
            Row(
              children: [
                Text(
                  addOpt,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right, color: theme.weakTextColor)
              ],
            )
          ],
        ),
      ),
    );
  }
}
