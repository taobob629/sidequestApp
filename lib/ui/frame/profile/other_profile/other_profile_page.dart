import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';
import 'package:wy/ui/im/play_order.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/index.dart';

import '../../../../model/pay_info_model.dart';
import '../../messages/chat/chat_page.dart';
import '../play_order/play_order_page.dart';
import 'other_album_page.dart';
import 'other_dashboard_page.dart';
import 'other_posts_page.dart';

class OtherProfilePage extends StatelessWidget {
  OtherProfilePage({Key? key}) : super(key: key);
  final t = Get.put(OtherProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          NestedScrollView(
              controller: t.scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    title: Obx(() => Visibility(
                        visible: t.showTitle.value,
                        child: Text(
                          t.player.value.nickName,
                          style: TextStyle(fontSize: 19.sp, fontFamily: FONT_LIGHT),
                        ))),
                    centerTitle: true,
                    expandedHeight: 358 - Get.mediaQuery.padding.top,
                    toolbarHeight: 44,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        // color: Colors.lightBlue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                // height: 208,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Obx(() => ImageUtil.networkImage(
                                          url: t.player.value.backGround,
                                          fit: BoxFit.cover,
                                        )),
                                    Opacity(
                                      opacity: 0.9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Color(0x00131010), Color(0xFF1B1A1E)],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20, bottom: 15.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// nickname
                                                        Obx(() => Container(
                                                              height: 30.h,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 30.h,
                                                                    child: Text(
                                                                      t.player.value.nickName,
                                                                      style: TextStyle(fontSize: 19.sp, fontFamily: FONT_LIGHT),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      t.followOrNot();
                                                                    },
                                                                    child: Container(
                                                                      height: 30,
                                                                      padding: const EdgeInsets.only(left: 10),
                                                                      child: Image.asset(
                                                                        t.player.value.follow ? "assets/images/profile/followed.webp" : "assets/images/profile/follow.webp",
                                                                        width: 20,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )),

                                                        /// labels: sex、language、location
                                                        Obx(() => Padding(
                                                              padding: const EdgeInsets.only(top: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                                    margin: EdgeInsets.only(right: 10),
                                                                    height: 16.h,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(3),
                                                                        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                                                                          Color(0xFF1F84C9),
                                                                          Color(0xFF7CB9D5),
                                                                        ])),
                                                                    child: Row(
                                                                      children: [
                                                                        if (t.player.value.sex != 2)
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 3),
                                                                            child: Image.asset(
                                                                              "assets/images/profile/icon_sex_${t.player.value.sex}.png",
                                                                              width: 8,
                                                                            ),
                                                                          ),
                                                                        Text(
                                                                          "${t.player.value.age}",
                                                                          style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                                    margin: EdgeInsets.only(right: 10),
                                                                    height: 16.h,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff32353D)),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          t.player.value.language,
                                                                          style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: t.player.value.location.country.isNotEmpty,
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                                      margin: EdgeInsets.only(right: 10),
                                                                      height: 16.h,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff32353D)),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/images/profile/icon_dibiao.webp",
                                                                            width: 8,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Text(
                                                                            t.player.value.location.country,
                                                                            style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (!t.isSelf) {
                                                      UserController.find.jumpChat(t.player.value.uk);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 25),
                                                    child: Stack(alignment: AlignmentDirectional.center, clipBehavior: Clip.none, children: [
                                                      Obx(() => Container(
                                                            height: 64,
                                                            alignment: Alignment.bottomCenter,
                                                            child: ClipOval(
                                                              child: ImageUtil.networkImage(
                                                                url: t.player.value.avatar,
                                                                width: 60,
                                                                height: 60,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          )),
                                                      Image.asset(
                                                        "assets/images/profile_avatar_border.webp",
                                                        width: 64,
                                                      ),
                                                      // Obx(() => Visibility(
                                                      //       visible: userController.userProfile.value.vipLevel >= 5 && userController.userProfile.value.isAuth == 1,
                                                      //       child: Positioned(
                                                      //           bottom: -10,
                                                      //           child: Image.asset(
                                                      //             "assets/images/profile/icon_level_${userController.userProfile.value.vipLevel == 0 ? 5 : userController.userProfile.value.vipLevel}.webp",
                                                      //             height: 28,
                                                      //           )),
                                                      //     )),
                                                    ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 158,
                              height: 26,
                              margin: EdgeInsets.only(left: 20, bottom: 12),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  gradient: LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
                                  boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 0.5, offset: Offset(0, 3.5))]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/images/profile/icon_voice_record.webp",
                                    height: 14,
                                  ),
                                  Image.asset(
                                    "assets/images/profile/icon_voice.webp",
                                    height: 14,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              height: 28,
                              alignment: Alignment.topLeft,
                              child: Text(
                                t.player.value.signature.isNotEmpty ? t.player.value.signature : "Thank you for your attention and love",
                                style: TextStyle(fontSize: 12.sp, color: Color(0xFF808388), fontFamily: FONT_LIGHT),
                              ),
                            ),
                            Column(
                              children: [
                                Obx(
                                  () => Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: BorderSide(color: AppColor.itemBg, width: 1),
                                      bottom: BorderSide(color: AppColor.itemBg, width: 1),
                                    )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Followers: ${t.player.value.followers}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                        ),
                                        Text(
                                          "Fans: ${t.player.value.fans}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                        ),
                                        Visibility(
                                          child: Text(
                                            "Rating: ${t.player.value.ranking}",
                                            style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                          ),
                                        ),
                                        Text(
                                          "Services: ${t.player.value.age}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                        preferredSize: Size(double.infinity, 40),
                        child: Container(
                          // color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, left: 30, right: 20),
                            child: TabBar(
                              controller: t.tabController,
                              isScrollable: false,
                              labelColor: Colors.white,
                              unselectedLabelColor: AppColor.textC5C5,
                              indicatorColor: Color(0xFFFFCB0D),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 2,
                              indicatorPadding: EdgeInsets.only(bottom: 5),
                              labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                              labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM),
                              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM),
                              tabs: createTabs(),
                            ),
                          ),
                        )),
                  ),
                ];
              },
              body: TabBarView(controller: t.tabController, children: createPages())),
          if (!t.isSelf)
            Positioned(
                bottom: Get.mediaQuery.padding.bottom + 20,
                child: GestureDetector(
                  onTap: () {
                    t.jumpChat(t.player.value.uk);
                  },
                  child: Visibility(
                    child: Container(
                      width: 240,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: AppColor.yellowGradient),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Image.asset(
                              "assets/images/profile/icon_pinlun.webp",
                              width: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Message",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    if (t.player.value.isAuth)
      tabs.add(Text(
        "Dashboard".tr,
      ));
    tabs.add(Text(
      "Posts".tr,
    ));
    tabs.add(Text(
      "Album".tr,
    ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    if (t.player.value.isAuth) pages.add(OtherDashboardPage());
    pages.add(OtherPostsPage());
    pages.add(OtherAlbumPage());
    return pages;
  }
}

class OtherProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  static OtherProfileController get find => Get.find();

  late TabController tabController;
  // final vm = ProfileModel().obs;
  final showTitle = false.obs;

  final player = PlayerInfoModel().obs;

  final selGame = GamesItem().obs;

  ScrollController scrollController = ScrollController();

  double limitedHeight = 88 + Get.mediaQuery.padding.top;

  bool isSelf = false;

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    player.value = Get.arguments;
    isSelf = UserController.find.userProfile.value.pwId == player.value.uid;

    scrollController.addListener(() {
      showTitle.value = scrollController.offset >= limitedHeight;
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getProfileInfo();
  }

  getProfileInfo() {
    ProfileApi.getPlayerInfo(playerId: player.value.uid).then((value) {
      player.value = value..uid = player.value.uid;
    });
  }

  followOrNot() {
    if (isSelf) {
      return;
    }
    UserApi.attention(player.value.uid).then((value) {
      player.value.follow = !player.value.follow;
      player.refresh();
    }).catchError((e) {
      print(e);
    });
  }

  editService(GamesItem game, ServiceItem serviceItem) async {
    if (isSelf) {
      Get.toNamed(AppPages.ServiceAndOrders);
    } else {
      var uk = await Get.to(() {
        return MulitablePlayOrderPage(
          serviceItemList: [serviceItem],
        );
      });
      // flog('$res', 'Get.to(()=>PlayOrder');
      if (uk != null) {
        if (uk == 0) {
          Get.back();
          MainPageController.find.currentIndex.value = 3;
          MainPageController.find.controller.jumpToPage(3);
        } else {
          jumpChat(uk);
        }
      }
    }
  }

  jumpChat(uk) {
    UserController.find.jumpChat(uk);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
