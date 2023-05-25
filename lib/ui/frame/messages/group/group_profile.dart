import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/group_profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/messages/chat/chat_page.dart';
import 'package:wy/widget/im/search.dart';
import 'package:wy/widget/im/tencent_page.dart';

import 'group_profile_widget.dart';
import 'tim_group_profile.dart';
import 'widgets/index.dart';

class GroupProfilePage extends StatelessWidget {
  final String groupID;
  final sdkInstance = TIMUIKitCore.getSDKInstance();
  final coreInstance = TIMUIKitCore.getInstance();

  GroupProfilePage({Key? key, required this.groupID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TUISelfInfoViewModel _selfInfoViewModel =
        serviceLocator<TUISelfInfoViewModel>();
    return TencentPage(
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                  'Group Chat'.tr,
                ),
              ),
            body: SafeArea(
              child: GroupProfile(
                lifeCycle: GroupProfileLifeCycle(didLeaveGroup: () async {
                  // Shows navigating back to the home page.
                  // You can customize the reaction here.
                  if (PlatformUtils().isWeb) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(AppPages.Main));
                    serviceLocator<TUIConversationViewModel>().refresh();
                  }
                }),
                groupID: groupID,
                onClickUser: (String userID) {
                  if (userID != _selfInfoViewModel.loginInfo?.userID) {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => UserProfile(userID: userID),
                    //     ));
                  }
                },
                profileWidgetBuilder:
                    MyGroupProfileWidgetBuilder(searchMessage: () {
                  return SizedBox(
                    height: 1,
                  );
                  return TIMUIKitGroupProfileWidget.searchMessage(
                      (V2TimConversation? conversation) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Search(
                                  onTapConversation:
                                      (V2TimConversation conversation,
                                          V2TimMessage? targetMsg) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            selectedConversation: conversation,
                                            initFindingMsg: targetMsg,
                                          ),
                                        ));
                                  },
                                  conversation: conversation,
                                )));
                  });
                }),
              ),
            )),
        name: 'groupProfile'.tr);
  }
}
