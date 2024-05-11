import 'package:badges/badges.dart' as badges;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../common/keep_alive_wrapper.dart';
import '../../../config/app_color.dart';
import '../../../controller/user_controller.dart';
import 'chat/conversation_list_page.dart';
import 'controller.dart';

class MessagesPage extends StatelessWidget {
  final controller = Get.put(MessagesPageController());
  RxInt _unreadGrouCount = RxInt(0); //统计群聊未读消息数目
  RxInt _unreadSingleCount = RxInt(0);

  int get unreadSingleCount => _unreadSingleCount.value;

  set unreadSingleCount(int value) {
    _unreadSingleCount.value = value;
  } //私聊未读数目

  int get unreadGrouCount => _unreadGrouCount.value;

  set unreadGrouCount(int value) {
    _unreadGrouCount.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConversationListPage(
        unreadCountChange: (int count) {
          Future.delayed(Duration(seconds: 1), () {
            unreadSingleCount = count;
            unreadGrouCount =
                UserController.find.unreadMsgCount.value - unreadSingleCount;
          });
        },
        type: type_single_chat,
      ),
    );
  }

  Widget tabItem(int index, String tab) {
    if (index == 0)
      return Obx(() {
        return unreadSingleCount <= 0
            ? Text(tab)
            : badges.Badge(
                showBadge: true,
                // showBadge: true,
                badgeContent: Container(
                  alignment: Alignment.center,
                  child: Obx(() => Text(
                        "$unreadSingleCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                      )),
                ),
                badgeColor: Color(0xffFF4848),
                position: badges.BadgePosition(end: -10, top: -6),
                alignment: Alignment.topRight,
                child: Text(tab),
              );
      });

    return Obx(() {
      return unreadGrouCount <= 0
          ? Text(tab)
          : badges.Badge(
              showBadge: true,
              // showBadge: true,
              badgeContent: Container(
                alignment: Alignment.center,
                child: Obx(() => Text(
                      "$unreadGrouCount",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                      maxLines: 1,
                    )),
              ),
              badgeColor: Color(0xffFF4848),
              position: badges.BadgePosition(end: -10, top: -6),
              alignment: Alignment.topRight,
              child: Text(tab),
            );
    });
  }
}
