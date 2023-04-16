import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/messages/chat/custom_message_view.dart';
import 'package:wy/utils/index.dart';

import '../../../../model/play_order_detail_model.dart';
import '../../social/post/view/gift_animation.dart';
import '../../social/post/view/give_gifts_dialog.dart';

import 'package:get/get.dart';

class ChatController extends GetxController {}

class ChatPage extends StatelessWidget {
  final V2TimConversation selectedConversation;
  final String orderSn;

  ChatPage({Key? key, required this.selectedConversation, this.orderSn = ''}) : super(key: key);

  String? _getConvID() {
    return selectedConversation.type == 1 ? selectedConversation.userID : selectedConversation.groupID;
  }

  String pwId = "";

  getUserId() {
    ProfileApi.uk2id(selectedConversation.userID?.replaceAll("c2c_", "")).then((value) {
      pwId = value.toString();
    });
  }

  PlayOrderDetailModel? playOrderDetailModel;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatController>(tag: "ChatKey")) {
      Get.put(ChatController(), tag: "ChatKey");
    }
    getUserId();
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = width * 191 / 369;
    double iconHeight = height * 0.5;
    return TIMUIKitChat(
      appBarConfig: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      config: TIMUIKitChatConfig(
        isUseDefaultEmoji: true,
      ),
      morePanelConfig: MorePanelConfig(
        showFilePickAction: false,
        extraAction: [
          if (selectedConversation.type == 1)
            if (!(selectedConversation.userID ?? "").contains(UserController.find.userProfile.uk))
              MorePanelItem(
                  id: "customMessage",
                  title: "Gift",
                  onTap: (c) async {
                    var heartNum = await Get.bottomSheet(
                        GiveGiftsDialog(
                          receiverId: pwId,
                          postId: "",
                          avatar: selectedConversation.faceUrl ?? "",
                          source: 1,
                        ),
                        ignoreSafeArea: true);
                    if (heartNum != null) {
                      Future.delayed(Duration(milliseconds: 300)).then(
                        (v) {
                          showHearts(context, Offset(Get.width / 2, Get.height / 2), heartNum);
                        },
                      );
                    }
                  },
                  icon: Container(
                    height: 64,
                    width: 64,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Image.asset(
                      "assets/images/post/icon_gift.png",
                      height: 64,
                      width: 64,
                    ),
                  )),
        ],
        actionBuilder: (item) {
          return Container(
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColor.color2E3C, borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/im/icon_${item.title.toLowerCase()}.webp",
                    width: 23.w,
                    height: 23.h,
                  ),
                ),
                8.verticalSpace,
                Text(
                  item.title,
                  style: TextStyle(color: Color(0xFFB2B9C9), fontSize: 14.sp),
                )
              ],
            ),
          );
        },
      ),
      customStickerPanel: renderCustomStickerPanel,
      conversationID: _getConvID() ?? '',
      // groupID or UserID
      conversationType: selectedConversation.type == 1 ? ConvType.c2c : ConvType.group,
      // Conversation type
      conversationShowName: selectedConversation.showName ?? "",
      // Conversation display name
      onTapAvatar: (selectUk) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => UserProfile(userID: userID),
        //     ))
        if (selectUk != UserController.find.userProfile.uk.toString()) {
          if (pwId.isEmpty) {
            ProfileApi.uk2id(selectedConversation.userID?.replaceAll("c2c_", "")).then((value) {
              pwId = value.toString();
              NavigatorHelper.toOtherProfile(pwId);
            });
          } else {
            NavigatorHelper.toOtherProfile(pwId);
          }
        }
      },
      messageItemBuilder: MessageItemBuilder(customMessageItemBuilder: (message, isShowJump, clearJump) {
        var json = jsonDecode(message.customElem!.data!);
        var data = json;
        var type = data['type'];
        if (data["message"] != null) {
          data = data['message'];
        }
        print('data = $data');
        double? customHeight = height;
        switch (type) {
          case "TopUp_Credit":
            {
              customHeight = height + 90.h;
              break;
            }
          case "play_order":
            {
              customHeight = height;
              break;
            }
          default:
            {
              customHeight = null;
              break;
            }
        }

        return GestureDetector(
          onTap: () {
            if (type == "play_order") {
              Get.toNamed(AppPages.OrderDetail, arguments: Map()..['id'] = data['orderId'])?.whenComplete(() => _getPlayOrder());
            } else if (type == "TopUp_Credit") {
              int orderId = json['orderId'];
              Get.toNamed(AppPages.OrderDetail, arguments: Map()..['id'] = orderId)?.whenComplete(() => _getPlayOrder());
            }
          },
          child: Container(
              height: customHeight,
              width: width,
              padding: const EdgeInsets.all(0),
              child: CustomMessageView(
                type: type,
                data: data,
                iconHeight: iconHeight,
                width: width,
              )),
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
      backgroundColor: AppColor.itemBg,
      lightPrimaryColor: AppColor.itemBg,
      customStickerPackageList: [...defaultEmojiList],
    );
  }
}
