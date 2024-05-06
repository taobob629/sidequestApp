// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'text_input_bottom_sheet.dart';

class GroupProfileNameCard extends TIMUIKitStatelessWidget {
  GroupProfileNameCard({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    final model = Provider.of<TUIGroupProfileModel>(context);
    if (model == null) {
      return Container();
    }
    final nameCard = model.getSelfNameCard();

    controller.text = nameCard;
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
      decoration: BoxDecoration(
          color: theme.weakBackgroundColor,
          border: Border(
              bottom: BorderSide(color: theme.weakDividerColor ?? CommonColor.weakDividerColor))),
      child: InkWell(
        onTap: () async {
          TextInputBottomSheet.showTextInputBottomSheet(
              context, '修改我的群昵称'.tr, '仅限中文、字母、数字和下划线，2-20个字'.tr, (String nameCard) async {
            final text = nameCard.trim();
            model.setNameCard(text);
          }, theme);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '我的群昵称'.tr,
              style: TextStyle(fontSize: 16, color: theme.darkTextColor),
            ),
            Row(
              children: [
                Text(
                  nameCard,
                  style: const TextStyle(fontSize: 16),
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
