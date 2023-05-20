import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';



import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class GroupProfileType extends TIMUIKitStatelessWidget {
  GroupProfileType({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    String groupType;
    final model = Provider.of<TUIGroupProfileModel>(context);
    final type = model.groupInfo?.groupType;
    switch (type) {
      case GroupType.AVChatRoom:
        groupType = "聊天室".tr;
        break;
      case GroupType.Meeting:
        groupType = "会议群".tr;
        break;
      case GroupType.Public:
        groupType = "公开群".tr;
        break;
      case GroupType.Work:
        groupType = "工作群".tr;
        break;
      default:
        groupType = "未知群".tr;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color:
                      theme.weakDividerColor ?? CommonColor.weakDividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "群类型".tr,
            style: TextStyle(fontSize: 16, color: theme.darkTextColor),
          ),
          Text(
            groupType,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          )
        ],
      ),
    );
  }
}
