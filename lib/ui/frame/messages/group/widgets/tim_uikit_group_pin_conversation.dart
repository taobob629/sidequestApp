import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';

import 'tim_uikit_operation_item.dart';

class GroupPinConversation extends TIMUIKitStatelessWidget {
  GroupPinConversation({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final model = Provider.of<TUIGroupProfileModel>(context);
    final isPined = model.conversation?.isPinned ?? false;
    return TIMUIKitOperationItem(
      operationName: "置顶聊天".tr,
      type: "switch",
      operationValue: isPined,
      onSwitchChange: (value) {
        model.pinedConversation(value);
      },
    );
  }
}
