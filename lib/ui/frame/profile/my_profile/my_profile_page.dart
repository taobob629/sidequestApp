import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/dialog_input.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/developer/developer_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_profile.dart';

import '../../../../config/app_pages.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../order/my_orders/my_orders_page.dart';
import '../../../profile/balance/balance_page.dart';
import '../../../profile/events/my_events_page.dart';
import '../../../profile/task/task_page.dart';
import '../../../profile/wallet/new_wallet_page.dart';
import 'my_album_page.dart';
import 'my_dashboard_page.dart';
import 'my_posts_page.dart';
import 'profile_edit_page.dart';

class MyProfilePage extends StatelessWidget {
  MyProfilePage({Key? key}) : super(key: key);
  final t = Get.put(ProfileController());
  final userController = UserController.find;
  final user = UserController.find.userProfile;

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
                            onTap: () => Get.toNamed(AppPages.Setting),
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
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Obx(() => VoiceProfileWidget(
                                    pwId: userController.userProfile.pwId,
                                    voice:
                                        userController.userProfile.voice?.value,
                                    maginBottom: 0,
                                    marginLeft: 12.w,
                                    width: 100.w,
                                    toRecordPage: () =>
                                        userController.toRecordPage(context),
                                  ))
                              // Container(
                              //   width: 98.w,
                              //   height: 30.h,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), bottomLeft: Radius.circular(15.r)),
                              //       gradient: LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
                              //       boxShadow: [
                              //         BoxShadow(color: Color(0x29632BDA), offset: Offset(0, 3.5), blurRadius: 8, spreadRadius: 0.5),
                              //         BoxShadow(color: Color(0x29FFFFFF), offset: Offset(0, -1.5), blurRadius: 10, spreadRadius: 0.5),
                              //       ]),
                              //   child: Row(
                              //     children: [
                              //       GestureDetector(
                              //         onTap: () {
                              //           //播放
                              //           AudioManager.instance.play(userController.userProfile.voice);
                              //         },
                              //         child: Row(
                              //           children: [
                              //             6.horizontalSpace,
                              //             Image.asset("assets/images/profile/icon_voice_play.webp", width: 20, height: 20),
                              //             8.horizontalSpace,
                              //             Image.asset("assets/images/profile/icon_voice_progress.webp", height: 13.h, fit: BoxFit.cover),
                              //           ],
                              //         ),
                              //       ),
                              //       Expanded(
                              //           child: GestureDetector(
                              //             onTap: () {
                              //               //编辑
                              //               userController.toRecordPage(context);
                              //             },
                              //             child: Container(
                              //               alignment: Alignment.center,
                              //               child: ImageUtil.assetImage('ic_edit', width: 14),
                              //             ),
                              //           )),
                              //     ],
                              //   ),
                              // ),
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
                                                if (userController
                                                        .userProfile.gender ==
                                                    0) ...[
                                                  Color(0xFF1F84C9),
                                                  Color(0xFF7CB9D5),
                                                ] else if (userController
                                                        .userProfile.gender ==
                                                    1) ...[
                                                  Color(0xFFD57CAB),
                                                  Color(0xFFC91FA7),
                                                ] else ...[
                                                  Color(0xFF99BCCC),
                                                  Color(0xFF587284),
                                                ]
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
                                            )
                                          else
                                            Text(
                                              "?",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
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
                      InkWell(
                        onTap: () => NavigatorHelper.toOtherProfile(
                            userController.userProfile.pwId),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20.w, top: 10.h, bottom: 10.h, right: 10.w),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 16.w,
                          ),
                        ),
                      ),
                      20.horizontalSpace,
                    ],
                  ),
                ),
              ),
            ),

            achievements(),

            /// Followers、Fans、Rating
            // Obx(
            //   () => Container(
            //     height: 76.h,
            //     padding: EdgeInsets.symmetric(horizontal: 15.w),
            //     margin: EdgeInsets.all(15.w),
            //     decoration: BoxDecoration(
            //       color: Color(0xff262731),
            //       borderRadius: BorderRadius.circular(15.r),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Expanded(
            //           child: GestureDetector(
            //             behavior: HitTestBehavior.translucent,
            //             onTap: () => Get.to(() => FollowListPage()),
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 15),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   badges.Badge(
            //                     showBadge:
            //                         userController.userProfile.followerToday >
            //                             0,
            //                     badgeContent: Container(
            //                       alignment: Alignment.center,
            //                       child: Text(
            //                         "${userController.userProfile.followerToday}",
            //                         style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 10.sp,
            //                         ),
            //                         maxLines: 1,
            //                       ),
            //                     ),
            //                     badgeColor: Color(0xffFF4848),
            //                     position:
            //                         badges.BadgePosition(end: -10, top: -6),
            //                     alignment: Alignment.topRight,
            //                     child: Text(
            //                       userController.userProfile.followers < 10000
            //                           ? '${userController.userProfile.followers}'
            //                           : '9999+',
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 20.sp,
            //                           fontWeight: FontWeight.bold),
            //                     ),
            //                   ),
            //                   7.verticalSpace,
            //                   Text(
            //                     "Followings".tr,
            //                     style: TextStyle(
            //                       fontSize: 11.sp,
            //                       color: Color(0xff808388),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //         Expanded(
            //           child: GestureDetector(
            //             behavior: HitTestBehavior.translucent,
            //             onTap: () => Get.to(() => FansListPage()),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 badges.Badge(
            //                   showBadge: false,
            //                   badgeContent: Text(
            //                     "${userController.userProfile.fans}",
            //                     style: TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 10.sp,
            //                     ),
            //                   ),
            //                   badgeColor: Color(0xffFF4848),
            //                   position: badges.BadgePosition(end: -10, top: -6),
            //                   alignment: Alignment.topRight,
            //                   child: Text(
            //                     "${userController.userProfile.fans}",
            //                     style: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 20.sp,
            //                         fontWeight: FontWeight.bold),
            //                   ),
            //                 ),
            //                 7.verticalSpace,
            //                 Text(
            //                   "Followers".tr,
            //                   style: TextStyle(
            //                     fontSize: 11.sp,
            //                     color: Color(0xff808388),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //         if (userController.userProfile.isAuth == 1)
            //           Expanded(
            //             child: GestureDetector(
            //               onTap: () {
            //                 Get.to(() => RatingCommentPage());
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.only(left: 15),
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     badges.Badge(
            //                       showBadge: false,
            //                       badgeContent: Text(
            //                         "${userController.userProfile.ranking}",
            //                         style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 10.sp,
            //                         ),
            //                       ),
            //                       badgeColor: Color(0xffFF4848),
            //                       position:
            //                           badges.BadgePosition(end: -10, top: -6),
            //                       alignment: Alignment.topRight,
            //                       child: Text(
            //                         "${userController.userProfile.ranking}",
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 20.sp,
            //                             fontWeight: FontWeight.bold),
            //                       ),
            //                     ),
            //                     7.verticalSpace,
            //                     Text(
            //                       "Rating".tr,
            //                       style: TextStyle(
            //                         fontSize: 11.sp,
            //                         color: Color(0xff808388),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         Expanded(
            //           child: GestureDetector(
            //             behavior: HitTestBehavior.translucent,
            //             onTap: () async {
            //               await Get.to(() => VisitorPage());
            //               userController.updateInfo();
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.only(left: 15),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   badges.Badge(
            //                     showBadge:
            //                         userController.userProfile.visitorToday > 0,
            //                     badgeContent: Text(
            //                       '${userController.userProfile.visitorToday}',
            //                       style: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 10.sp,
            //                       ),
            //                     ),
            //                     badgeColor: Color(0xffFF4848),
            //                     position:
            //                         badges.BadgePosition(end: -10, top: -6),
            //                     alignment: Alignment.topRight,
            //                     child: Text(
            //                       userController.userProfile.visitor < 10000
            //                           ? '${userController.userProfile.visitor}'
            //                           : '9999+',
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 20.sp,
            //                           fontWeight: FontWeight.bold),
            //                       maxLines: 1,
            //                     ),
            //                   ),
            //                   7.verticalSpace,
            //                   Text(
            //                     "Visitors".tr,
            //                     style: TextStyle(
            //                       fontSize: 11.sp,
            //                       color: Color(0xff808388),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 15.h,
              ),
              margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
              decoration: BoxDecoration(
                color: Color(0xff262731),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => Visibility(
                            visible: userController.online.value,
                            child: Expanded(
                              child: _dashboardLabelItem(
                                "assets/images/profile/icon_wallet.webp",
                                "Wallet".tr,
                                onTap: () {
                                  Get.to(() => NewWalletPage());
                                },
                              ),
                            ),
                          )),
                      Expanded(
                        child: _dashboardLabelItem(
                          "assets/images/profile/icon_sidekick.webp",
                          "SideKick".tr,
                          onTap: () {
                            //  Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 0);
                            Get.toNamed(AppPages.SkillList)
                                ?.then((value) => userController.updateInfo());
                          },
                          badgeNum: userController.userProfile.sidekickNum,
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_order,
                          "Orders".tr,
                          onTap: () => Get.to(
                            () => MyOrdersPage(),
                          )?.then((value) => userController.updateInfo()),
                          badgeNum: userController.userProfile.orderNum,
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
                          onTap: () => Get.to(() => MyPostsPage())
                              ?.then((value) => userController.updateInfo()),
                          badgeNum: userController.userProfile.postNum,
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
                      Expanded(
                        child: _dashboardLabelItem(
                          "assets/images/profile/icon_task.webp",
                          "Task".tr,
                          onTap: () => Get.to(() => TaskPage())
                              ?.then((value) => userController.updateInfo()),
                          badgeNum: userController.userProfile.taskNum,
                        ),
                      ),
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

  Widget achievements() => Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15).r,
        padding: EdgeInsets.all(15).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Color(0xff262731),
        ),
        child: Row(
          children: [
            achievementItem(user.coin, 'ic_balance_money'),
            achievementItem(user.diamond, 'diamonds_red'),
            achievementItem(user.balanceMoney(), 'ic_corns_new'),
            achievementItem(user.coupons, 'ic_coupons_new'),
          ],
        ),
      );

  Widget achievementItem(var text, var icon) {
    var textStyle = TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 12.sp, fontFamily: FONT_MEDIUM);
    double width = 18;
    double height = 18;
    switch (icon) {
      case 'ic_balance_money':
        width = 18;
        height = 18;
        break;
      case 'ic_coupons_new':
        width = 22;
        height = 18;
        break;
      case 'diamonds_red':
        width = 18;
        height = 18;
        break;
      case 'ic_corns_new':
        width = 22;
        height = 18;
        break;
    }
    return Expanded(
      child: InkWell(
        onTap: () {
          switch (icon) {
            case 'ic_balance_money':
              if (StorageManager.getOnline())
                Get.toNamed(AppPages.WALLET_PAGE,
                    arguments: Map()..['page'] = 0);
              break;
            case 'ic_coupons_new':
              NavigatorHelper.gotoCouponTabPage(
                  whenComplete: () => UserController.instance().updateInfo());
              break;
            case 'diamonds_red':
              StorageManager.getOnline()
                  ? Get.toNamed(AppPages.WALLET_PAGE,
                      arguments: Map()..['page'] = 1)
                  : null;
              break;
            case 'ic_corns_new':
              if (StorageManager.getOnline())
                Get.to(() => BalancePage())?.whenComplete(
                    () => UserController.instance().updateInfo());
              break;
          }
        },
        child: Column(
          children: [
            ImageUtil.assetImage(icon, width: width, height: height),
            6.verticalSpace,
            Text(
              '$text' ?? '',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardLabelItem(String imageName, String title,
          {Function()? onTap, int badgeNum = 0}) =>
      GestureDetector(
        onTap: () => onTap?.call(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              badges.Badge(
                showBadge: badgeNum > 0,
                badgeContent: Text(
                  '$badgeNum',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
                badgeColor: Color(0xffFF4848),
                position: badges.BadgePosition(end: -10, top: -6),
                alignment: Alignment.topRight,
                child: Image.asset(
                  imageName,
                  width: 26,
                ),
              ),
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
      "Info".tr,
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
