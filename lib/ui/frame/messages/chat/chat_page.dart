import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/messages/chat/custom_message_view.dart';
import 'package:wy/ui/frame/messages/group/group_profile.dart';
import 'package:wy/ui/im/im_util.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/toast_utils.dart';
import 'package:wy/widget/icon_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../model/play_order_detail_model.dart';
import '../../social/post/view/gift_animation.dart';
import '../../social/post/view/give_gifts_dialog.dart';

import 'package:get/get.dart';

class ChatController extends BasePageController {
  V2TimConversation selectedConversation;

  ChatController(this.selectedConversation);

  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
   if(selectedConversation.type == 1) return;
    getGroupInfo();
    checkGroup();
  }

  Rxn _memberInfo = Rxn<V2TimGroupInfo?>();

  V2TimGroupInfo get memberInfo => _memberInfo.value;

  set memberInfo(V2TimGroupInfo? value) {
    _memberInfo.value = value;
  }

  // ///未定义（没有获取该字段）
  // ///
  // static const int V2TIM_GROUP_MEMBER_UNDEFINED = 0;
  // ///群成员
  // ///
  // static const int V2TIM_GROUP_MEMBER_ROLE_MEMBER = 200;
  // ///群管理员
  // ///
  // static const int V2TIM_GROUP_MEMBER_ROLE_ADMIN = 300;
  // ///群主
  // ///
  // static const int V2TIM_GROUP_MEMBER_ROLE_OWNER = 400;
  List<String> menuAdmin = ['QR', 'Share to Posts', 'Group Info']; //管理员
  List<String> menuUser = ['QR', 'Group Info']; //普通用户
  RxList<String> popMenus = RxList([]);
  RxBool groupExists = false.obs;

  checkGroup() async {
    final res = await serviceLocator<GroupServices>().getGroupMemberList(
        groupID: selectedConversation.groupID!,
        filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
        count: 100,
        nextSeq: "0");
    if (res.code == 10010) {
      groupExists.value = false;
    } else {
      groupExists.value = true;
    }
  }

  Future<void> getGroupInfo() async {
    popMenus.clear();
    var res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupsInfo(groupIDList: [selectedConversation.groupID!]);
    flog('result ${res.code} ');
    if (res.code == 0) {
      var groupInfo = res.data?.first;
      memberInfo = groupInfo?.groupInfo;
      count.value = groupInfo?.groupInfo?.memberCount ?? 0;
      if (memberInfo.role ==
              GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER ||
          memberInfo.role ==
              GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN) {
        popMenus.addAll(menuAdmin);
      } else {
        popMenus.addAll(menuUser);
      }
    }
  }

  void share() {
    SmartDialog.show(
        builder: (builder) => Container(
            width: 200,
            height: 200,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            child: QrImage(
              // backgroundColor: Colors.white,
              foregroundColor: AppColor.itemBg,
              data: jsonEncode(Map()..['gid'] = selectedConversation.groupID),
              size: 100.0,
            )),
        animationTime: Duration.zero,
        clickMaskDismiss: true,
        onMask: () {});
  }
}

class ChatPage extends StatelessWidget {
  final V2TimConversation selectedConversation;
  final String orderSn;
  final V2TimMessage? initFindingMsg;

  ChatPage({
    Key? key,
    required this.selectedConversation,
    this.orderSn = '',
    this.initFindingMsg,
  }) : super(key: key);

  String? _getConvID() {
    return selectedConversation.type == 1
        ? selectedConversation.userID
        : selectedConversation.groupID;
  }

  String pwId = "";

  getUserId() {
    ProfileApi.uk2id(selectedConversation.userID?.replaceAll("c2c_", ""))
        .then((value) {
      pwId = value.toString();
    });
  }

  getGroupInfo() {}

