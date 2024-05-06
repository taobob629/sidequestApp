import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';

import 'tim_uikit_operation_item.dart';

class GroupMessageDisturb extends TIMUIKitStatelessWidget {
  GroupMessageDisturb({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final model = Provider.of<TUIGroupProfileModel>(context);
    final isDisturb = model.conversation?.recvOpt != 0;
    return TIMUIKitOperationItem(
      operationName: '消息免打扰'.tr,
      type: "switch",
      operationValue: isDisturb,
      onSwitchChange: (value) {
        model.setMessageDisturb(value);
      },
    );
  }
}
