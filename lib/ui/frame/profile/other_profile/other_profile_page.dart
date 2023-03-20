import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';
import 'package:wy/utils/image_util.dart';

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
                          style: TextStyle(fontSize: 16),
                        ))),
                    centerTitle: true,
                    expandedHeight: 215 + 100,
                    toolbarHeight: 44,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 215,
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
                                    padding: EdgeInsets.only(left: 20, bottom: 15),
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
                                                            height: 30,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  height: 30,
                                                                  child: Text(
                                                                    t.player.value.nickName,
                                                                    style: TextStyle(fontSize: 19.sp, color: Colors.white, fontWeight: FontWeight.normal),
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
                                                                      "assets/images/profile/follow.webp",
                                                                      width: 20,
                                                                      color: t.player.value.follow ? Colors.pink : Color(0xFF707070),
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
                                                                Container(
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
                                                                )
                                                              ],
                                                            ),
                                                          )),

                                                      /// email
                                                      // Obx(() => Padding(
                                                      //       padding: const EdgeInsets.only(top: 8),
                                                      //       child: Row(
                                                      //         children: [
                                                      //           Padding(
                                                      //             padding: const EdgeInsets.only(right: 15),
                                                      //             child: Text(
                                                      //               "ID:${userController.userProfile.value.uk}",
                                                      //               style: TextStyle(fontSize: 10.sp, color: Color(0xffC5C5C5), fontWeight: FontWeight.bold),
                                                      //             ),
                                                      //           ),
                                                      //           // Text(
                                                      //           //   t.vm.value.email,
                                                      //           //   style: TextStyle(fontSize: 10.sp, color: Color(0xff54B3EF), fontWeight: FontWeight.normal),
                                                      //           // )
                                                      //         ],
                                                      //       ),
                                                      //     )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
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
                            // Container(
                            //   width: 158,
                            //   height: 26,
                            //   margin: EdgeInsets.only(left: 20),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(13),
                            //     gradient: LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
                            //   ),
                            // ),
                            Container(
                              height: 36,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                t.player.value.signature.isNotEmpty ? t.player.value.signature : "Thank you for your attention and love",
                                style: TextStyle(fontSize: 12, color: Color(0xFF808388)),
                              ),
                            ),
                            Column(
                              children: [
                                Obx(
                                  () => Container(
                                    height: 44,
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
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Fans: ${t.player.value.fans}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        Visibility(
                                          // visible: t.player.value.sex == 1,
                                          child: Text(
                                            "Rating: ${t.player.value.ranking}",
                                            style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          "Services: ${t.player.value.age}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                        preferredSize: Size(double.infinity, 44),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 7, left: 30, right: 20),
                          child: TabBar(
                            controller: t.tabController,
                            isScrollable: false,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            indicatorColor: Color(0xFFFFCB0D),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 2,
                            indicatorPadding: EdgeInsets.only(bottom: 5),
                            labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "din"),
                            unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "din"),
                            tabs: createTabs(),
                          ),
                        )),
                  ),
                ];
              },
              body: TabBarView(controller: t.tabController, children: createPages())),
          Positioned(
              bottom: Get.mediaQuery.padding.bottom + 20,
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
              ))
        ],
      ),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
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
    pages.add(OtherDashboardPage());
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

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
