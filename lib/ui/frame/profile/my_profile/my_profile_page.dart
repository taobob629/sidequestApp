import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/dialog_input.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/my_profile/visitor_page.dart';
import 'package:wy/ui/profile/developer/developer_page.dart';
import 'package:wy/utils/index.dart';

import '../../main_page.dart';
import '../../messages/fans/fans_list_page.dart';
import '../../messages/follow/follow_list_page.dart';
import 'my_album_page.dart';
import 'my_dashboard_page.dart';
import 'my_posts_page.dart';
import 'profile_edit_page.dart';

class MyProfilePage extends StatelessWidget {
  MyProfilePage({Key? key}) : super(key: key);
  final t = Get.put(ProfileController());
  final userController = UserController.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Obx(() => ImageUtil.networkImage(
                      url: t.background.value,
                      fit: BoxFit.cover,
                    )),
                Opacity(
                  opacity: 0.5,
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
                      SafeArea(
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(() => SettingsPage());
                            homeDrawerKey.currentState?.openDrawer();
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 40),
                            child: Icon(Icons.menu, color: Colors.white),
                            // child: Image.asset(
                            //   "assets/images/profile_setting.webp",
                            //   width: 26,
                            // ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: t.goDev,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// nickname
                                      Obx(() => Text(
                                            userController.userProfile.nickName,
                                            style: TextStyle(
                                                fontSize: 19.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                height: 22.5 / 19),
                                          )),

                                      /// labels: sex、language、location
                                      Obx(() => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  height: 16.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: [
                                                            Color(0xFF1F84C9),
                                                            Color(0xFF7CB9D5),
                                                          ])),
                                                  child: Row(
                                                    children: [
                                                      if (userController
                                                              .userProfile
                                                              .gender !=
                                                          2)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 3),
                                                          child: Image.asset(
                                                            "assets/images/profile/icon_sex_${userController.userProfile.gender}.png",
                                                            width: 8,
                                                          ),
                                                        ),
                                                      Text(
                                                        "${userController.userProfile.age}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  height: 16.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      color: Color(0xff32353D)),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        userController
                                                            .userProfile
                                                            .language,
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: userController
                                                      .userProfile
                                                      .location
                                                      .country
                                                      .isNotEmpty,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    height: 16.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color:
                                                            Color(0xff32353D)),
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
                                                          userController
                                                              .userProfile
                                                              .location
                                                              .country,
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),

                                      /// email
                                      Obx(() => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Text(
                                                    "ID:${userController.userProfile.uk}",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color:
                                                            Color(0xffC5C5C5),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                // Text(
                                                //   t.vm.value.email,
                                                //   style: TextStyle(fontSize: 10.sp, color: Color(0xff54B3EF), fontWeight: FontWeight.normal),
                                                // )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => ProfileEditPage());
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 25),
                                child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Obx(() => Container(
                                            height: 64,
                                            alignment: Alignment.bottomCenter,
                                            child: ClipOval(
                                              child: ImageUtil.networkImage(
                                                url: userController
                                                    .userProfile.avatar,
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
                                      Obx(() => Visibility(
                                            visible: userController
                                                        .userProfile.vipLevel >=
                                                    5 &&
                                                userController
                                                        .userProfile.isAuth ==
                                                    1,
                                            child: Positioned(
                                                bottom: -10,
                                                child: Image.asset(
                                                  "assets/images/profile/icon_level_${userController.userProfile.vipLevel == 0 ? 5 : userController.userProfile.vipLevel}.webp",
                                                  height: 28,
                                                )),
                                          )),
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
          Divider(
            indent: 20,
            endIndent: 20,
            height: 1,
            color: Color(0xff262731),
          ),

          /// Followers、Fans、Rating
          Obx(
            () => Container(
              height: 44,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => FollowListPage()),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        "Followers".tr +
                            ": ${userController.userProfile.followers}",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => FansListPage()),
                    child: Text(
                      "Fans".tr + ":${userController.userProfile.fans}",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: userController.userProfile.isAuth == 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Rating".tr + ":${userController.userProfile.ranking}",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => VisitorPage()),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          if (userController.userProfile.visitor > 0)
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          2.horizontalSpace,
                          Text(
                            "Visitor".tr +
                                ":${userController.userProfile.visitor}",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 1,
            color: Color(0xff262731),
          ),

          /// dashboard、post、album
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 30, right: 20),
            child: TabBar(
              controller: t.tabController,
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorColor: Color(0xFFFFCB0D),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.only(bottom: 5),
              labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              labelStyle: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "din"),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "din"),
              tabs: createTabs(),
            ),
          ),

          Expanded(
              child: TabBarView(
                  controller: t.tabController, children: createPages()))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print(t.vm.value.countryModel);
      //   },
      // ),
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
    // pages.add(KeepAliveWrapper(child: ProfileDashboardPage()));
    // pages.add(KeepAliveWrapper(child: ProfilePostsPage()));
    // pages.add(KeepAliveWrapper(child: ProfileAlbumPage()));
    pages.add(MyDashboardPage());
    pages.add(MyPostsPage());
    pages.add(MyAlbumPage());
    return pages;
  }
}

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProfileController get find => Get.find();

  late TabController tabController;

  // final vm = ProfileModel().obs;
  final background = "".obs;

  final userController = UserController.find;

  int devCount = 0;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    background.value =
        StorageManager.sharedPreferences.getString("ProfileBackground") ?? "";
    if (userController.userProfile.backGround.isNotEmpty) {
      background.value = userController.userProfile.backGround;
    }

    userController.getRxuserProfile().listen((info) {
      background.value = info.backGround;
    });
    // getProfileInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // getProfileInfo() {
  //   ProfileApi.getProfileInfo().then((value) {
  //     vm.value = ProfileModel.fromJson(value);
  //   });
  // }

  void goDev() {
    //  Get.to(SettingsPage());
    devCount++;
    if (devCount < 6) {
      return;
    }
    devCount = 0;

    Get.dialog(InputDialog(),
            barrierDismissible: true, barrierColor: Colors.black26)
        .then((value) {
      if (value == "9637") {
        Get.to(() => DeveloperPage());
      } else {
        Get.back();
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