  PlayOrderDetailModel? playOrderDetailModel;
  late ChatController controller;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatController>(tag: "ChatKey")) {
      controller = Get.put(ChatController(selectedConversation),
          tag: selectedConversation.conversationID);
    }
    getUserId();

    return TIMUIKitChat(
      appBarConfig: selectedConversation.type == 1
          ? AppBar(backgroundColor: Colors.transparent, elevation: 0)
          : AppBar(
              title: Obx(() => Text(
                  '${selectedConversation.showName} (${'${controller?.count.value}'})')),
              actions: actions(context),
            ),
      config: TIMUIKitChatConfig(
        isUseDefaultEmoji: true,
      ),
      initFindingMsg: initFindingMsg,
      morePanelConfig: MorePanelConfig(
        showFilePickAction: false,
        extraAction: [
          if (selectedConversation.type == 1)
            if (!(selectedConversation.userID ?? "")
                .contains(UserController.find.userProfile.uk))
              MorePanelItem(
                  id: "customMessage",
                  title: "Gift".tr,
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
                          showHearts(context,
                              Offset(Get.width / 2, Get.height / 2), heartNum);
                        },
                      );
                    }
                  },
                  icon: Container(
                    height: 64,
                    width: 64,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  decoration: BoxDecoration(
                      color: AppColor.color2E3C,
                      borderRadius: BorderRadius.circular(10)),
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
      conversationType:
          selectedConversation.type == 1 ? ConvType.c2c : ConvType.group,
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
            ProfileApi.uk2id(
                    selectedConversation.userID?.replaceAll("c2c_", ""))
                .then((value) {
              pwId = value.toString();
              NavigatorHelper.toOtherProfile(pwId);
            });
          } else {
            NavigatorHelper.toOtherProfile(pwId);
          }
        }
      },
      userAvatarBuilder: (context, message) {
        if (message.customElem?.data != null) {
          var json = jsonDecode(message.customElem!.data!);
          var data;

          if (json['type'] == "PostMessage") {
            if (json["message"] != null) {
              data = json['message'];
            }
            return ExtendedImage.network(
              data["avatar"] ?? "",
              width: 44.w,
              height: 44.w,
              shape: BoxShape.circle,
            );
          }
        }
        return ExtendedImage.network(
          message.faceUrl ?? "",
          width: 44.w,
          height: 44.w,
          shape: BoxShape.circle,
        );
      },
      messageItemBuilder: MessageItemBuilder(
          customMessageItemBuilder: (message, isShowJump, clearJump) {
        flog('isself ${message.isSelf}');
        var json = jsonDecode(message.customElem!.data!);
        var data = json;
        var type = data['type'];
        if (data["message"] != null) {
          data = data['message'];
        }
        data['isself'] = message.isSelf;
        flog('data = $data');
        return GestureDetector(
          onTap: () {
            switch (type) {
              case "play_order":
                Get.toNamed(AppPages.OrderDetail,
                        arguments: Map()..['id'] = data['orderId'])
                    ?.whenComplete(() => _getPlayOrder());
                break;
              case "TopUp_Credit":
                int orderId = json['orderId'];
                Get.toNamed(AppPages.OrderDetail,
                        arguments: Map()..['id'] = orderId)
                    ?.whenComplete(() => _getPlayOrder());
                break;
              case "PostMessage":
                NavigatorHelper.toPostDetail(data["postId"]);
                // Get.toNamed(AppPages.PostDetail, arguments: t.list[index])!.whenComplete(() => t.onRefresh());
                break;
              case MessageType.TYPE_INVITE:
                flog('$data');
                var gid = data['groupId'];
                if (gid == null) {
                  showToast('gid为空');
                  return;
                }
                ImUtils.joniGroup(context, data['groupId'],
                    isNeedReplace: true);
                break;
              default:
            }
          },
          child: CustomMessageView(
            type: type,
            data: data,
          ),
        );
      }),
      conversation:
          selectedConversation, // Callback for the clicking of the message sender profile photo. This callback can be used with `TIMUIKitProfile`.
    );
  }

  List<Widget> actions(BuildContext context) {
    return [
      Obx(() => Visibility(
          visible:
              controller.popMenus.isNotEmpty && controller.groupExists.value,
          child: PopupMenuButton(
              color: AppColor.itemBg,
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
              onSelected: (item) {
                if (item == 'QR'.tr) {
                  flog('share');
                  controller?.share();
                  return;
                }
                if (item == "Share to Posts".tr) {
                  toCreatePostPage(selectedConversation);
                  return;
                }
                if (item == "Group Info".tr) {
                  final conversationType = selectedConversation.type;

                  if (conversationType == 1) {
                    final userID = selectedConversation.userID;
                    // if had remark modified its will back new remark
                  } else {
                    final groupID = selectedConversation.groupID;
                    if (groupID != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupProfilePage(
                              groupID: groupID,
                            ),
                          ));
                    }
                  }
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                    ...controller.popMenus
                        .mapIndexed((index, e) => PopupMenuItem<String>(
                              value: e,
                              child: IconTextWidget(
                                icon: '',
                                iconWidget: Icon(
                                  menuIcon(index),
                                  size: 22,
                                  color: Colors.white,
                                ),
                                text: '$e'.tr,
                              ),
                            ))
                  ]))),
    ];
  }

  menuIcon(var index) {
    switch (index) {
      case 0:
        return Icons.qr_code;
      case 1:
        return Icons.share;
      case 2:
        return Icons.settings;
    }
  }

  _getPlayOrder() {
    ImApi.getCurrentPlayOrderDetail(selectedConversation.userID!, orderSn)
        .then((value) {
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
    final defaultEmojiList =
        defaultCustomEmojiStickerList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          isDefaultEmoji: true,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
                  CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList();

    return StickerPanel(
      sendTextMsg: sendTextMessage,
      sendFaceMsg: (index, data) =>
          sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
      deleteText: deleteText,
      addText: addText,
      addCustomEmojiText: addCustomEmojiText,
      backgroundColor: AppColor.itemBg,
      lightPrimaryColor: AppColor.itemBg,
      customStickerPackageList: [...defaultEmojiList],
    );
  }
}
