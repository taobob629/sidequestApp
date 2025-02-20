import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/ui/pages/notification/notification_page.dart';
import 'package:sq_hub_app/ui/pages/profile/qrcode/my_qr_code_page.dart';
import 'package:sq_hub_app/ui/pages/profile/my_profile/select_avatar_dialog.dart';
import 'package:sq_hub_app/ui/pages/profile/vip/vip_page.dart';
import 'package:sq_hub_app/ui/pages/setting/settings_page.dart';

import '../../../../api/wy_http.dart';
import '../../../../common/dialog_input.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../model/profile_model.dart';
import '../../../../model/task_model.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../utils/storage_manager.dart';
import '../../../../utils/toast_utils.dart';
import '../../../../widget/my_progressbar.dart';
import '../../../consum/list/view.dart';
import '../../booking/booking_page.dart';
import '../../connections/connections_page.dart';
import '../../messages/messages_page.dart';
import '../../order/list/view.dart';
import '../balance/balance_page.dart';
import '../developer/developer_page.dart';
import '../events/my_events_page.dart';
import '../integral/integral_home_page.dart';
import '../task/detail/task_detail_page.dart';
import 'my_dashboard_page.dart';

class MyProfilePage extends StatelessWidget {
  MyProfilePage({Key? key}) : super(key: key);
  final t = Get.put(ProfileController());
  final userController = UserController.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColor('0A0A0A'),
      body: SmartRefresher(
        controller: t.refreshController,
        onRefresh: () => t.onRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => SettingsPage())
                                ?.then((value) => t.onRefresh()),
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: OvalBorder(),
                              ),
                              child: Image.asset(
                                ImageUtils.profile_setting,
                                scale: 1.8,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(() => MyQrCodePage()),
                            child: Container(
                              height: 30.w,
                              margin: EdgeInsets.only(
                                right: 15.w,
                                left: 10.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Image.asset(
                                ImageUtils.scan_code_icon,
                                scale: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => showCustom(
                            SelectAvatarDialog(),
                            alignment: Alignment.bottomCenter,
                            clickMaskDismiss: true,
                          ),
                          child: Obx(() => Container(
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity:
                                      userController.userProfile.userAvatar == 1
                                          ? 1
                                          : 0.3,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          userController.userProfile.avatar,
                                      width: 50.w,
                                      height: 50.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: t.goDev,
                            child: Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// nickname
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Obx(() => Text(
                                              userController
                                                  .userProfile.nickName,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                      6.horizontalSpace,
                                      Obx(() => Visibility(
                                            visible: t.user.value.vipLevel >= 5,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Get.to(() => VipPage()),
                                              child: Image.asset(
                                                "assets/images/huizhang_${UserController.find.userProfile.vipLevel == 0 ? 5 : UserController.find.userProfile.vipLevel}.webp",
                                                height: 20.w,
                                              ),
                                            ),
                                          )),
                                      12.horizontalSpace,
                                    ],
                                  ),
                                  4.verticalSpace,

                                  Row(
                                    children: [
                                      Obx(() => Text(
                                            "${userController.userProfile.uk}",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          )),
                                      6.horizontalSpace,
                                      InkWell(
                                        onTap: () async {
                                          // 将文本复制到剪贴板
                                          await Clipboard.setData(
                                            ClipboardData(
                                                text: userController
                                                    .userProfile.uk),
                                          );
                                          showToast("copy UK id");
                                        },
                                        child: SvgPicture.asset(
                                          ImageUtils.icon_copy,
                                          width: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// labels: sex、language、location
                                  // Row(
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: () =>
                                  //           Get.to(() => FollowListPage()),
                                  //       child: Obx(() => Text(
                                  //             '${t.user.value.followers}',
                                  //             textAlign: TextAlign.center,
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 16.sp,
                                  //               fontFamily: FONT_MEDIUM,
                                  //               fontWeight: FontWeight.w700,
                                  //             ),
                                  //           )),
                                  //     ),
                                  //     6.horizontalSpace,
                                  //     InkWell(
                                  //       onTap: () =>
                                  //           Get.to(() => FollowListPage()),
                                  //       child: Text(
                                  //         'Followers',
                                  //         style: TextStyle(
                                  //           color: Color(0xFF808388),
                                  //           fontSize: 12.sp,
                                  //           fontFamily: FONT_MEDIUM,
                                  //           fontWeight: FontWeight.w400,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       width: 1.w,
                                  //       height: 14.h,
                                  //       margin: EdgeInsets.symmetric(
                                  //           horizontal: 12.w),
                                  //       decoration: BoxDecoration(
                                  //           color: Color(0xFF727272)),
                                  //     ),
                                  //     InkWell(
                                  //       onTap: () =>
                                  //           Get.to(() => FansListPage())
                                  //               ?.whenComplete(() {
                                  //         t.onRefresh();
                                  //       }),
                                  //       child: Obx(() => Text(
                                  //             '${t.user.value.fans}',
                                  //             textAlign: TextAlign.center,
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 16.sp,
                                  //               fontFamily: FONT_MEDIUM,
                                  //               fontWeight: FontWeight.w700,
                                  //             ),
                                  //           )),
                                  //     ),
                                  //     6.horizontalSpace,
                                  //     Obx(() => badges.Badge(
                                  //           showBadge: t.user.value.newFans > 0,
                                  //           badgeColor: Color(0xffFF4848),
                                  //           alignment: Alignment.centerRight,
                                  //           padding: EdgeInsets.all(3.r),
                                  //           position: badges.BadgePosition(
                                  //             top: -4.h,
                                  //             end: -4.w,
                                  //           ),
                                  //           child: InkWell(
                                  //             onTap: () =>
                                  //                 Get.to(() => FansListPage())
                                  //                     ?.whenComplete(() {
                                  //               t.onRefresh();
                                  //             }),
                                  //             child: Text(
                                  //               'Fans',
                                  //               style: TextStyle(
                                  //                 color: Color(0xFF808388),
                                  //                 fontSize: 12.sp,
                                  //                 fontFamily: FONT_MEDIUM,
                                  //                 fontWeight: FontWeight.w400,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         )),
                                  //     Container(
                                  //       width: 1.w,
                                  //       height: 14.h,
                                  //       margin: EdgeInsets.symmetric(
                                  //           horizontal: 12.w),
                                  //       decoration: BoxDecoration(
                                  //           color: Color(0xFF727272)),
                                  //     ),
                                  //     InkWell(
                                  //       onTap: () =>
                                  //           Get.to(() => MyPostsPage()),
                                  //       child: Obx(() => Text(
                                  //             '${t.user.value.posts}',
                                  //             textAlign: TextAlign.center,
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 16.sp,
                                  //               fontFamily: FONT_MEDIUM,
                                  //               fontWeight: FontWeight.w700,
                                  //             ),
                                  //           )),
                                  //     ),
                                  //     6.horizontalSpace,
                                  //     InkWell(
                                  //       onTap: () =>
                                  //           Get.to(() => MyPostsPage()),
                                  //       // onTap: () => NavigatorHelper.toOtherProfile(t.user.value.memberId),
                                  //       child: Text(
                                  //         'Posts',
                                  //         style: TextStyle(
                                  //           color: Color(0xFF808388),
                                  //           fontSize: 12.sp,
                                  //           fontFamily: FONT_MEDIUM,
                                  //           fontWeight: FontWeight.w400,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15).r,
                child: Column(
                  children: [
                    Container(
                      height: 52.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFF141517),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 14.w,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset(ImageUtils.emenry_bg_icon),
                          ),
                          Center(
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageUtils.emenry_pc_icon,
                                  width: 40.w,
                                ),
                                6.horizontalSpace,
                                Expanded(
                                  child: Obx(() => MyProgressbar(
                                        value:
                                            t.user.value.totalmins.toDouble() ==
                                                    0
                                                ? 0
                                                : t.user.value.avamins /
                                                    t.user.value.totalmins
                                                        .toDouble(),
                                        width: 234.w,
                                        height: 12.h,
                                        padding: EdgeInsets.only(
                                          right: t.getProgress(),
                                        ),
                                        direction: Axis.horizontal,
                                        innerDecoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFFF8E0E),
                                                Color(0xFFD7E57F)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6.r)),
                                      )),
                                ),
                                16.horizontalSpace,
                                Obx(() => Text(
                                      t.getShowTime(),
                                      style: TextStyle(
                                        color: Color(0xFFFFCB0D),
                                        fontSize: 14.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    achievements(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 10.h,
                ),
                margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 10.h),
                decoration: ShapeDecoration(
                  color: Color(0xFF141517),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY FEATURES'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w700,
                      ),
                    ).paddingOnly(left: 16.w),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _dashboardLabelItem(
                            ImageUtils.icon_wallet,
                            "Top Up".tr,
                            onTap: () {
                              userController.checkLogin(
                                () => Get.to(() => BalancePage())
                                    ?.whenComplete(() => t.onRefresh()),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: _dashboardLabelItem(
                            ImageUtils.icon_vouchers,
                            "Vouchers".tr,
                            onTap: () => NavigatorHelper.gotoCouponPage(
                              couponType: 5,
                              whenComplete: () => t.onRefresh(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _dashboardLabelItem(
                            ImageUtils.icon_orders,
                            "Orders".tr,
                            onTap: () => Get.to(
                              () => OrderListPage(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _dashboardLabelItem(
                            ImageUtils.icon_bookings,
                            "Bookings".tr,
                            onTap: () {
                              Get.to(
                                () => BookingPage(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Obx(() => _dashboardLabelItem(
                                ImageUtils.icon_connection,
                                "Connections".tr,
                                badgeNum:
                                    userController.userProfile.approvalNum,
                                onTap: () => Get.to(
                                  () => ConnectionsPage(),
                                )?.then((value) => t.onRefresh()),
                              )),
                        ),
                        Expanded(
                          child: _dashboardLabelItem(
                            ImageUtils.icon_consumption,
                            "Your Games".tr,
                            onTap: () => Get.to(() => StoreConsumListPage()),
                          ),
                        ),
                        Expanded(
                          child: Obx(() => _dashboardLabelItem(
                                ImageUtils.message_icon,
                                "Notifications".tr,
                                onTap: () => Get.to(() => NotificationPage()),
                                badgeNum:
                                    UserController.find.unreadMsgCount.value,
                              )),
                        ),
                        Expanded(
                          child: _dashboardLabelItem(
                            ImageUtils.icon_activities,
                            "Activities".tr,
                            onTap: () => Get.to(() => MyEventsPage()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => t.jumpTaskDetail(),
                child: Container(
                  width: 1.sw,
                  height: 100.h,
                  margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 10.h),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF141517), Color(0xFF322531)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      14.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Loyalty Card",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            8.verticalSpace,
                            Obx(() => RichText(
                                  text: TextSpan(
                                    text: "Buy",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontFamily: FONT_MEDIUM,
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            " ${t.user.value.loyaltyModel.loyalty} ",
                                        style: TextStyle(
                                          color: AppColor.yellow,
                                          fontSize: 14.sp,
                                          fontFamily: FONT_MEDIUM,
                                          height: 1.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "more Bubbletea to get a free drink",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: FONT_MEDIUM,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImageUtils.profile_loyalty_icon,
                        width: 120.w,
                      ),
                      8.horizontalSpace,
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: Platform.isAndroid,
                child: MyDashboardPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget achievements() => Container(
        decoration: ShapeDecoration(
          color: Color(0xFF141517),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MY ASSETS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w700,
                  ),
                ).paddingOnly(left: 16.w),
                Obx(() => Visibility(
                      visible: userController.userProfile.lv != -1,
                      child: InkWell(
                        onTap: () => Get.to(() => IntegralHomePage())
                            ?.whenComplete(() => t.onRefresh()),
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              ImageUtils.point_lv_icon,
                              width: 116.w,
                              height: 20.w,
                            ),
                            Container(
                              height: 20.w,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 30.w),
                              child: Text(
                                'Upgrade to LV.${userController.userProfile.lv}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ).marginOnly(right: 16.w),
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                Obx(() => achievementItem(
                      '£${t.user.value.balance}',
                      ImageUtils.ic_corns_new2,
                      "Credits".tr,
                      'UK offline store top-up'.tr,
                      onTap: () {
                        Get.to(() => BalancePage())
                            ?.whenComplete(() => t.onRefresh());
                      },
                    )),
                Obx(() => achievementItem(
                        t.user.value.coupons,
                        ImageUtils.ic_coupons_new,
                        "Vouchers".tr,
                        'Your Coupons'.tr, onTap: () {
                      NavigatorHelper.gotoCouponPage(
                        couponType: 5,
                        whenComplete: () => t.onRefresh(),
                      );
                    })),
                Obx(() => achievementItem(
                    t.user.value.checkTotal,
                    ImageUtils.ic_coupons_points,
                    "Points".tr,
                    'Your Coupons'.tr,
                    onTap: () => Get.to(() => IntegralHomePage())
                        ?.whenComplete(() => t.onRefresh()))),
              ],
            ),
          ],
        ),
      );

  Widget achievementItem(
    var text,
    var icon,
    String iconText,
    String description, {
    required Function onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap.call(),
        child: Column(
          children: [
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  width: 16.w,
                  height: 16.w,
                ),
                6.horizontalSpace,
                Text(
                  iconText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: FONT_MEDIUM,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            15.verticalSpace,
            Text(
              "$text",
              style: TextStyle(
                color: AppColor.yellow,
                fontFamily: FONT_MEDIUM,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
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
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              6.verticalSpace,
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13.sp,
                ),
              )
            ],
          ),
        ),
      );
}

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProfileController get find => Get.find();

  late TabController tabController;

  // final vm = ProfileModel().obs;
  final background = "".obs;

  final userController = UserController.find;

  BuildContext? myContext;

  int devCount = 0;

  var user = ProfileModel().obs;

  double progress = 0.0;

  late RefreshController refreshController;

  // 为了让订阅的Widget滚动到屏幕中间
  ScrollController scrollController = ScrollController();
  GlobalKey targetKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
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

    // bool? profileSetKey = StorageManager.getBoolByKey('profileSetKey');
    // if (profileSetKey == null || profileSetKey == false) {
    //   ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
    //       (_) => ShowCaseWidget.of(myContext!).startShowCase([
    //             GlobalKeyConstants.profileSetKey,
    //             GlobalKeyConstants.profileSetInfoKey,
    //             GlobalKeyConstants.profileVoiceKey,
    //             GlobalKeyConstants.profileCoinKey,
    //             GlobalKeyConstants.profileReceivingKey,
    //             GlobalKeyConstants.profileTopUpKey,
    //             GlobalKeyConstants.profileCouponsKey,
    //             GlobalKeyConstants.profileFunKey,
    //             GlobalKeyConstants.profileSideKickKey,
    //             GlobalKeyConstants.profileBadgeKey,
    //             GlobalKeyConstants.profileFriendshipKey,
    //           ]));
    // }
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

  void scrollToCenter() {
    if (targetKey.currentContext == null) {
      return;
    }
    // 计算目标 Widget 的位置
    final RenderBox renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero,
        ancestor: Get.context!.findRenderObject());
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final widgetWidth = renderBox.size.width;

    // 计算滚动偏移量以将目标 Widget 滚动到屏幕中心
    final offset = position.dx - (screenWidth / 2 - widgetWidth / 2);

    scrollController.animateTo(
      offset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void jumpVipPage(int index) async {
    await Get.to(() => VipPage(), arguments: index);
    onRefresh();
  }

  String getShowTime() {
    if (user.value.avamins >= 60) {
      double hours = user.value.avamins / 60;
      if (hours == hours.truncate()) {
        // 如果是整数
        return '${hours.toInt()} h';
      } else {
        return '${hours.toStringAsFixed(2)} h';
      }
    } else {
      return '${user.value.avamins} min';
    }
  }

  double getProgress() {
    double percent = (user.value.totalmins.toDouble() == 0
        ? 0
        : user.value.avamins / user.value.totalmins.toDouble());
    progress = 234.w - 234.w * percent;
    if (progress > 234.w) {
      progress = 0;
    }
    return progress;
  }

  void jumpTaskDetail() async {
    showLoading();
    var response = await http
        .get('/app/client/task/task?id=${user.value.loyaltyModel.taskId}');
    dismissLoading();
    if (response.data != null) {
      TaskOutModel outModel = TaskOutModel.fromJson(response.data);
      if (outModel.tasks.isNotEmpty) {
        Get.to(() => TaskDetailPage(), arguments: {
          'model': outModel.tasks.first,
          'skipFlag': true,
        });
      }
    }
  }

  String getMembership() {
    int vipLevel = UserController.find.userProfile.vipLevel;
    String membershipName = "";
    switch (vipLevel) {
      case 5:
        membershipName = "Adventurer";
        break;
      case 10:
        membershipName = "Hero";
        break;
      case 15:
        membershipName = "Champion";
        break;
      case 15:
        membershipName = "Legend";
        break;
    }
    return membershipName;
  }

  void onRefresh() async {
    await userController.updateInfo();
    refreshController.refreshCompleted();
    user.value = UserController.find.userProfile;
  }

  @override
  void onClose() {
    super.onClose();

    refreshController.dispose();
  }
}
