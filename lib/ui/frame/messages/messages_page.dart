import 'package:badges/badges.dart' as badges;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/index.dart';

import '../../../common/keep_alive_wrapper.dart';
import 'chat/conversation_list_page.dart';
import 'controller.dart';

class MessagesPage extends StatelessWidget {
  final controller = Get.put(MessagesPageController());
  RxInt _unreadGrouCount = RxInt(0);//统计群聊未读消息数目
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
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 750.0 / 365,
          child: Image.asset(
            "assets/images/message/msg_head_bg.webp",
            fit: BoxFit.fitWidth,
            width: Get.width,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Colors.transparent,
            actions: [
              Obx(() => Visibility(
                  visible: controller.showMenu.value,
                  child: PopupMenuButton(
                      color: AppColor.itemBg,
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Colors.white,
                      ),
                      onSelected: (item) {
                        if (item == 'Create Room'.tr) {
                          controller.toCreatGoupPage();
                        }
                        if (item == "Scan".tr) {
                          controller.toScan(context);
                        }
                      },
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                            ...controller.popMenus
                                .map((e) => PopupMenuItem<String>(
                                      value: e['title'],
                                      child: Row(
                                        children: [
                                          ImageUtil.assetImage(e['img']!,
                                              width: 20.w),
                                          10.horizontalSpace,
                                          Text(
                                            '${e['title']}',
                                            style: TextStyle(),
                                          )
                                        ],
                                      ),
                                    ))
                          ])))
            ],
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicator: BoxDecoration(),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  // indicatorPadding: const EdgeInsets.only(bottom: 0),
                  labelPadding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  labelStyle:
                      TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
                  tabs: controller.tabs
                      .mapIndexed((index, e) => tabItem(index, e))
                      .toList(),
                ).paddingOnly(left: 15),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: TabBarView(controller: controller.tabController, children: [
            KeepAliveWrapper(
                child: ConversationListPage(
                  unreadCountChange: (int count){
                    Future.delayed(Duration(seconds: 1),(){
                      unreadSingleCount=count;
                      unreadGrouCount=UserController.find.unreadMsgCount.value-unreadSingleCount;
                    });
                 //   flog('MessagesPage unreadCountChange $count');
                  },
              type: type_single_chat,
            )),
            KeepAliveWrapper(
                child: ConversationListPage(
              unreadCountChange: (count) {
                Future.delayed(Duration(seconds: 1),(){
                  unreadGrouCount=count;
                });
             //   flog('MessagesPage unreadCountChange---$count');
              },
              type: type_group,
            )),
          ]),
        ),
      ],
    );
  }

  Widget tabItem(int index, String tab) {
    if(index==0)return  Obx(() {
      return unreadSingleCount<=0? Text(tab):badges.Badge(
        showBadge: true,
        // showBadge: true,
        badgeContent: Container(
          alignment: Alignment.center,
          child: Obx(()=>Text(
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
      return unreadGrouCount<=0? Text(tab):badges.Badge(
        showBadge: true,
        // showBadge: true,
        badgeContent: Container(
          alignment: Alignment.center,
          child: Obx(()=>Text(
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
