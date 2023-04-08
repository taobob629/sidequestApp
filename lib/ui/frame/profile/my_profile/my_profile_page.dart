import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/common/dialog_input.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/my_profile/visitor_page.dart';
import 'package:wy/ui/profile/developer/developer_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_widget.dart';

import '../../../../config/app_pages.dart';
import '../../../../image_utils.dart';
import '../../../order/my_orders/my_orders_page.dart';
import '../../../profile/events/my_events_page.dart';
import '../../../profile/wallet/new_wallet_page.dart';
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
      body: SingleChildScrollView(
        child: Column(
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
                              margin: EdgeInsets.only(right: 20.w),
                              child: Image.asset(
                                "assets/images/profile_setting.webp",
                                width: 26.w,
                                height: 26.w,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(() => ProfileEditPage()),
                                child: Container(
                                  margin: EdgeInsets.only(right: 25),
                                  child: Row(
                                    children: [
                                      Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Obx(() => Container(
                                                  height: 64,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: ClipOval(
                                                    child:
                                                        ImageUtil.networkImage(
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
                                                              .userProfile
                                                              .vipLevel >=
                                                          5 &&
                                                      userController.userProfile
                                                              .isAuth ==
                                                          1,
                                                  child: Positioned(
                                                      bottom: -10,
                                                      child: Image.asset(
                                                        "assets/images/profile/icon_level_${userController.userProfile.vipLevel == 0 ? 5 : userController.userProfile.vipLevel}.webp",
                                                        height: 28,
                                                      )),
                                                )),
                                          ]),
                                      VoiceWidget(
                                          pwId: userController.userProfile.pwId,
                                          voice: userController.userProfile.voice,
                                          maginBottom: 0,
                                          marginLeft: 12.w,
                                          play: ()=>AudioManager.instance.play(userController.userProfile.voice),
                                          toRecordPage:()=> userController.toRecordPage(context),
                                          )
                                    ],
                                  ),
                                ),
                              ),
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

            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: GestureDetector(
                onTap: t.goDev,
                child: Container(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// nickname
                          Obx(() => Text(
                                userController.userProfile.nickName,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          6.verticalSpace,

                          /// labels: sex、language、location
                          Obx(() => Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.only(right: 10),
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFF1F84C9),
                                                Color(0xFF7CB9D5),
                                              ])),
                                      child: Row(
                                        children: [
                                          if (userController
                                                  .userProfile.gender !=
                                              2)
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.only(right: 10),
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Color(0xff32353D)),
                                      child: Row(
                                        children: [
                                          Text(
                                            userController.userProfile.language,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: userController.userProfile
                                          .location.country.isNotEmpty,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.only(right: 10),
                                        height: 16.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Color(0xff32353D)),
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
                                                  .userProfile.location.country,
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        "ID:${userController.userProfile.uk}",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Color(0xffC5C5C5),
                                            fontWeight: FontWeight.bold),
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
                      Spacer(),
                      GestureDetector(
                        onTap: () => NavigatorHelper.toOtherProfile(
                            userController.userProfile.pwId),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                      20.horizontalSpace,
                    ],
                  ),
                ),
              ),
            ),

            /// Followers、Fans、Rating
            Obx(
              () => Container(
                height: 76.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                margin: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Color(0xff262731),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.to(() => FollowListPage()),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              badges.Badge(
                                showBadge:
                                    userController.userProfile.followerToday >
                                        0,
                                badgeContent: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${userController.userProfile.followerToday}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                badgeColor: Color(0xffFF4848),
                                position:
                                    badges.BadgePosition(end: -10, top: -6),
                                alignment: Alignment.topRight,
                                child: Text(
                                  userController.userProfile.followers < 10000
                                      ? '${userController.userProfile.followers}'
                                      : '9999+',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              7.verticalSpace,
                              Text(
                                "Followers".tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xff808388),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.to(() => FansListPage()),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            badges.Badge(
                              showBadge: false,
                              badgeContent: Text(
                                "${userController.userProfile.fans}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                              badgeColor: Color(0xffFF4848),
                              position: badges.BadgePosition(end: -10, top: -6),
                              alignment: Alignment.topRight,
                              child: Text(
                                "${userController.userProfile.fans}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            7.verticalSpace,
                            Text(
                              "Fans".tr,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Color(0xff808388),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (userController.userProfile.isAuth == 1)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              badges.Badge(
                                showBadge: false,
                                badgeContent: Text(
                                  "${userController.userProfile.ranking}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                badgeColor: Color(0xffFF4848),
                                position:
                                    badges.BadgePosition(end: -10, top: -6),
                                alignment: Alignment.topRight,
                                child: Text(
                                  "${userController.userProfile.ranking}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              7.verticalSpace,
                              Text(
                                "Rating".tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xff808388),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.to(() => VisitorPage()),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              badges.Badge(
                                showBadge:
                                    userController.userProfile.visitorToday > 0,
                                badgeContent: Text(
                                  '${userController.userProfile.visitorToday}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                badgeColor: Color(0xffFF4848),
                                position:
                                    badges.BadgePosition(end: -10, top: -6),
                                alignment: Alignment.topRight,
                                child: Text(
                                  userController.userProfile.visitor < 10000
                                      ? '${userController.userProfile.visitor}'
                                      : '9999+',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                              ),
                              7.verticalSpace,
                              Text(
                                "Visitor".tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xff808388),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 15.h,
              ),
              margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h),
              decoration: BoxDecoration(
                color: Color(0xff262731),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _dashboardLabelItem(
                          "assets/images/profile/icon_wallet.webp",
                          "Wallet".tr,
                          onTap: () {
                            Get.to(() => NewWalletPage());
                          },
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          "assets/images/profile/icon_sidekick.webp",
                          "SideKick".tr,
                          onTap: () {
                            //  Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 0);
                            Get.toNamed(AppPages.ServiceAndOrders);
                          },
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_order,
                          "Order".tr,
                          onTap: () => Get.to(
                            () => MyOrdersPage(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_ablum,
                          "Album".tr,
                          onTap: () => Get.to(() => MyAlbumPage()),
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_post,
                          "Post".tr,
                          onTap: () => Get.to(() => MyPostsPage()),
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          "assets/images/profile/icon_bookings.webp",
                          "Bookings".tr,
                          onTap: () {
                            Get.toNamed(AppPages.BOOKING_PAGE);
                          },
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          "assets/images/profile/icon_activities.webp",
                          "Activities".tr,
                          onTap: () {
                            Get.to(() => MyEventsPage());
                          },
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),

            MyDashboardPage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print(t.vm.value.countryModel);
      //   },
      // ),
    );
  }

  Widget _dashboardLabelItem(String imageName, String title,
          {Function()? onTap}) =>
      GestureDetector(
        onTap: () => onTap?.call(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageName,
                width: 26,
              ),
              4.verticalSpace,
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      );

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
