import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/widget/gradient_button.dart';

class GroupProfileDetailCard extends TIMUIKitStatelessWidget {
  final V2TimGroupInfo groupInfo;
  final void Function(String groupName)? updateGroupName;
  final TextEditingController controller = TextEditingController();

  GroupProfileDetailCard(
      {Key? key, required this.groupInfo, this.updateGroupName})
      : super(key: key);
  var textColor;

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    textColor = theme.textColor;
    final model = Provider.of<TUIGroupProfileModel>(context);
    final faceUrl = groupInfo.faceUrl ?? "";
    final groupID = groupInfo.groupID;
    final showName = groupInfo.groupName ?? groupID;
    return InkWell(
      onTap: (() {
        showCupertinoModalPopup<String>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoTheme( data: CupertinoThemeData(
              barBackgroundColor: theme.weakBackgroundColor, // Add your desired color
            ), child: CupertinoActionSheet(
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Text('Cancel'.tr),
                  isDefaultAction: false,
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      controller.text = groupInfo.groupName ?? "";
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              decoration:  BoxDecoration(
                                  color: theme.weakBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      '修改群名称'.tr,
                                    ),
                                  ),
                                  Divider(
                                      height: 2, color: theme.weakDividerColor),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor:
                                              theme.inputFillColor,
                                              filled: true,
                                              isDense: true,
                                              hintText: ''),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '修改群名称'.tr,
                                          style: TextStyle(
                                            color: theme.weakTextColor,
                                            fontSize: 13,),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                            width: double.infinity,
                                            child: GradientButton(
                                              height: Dimens.btnHeightSmall,
                                              tapCallback: () {
                                                final text =
                                                controller.text.trim();
                                                if (updateGroupName != null) {
                                                  updateGroupName!(text);
                                                } else {
                                                  model.setGroupName(text);
                                                }
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Confirm'.tr),
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Text(
                      "修改群名称".tr,
                    ),
                    isDefaultAction: false,
                  )
                ]));
          },
        );
      }),
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: Avatar(
                faceUrl: faceUrl,
                showName: showName,
                type: 2,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                         ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("ID: $groupID",
                        style:
                            TextStyle(fontSize: 13, color: theme.weakTextColor))
                  ],
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: theme.weakTextColor,
            )
          ],
        ),
      ),
    );
  }
}
