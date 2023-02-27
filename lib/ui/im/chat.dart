// ignore_for_file: avoid_print, unused_field, unused_element

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_call_invite_list.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/ui/im/order_detail.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:intl/intl.dart';
import 'package:wy/widget/tim_ui/my_constant.dart';

import '../../model/play_order_detail_model.dart';
import '../../widget/tim_ui/my_tim_uikit_chat.dart' as my;
import '../../widget/tim_ui/my_tim_uikit_more_panel.dart' as my_tim_uikit_more_panel;
import 'package:date_format/date_format.dart';

class Chat extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? initFindingMsg;
  final String orderSn;

  const Chat({Key? key, required this.selectedConversation, this.initFindingMsg, this.orderSn = ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TIMUIKitChatController _timuiKitChatController = TIMUIKitChatController();
  bool isDisscuss = false;
  bool isTopic = false;
  String? backRemark;
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  GlobalKey<dynamic> tuiChatField = GlobalKey();

  PlayOrderDetailModel? playOrderDetailModel;

  _getPlayOrder() {
    ImApi.getCurrentPlayOrderDetail(widget.selectedConversation.userID!, widget.orderSn).then((value) {
      setState(() {
        playOrderDetailModel = value;
      });
    });
  }

  String _getTitle() {
    log(widget.selectedConversation.showName.toString(), name: 'widget.selectedConversation.showName');
    return backRemark ?? widget.selectedConversation.showName ?? "";
  }

  String? _getDraftText() {
    return widget.selectedConversation.draftText;
  }

  String? _getConvID() {
    return widget.selectedConversation.type == 1 ? widget.selectedConversation.userID : widget.selectedConversation.groupID;
  }

  ConvType _getConvType() {
    return widget.selectedConversation.type == 1 ? ConvType.c2c : ConvType.group;
  }

  _initListener() async {
    // 这个注册监听的逻辑，我们在TIMUIKitChat内已处理，您如果没有单独需要，可不手动注册
    // await _timuiKitChatController.removeMessageListener();
    // await _timuiKitChatController.setMessageListener();
  }

  _onTapAvatar(String userID) {
    if (widget.selectedConversation.userID == 'system') return;
    Get.to(() => PlayDetail(
              userId: userID,
              fromChat: true,
              isMemberCode: true,
            ))!
        .whenComplete(() => _getPlayOrder());
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
    final hasCameraPermission = await Permissions.checkPermission(context, Permission.camera.value);
    final hasMicphonePermission = await Permissions.checkPermission(context, Permission.microphone.value);
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
        androidOPPOChannelID: "", //PushConfig.OPPOChannelID,
        ignoreIOSBadge: false,
      );
    }
  }

  _goToVoiceUI() async {
    final hasMicphonePermission = await Permissions.checkPermission(context, Permission.microphone.value);
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
      if (selectedMember != null) {}
    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
    }
  }

  _toOrderPage() {
    if (widget.selectedConversation.userID == 'system') return;
    Get.to(() => PlayDetail(
              userId: widget.selectedConversation.userID!,
              fromChat: true,
              isMemberCode: true,
            ))!
        .whenComplete(() => _getPlayOrder());
  }

  @override
  void initState() {
    super.initState();
    _initListener();
    _getPlayOrder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = width * 191 / 369;
    double iconHeight = height * 0.5;
    return Scaffold(
      body: my.TIMUIKitChat(
          // customEmojiStickerList: Const.emojiList.where((element) => element.isEmoji == true).toList(),
          conversation: widget.selectedConversation,
          topFixWidget: _buildOrderState(),
          lifeCycle: ChatLifeCycle(newMessageWillMount: (V2TimMessage message) async {
            // This configuration is unnecessary and only for demonstration purpose.
            // It shows if you tend to avoid a message from rending, you can `return null` here.
            return message;
          }),
          onDealWithGroupApplication: (String groupId) {},
          groupAtInfoList: widget.selectedConversation.groupAtInfoList,
          key: tuiChatField,
          config: const TIMUIKitChatConfig(
              // For demonstration only, not all configuration items.
              // In practical use, only parameters that are different from the default items need be provided.
              isAllowClickAvatar: true,
              isAllowLongPressMessage: true,
              isUseDefaultEmoji: true,
              isShowReadingStatus: true,
              isAllowEmojiPanel: false,
              isShowGroupReadingStatus: false,
              notificationTitle: "",
              notificationOPPOChannelID: "", //PushConfig.OPPOChannelID,
              groupReadReceiptPermisionList: [
                // The group receipt function only works with `Ultimate Edition`
                // GroupReceptAllowType.work,
                // GroupReceptAllowType.meeting,
                // GroupReceptAllowType.public
              ]),
          conversationID: _getConvID() ?? '',
          conversationType: ConvType.values[widget.selectedConversation.type ?? ConversationType.V2TIM_C2C],
          onTapAvatar: _onTapAvatar,
          conversationShowName: _getTitle(),
          initFindingMsg: widget.initFindingMsg,
          draftText: _getDraftText(),
          messageItemBuilder: MessageItemBuilder(customMessageItemBuilder: (message, isShowJump, clearJump) {
            var data = jsonDecode(message.customElem!.data!);
            var type = data['type'];
            if (type != "play_order") {
              return Text(
                "Unsupported message type, please update your app!",
                style: TextStyle(fontSize: 12, color: Colors.white24),
              );
            }
            print(data);
            return GestureDetector(
              onTap: () {
                Get.to(() => OrderDetail(orderId: data['orderId']))!.whenComplete(() => _getPlayOrder());
              },
              child: Container(
                height: height,
                width: width,
                padding: const EdgeInsets.all(0),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), image: DecorationImage(image: AssetImage("assets/images/msg_bg.png"), fit: BoxFit.cover)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            data['icon'] == null
                                ? Container(
                                    width: iconHeight,
                                    height: iconHeight,
                                  )
                                : Image.network(
                                    data['icon'],
                                    width: iconHeight,
                                    height: iconHeight,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: iconHeight,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width - iconHeight - 25,
                                    child: Text(
                                      "${data['game']}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/ic_balance_money.webp",
                                        width: 15,
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "${data['price']}",
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("for ${data['num']} ${data['num'] > 1 ? 'Hours' : 'Hour'}",
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // Text("${DateFormat('dd/MM/y HH:mm:ss', 'en_GB').format(DateTime.fromMillisecondsSinceEpoch(data['createTime']*1000))}",
                        Text(
                            "${formatDate(DateTime.fromMillisecondsSinceEpoch(data['createTime'] * 1000), [
                                  d,
                                  '/',
                                  M,
                                  '/',
                                  yyyy,
                                  ' ',
                                  HH,
                                  ':',
                                  nn,
                                ])}",

                            // Text("${data['addTime']}",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            )),
                      ],
                    )),
              ),
            );
          }),
          morePanelConfig: my_tim_uikit_more_panel.MorePanelConfig(
            showFilePickAction: false,
            showCameraAction: false,
            extraAction: [
              my_tim_uikit_more_panel.MorePanelItem(
                  id: "order",
                  title: "Order".tr,
                  onTap: (c) {
                    _toOrderPage();
                  },
                  icon: Container(
                    height: 64,
                    width: 64,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Image.asset(
                      "assets/images/ui_order.png",
                      fit: BoxFit.contain,
                    ),
                  )),
            ],
          ),
          appBarConfig: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(),
            actions: [
              IconButton(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  onPressed: () async {
                    _toOrderPage();
                  },
                  icon: Image.asset(
                    'images/more.png',
                    package: 'tencent_cloud_chat_uikit',
                    height: 34,
                    width: 34,
                  ))
            ],
          )),
    );
  }

  Widget _buildOrderState() {
    if (playOrderDetailModel == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () => Get.to(() => OrderDetail(orderId: playOrderDetailModel!.orderId))!.whenComplete(() => _getPlayOrder()),
      child: Container(
        height: 80,
        color: Colors.white12,
        child: Stack(
          children: [
            Positioned(
                left: 10,
                right: 10,
                top: 10,
                child: Row(
                  children: [
                    Text(
                      "${playOrderDetailModel!.gameName}",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Image.asset(
                      "assets/images/ic_balance_money.webp",
                      width: 12,
                      height: 12,
                    ),
                    Text(
                      "${playOrderDetailModel!.total} for ${playOrderDetailModel!.nums} ${playOrderDetailModel!.nums > 1 ? 'Hours' : 'Hour'}",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                )),
            Positioned(
                left: 0,
                right: 0,
                top: 45,
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  color: Colors.white24,
                )),
            Positioned(
                left: 0,
                right: 0,
                top: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 6,
                          ),
                          Text(
                            "Paid".tr,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: playOrderDetailModel!.status == 2 ? Colors.green : Colors.blue,
                            radius: 6,
                          ),
                          Text(
                            "${playOrderDetailModel!.status == 2 ? 'Serving'.tr : 'Waiting'.tr}",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 6,
                          ),
                          Text(
                            "Comment".tr,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
