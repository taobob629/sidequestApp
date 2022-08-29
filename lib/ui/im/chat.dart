// ignore_for_file: avoid_print, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tim_ui_kit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_view_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tim_ui_kit/ui/utils/permission.dart';
import 'package:tim_ui_kit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_call_invite_list.dart';


class Chat extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? initFindingMsg;

  const Chat(
      {Key? key, required this.selectedConversation, this.initFindingMsg})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TIMUIKitChatController _timuiKitChatController =
      TIMUIKitChatController();
  bool isDisscuss = false;
  bool isTopic = false;
  String? backRemark;
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  GlobalKey<dynamic> tuiChatField = GlobalKey();

  String _getTitle() {
    return backRemark ?? widget.selectedConversation.showName ?? "";
  }

  String? _getDraftText() {
    return widget.selectedConversation.draftText;
  }

  String? _getConvID() {
    return widget.selectedConversation.type == 1
        ? widget.selectedConversation.userID
        : widget.selectedConversation.groupID;
  }

  ConvType _getConvType() {
    return widget.selectedConversation.type == 1
        ? ConvType.c2c
        : ConvType.group;
  }

  _initListener() async {
    // 这个注册监听的逻辑，我们在TIMUIKitChat内已处理，您如果没有单独需要，可不手动注册
    // await _timuiKitChatController.removeMessageListener();
    // await _timuiKitChatController.setMessageListener();
  }

  _onTapAvatar(String userID) {
  }

  // _onTapLocation() {
  //   if (IMDemoConfig.baiduMapIOSAppKey.isNotEmpty) {
  //     tuiChatField.currentState.inputextField.currentState.hideAllPanel();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => LocationPicker(
  //             onChange: (LocationMessage location) async {
  //               final locationMessageInfo =
  //                   await sdkInstance.v2TIMMessageManager.createLocationMessage(
  //                       desc: location.desc,
  //                       longitude: location.longitude,
  //                       latitude: location.latitude);
  //               final messageInfo = locationMessageInfo.data!.messageInfo;
  //               _timuiKitChatController.sendMessage(
  //                   receiverID: _getConvID(),
  //                   groupID: _getConvID(),
  //                   convType: _getConvType(),
  //                   messageInfo: messageInfo);
  //             },
  //             mapBuilder: (onMapLoadDone, mapKey, onMapMoveEnd) => BaiduMap(
  //               onMapMoveEnd: onMapMoveEnd,
  //               onMapLoadDone: onMapLoadDone,
  //               key: mapKey,
  //             ),
  //             locationUtils: LocationUtils(BaiduMapService()),
  //           ),
  //         ));
  //   } else {
  //     Utils.toast("请根据Demo的README指引，配置百度AK，体验DEMO的位置消息能力");
  //     print("请根据本文档指引 https://docs.qq.com/doc/DSVliWE9acURta2dL ， 快速体验位置消息能力");
  //   }
  // }

  _goToVideoUI() async {
    final hasCameraPermission =
        await Permissions.checkPermission(context, Permission.camera.value);
    final hasMicphonePermission =
        await Permissions.checkPermission(context, Permission.microphone.value);
    if (!hasCameraPermission || !hasMicphonePermission) {
      return;
    }
    final isGroup = widget.selectedConversation.type == 2;
    tuiChatField.currentState.textFieldController.hideAllPanel();
    if (isGroup) {
      List<V2TimGroupMemberFullInfo>? selectedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCallInviter(
            groupID: widget.selectedConversation.groupID,
          ),
        ),
      );
      if (selectedMember != null) {
        final inviteMember = selectedMember.map((e) => e.userID).toList();
      }
    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: "邀请你视频通话",
        ext: "{\"conversationID\": \"c2c_$myId\"}",
        disablePush: false,
        androidOPPOChannelID: "",//PushConfig.OPPOChannelID,
        ignoreIOSBadge: false,
      );
    }
  }

  _goToVoiceUI() async {
    final hasMicphonePermission =
        await Permissions.checkPermission(context, Permission.microphone.value);
    if (!hasMicphonePermission) {
      return;
    }
    final isGroup = widget.selectedConversation.type == 2;
    tuiChatField.currentState.textFieldController.hideAllPanel();
    if (isGroup) {
      List<V2TimGroupMemberFullInfo>? selectedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCallInviter(
            groupID: widget.selectedConversation.groupID,
          ),
        ),
      );
      if (selectedMember != null) {

      }
    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
    }
  }

  @override
  void initState() {
    super.initState();
    _initListener();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TIMUIKitChat(
          lifeCycle: ChatLifeCycle(
              newMessageWillMount: (V2TimMessage message) async {
                // This configuration is unnecessary and only for demonstration purpose.
                // It shows if you tend to avoid a message from rending, you can `return null` here.
                return message;
              }
          ),
          onDealWithGroupApplication: (String groupId) {
          },
          groupAtInfoList: widget.selectedConversation.groupAtInfoList,
          key: tuiChatField,
          config: const TIMUIKitChatConfig(
            // For demonstration only, not all configuration items.
            // In practical use, only parameters that are different from the default items need be provided.
            isAllowClickAvatar: true,
            isAllowLongPressMessage: true,
            isShowReadingStatus: true,
            isShowGroupReadingStatus: false,
            notificationTitle: "",
            notificationOPPOChannelID: "",//PushConfig.OPPOChannelID,
              groupReadReceiptPermisionList: [
                // The group receipt function only works with `Ultimate Edition`

                // GroupReceptAllowType.work,
                // GroupReceptAllowType.meeting,
                // GroupReceptAllowType.public
              ]
          ),
          conversationID: _getConvID() ?? '',
          conversationType: widget.selectedConversation.type ?? ConversationType.V2TIM_C2C,
          onTapAvatar: _onTapAvatar,
          conversationShowName: _getTitle(),
          initFindingMsg: widget.initFindingMsg,
          draftText: _getDraftText(),
          messageItemBuilder: MessageItemBuilder(

          ),
          morePanelConfig: MorePanelConfig(
            showFilePickAction: false,
            extraAction: [
              MorePanelItem(
                  id: "order",
                  title: "Order",
                  onTap: (c) {

                  },
                  icon: Container(
                    height: 64,
                    width: 64,
                    child: Image.asset("assets/images/ui_order.png",fit: BoxFit.contain,),
                  )),
            ],
          ),
          appBarConfig: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  onPressed: () async {
                    final conversationType = widget.selectedConversation.type;
                    if (conversationType == 1) {
                      final userID = widget.selectedConversation.userID;
                      // if had remark modifed its will back new remark

                    } else {
                      final groupID = widget.selectedConversation.groupID;
                      if (groupID != null) {

                      }
                    }
                  },
                  icon: Image.asset(
                    'images/more.png',
                    package: 'tim_ui_kit',
                    height: 34,
                    width: 34,
                  ))
            ],
          )),
    );
  }
}
