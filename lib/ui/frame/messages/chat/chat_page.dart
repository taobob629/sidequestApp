import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/ui/im/order_detail.dart';

import '../../../../model/play_order_detail_model.dart';

class ChatPage extends StatelessWidget {
  final V2TimConversation selectedConversation;
  final String orderSn;

  ChatPage({Key? key, required this.selectedConversation, this.orderSn = ''}) : super(key: key);
  String? _getConvID() {
    return selectedConversation.type == 1 ? selectedConversation.userID : selectedConversation.groupID;
  }

  PlayOrderDetailModel? playOrderDetailModel;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = width * 191 / 369;
    double iconHeight = height * 0.5;
    return TIMUIKitChat(
      appBarConfig: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      config: TIMUIKitChatConfig(
        isUseDefaultEmoji: true,
      ),
      morePanelConfig: MorePanelConfig(showFilePickAction: false),
      customStickerPanel: renderCustomStickerPanel,
      conversationID: _getConvID() ?? '', // groupID or UserID
      conversationType: selectedConversation.type == 1 ? ConvType.c2c : ConvType.group, // Conversation type
      conversationShowName: selectedConversation.showName ?? "", // Conversation display name
      onTapAvatar: (_) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => UserProfile(userID: userID),
        //     ));
      },
      messageItemBuilder: MessageItemBuilder(customMessageItemBuilder: (message, isShowJump, clearJump) {
        var data = jsonDecode(message.customElem!.data!);
        var type = data['type'];
        if (type != "play_order") {
          return Text(
            "Unsupported message type, please update your app!",
            style: TextStyle(fontSize: 12, color: Colors.white24),
          );
        }
        if (data["message"] != null) {
          data = data['message'];
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
      conversation: selectedConversation, // Callback for the clicking of the message sender profile photo. This callback can be used with `TIMUIKitProfile`.
    );
  }

  _getPlayOrder() {
    ImApi.getCurrentPlayOrderDetail(selectedConversation.userID!, orderSn).then((value) {
      playOrderDetailModel = value;
    });
  }

  Widget renderCustomStickerPanel({
    sendTextMessage,
    sendFaceMessage,
    deleteText,
    addCustomEmojiText,
    addText,
    List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
  }) {
    final defaultEmojiList = defaultCustomEmojiStickerList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          isDefaultEmoji: true,
          stickerList: customEmojiPackage.list.asMap().keys.map((idx) => CustomSticker(index: idx, name: customEmojiPackage.list[idx])).toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList();

    return StickerPanel(
      sendTextMsg: sendTextMessage,
      sendFaceMsg: (index, data) => sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
      deleteText: deleteText,
      addText: addText,
      addCustomEmojiText: addCustomEmojiText,
      customStickerPackageList: [...defaultEmojiList],
    );
  }
}
