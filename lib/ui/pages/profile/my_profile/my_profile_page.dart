import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/addgame/add_game_account_page.dart';
import 'package:sq_hub_app/ui/pages/profile/qrcode/my_qr_code_page.dart';
import 'package:sq_hub_app/ui/pages/profile/my_profile/select_avatar_dialog.dart';
import 'package:sq_hub_app/ui/pages/profile/task/task_page.dart';
import 'package:sq_hub_app/ui/pages/profile/view/energy_view.dart';
import 'package:sq_hub_app/ui/pages/profile/vip/vip_page.dart';
import 'package:sq_hub_app/ui/pages/setting/settings_page.dart';

import '../../../../common/dialog_input.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../event_bus/beans/user_info_suc_bean.dart';
import '../../../../event_bus/event_bus.dart';
import '../../../../image_utils.dart';
import '../../../../model/profile_model.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../utils/storage_manager.dart';
import '../../../../utils/toast_utils.dart';
import '../../../../widget/linear_progressbar_widget.dart';
import '../../../../widget/my_progressbar.dart';
import '../../../consum/list/view.dart';
import '../../booking/booking_page.dart';
import '../balance/balance_page.dart';
import '../developer/developer_page.dart';
import '../events/my_events_page.dart';
import '../integral/integral_home_page.dart';
import '../invite/invite_page.dart';
import 'my_dashboard_page.dart';

class MyProfilePage extends StatelessWidget {
  MyProfilePage({Key? key}) : super(key: key);
  final t = Get.put(ProfileController());
  final userController = UserController.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColor('0A0A0A'),
      body: SingleChildScrollView(
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
                          onTap: () => Get.to(() => MyQrCodePage()),
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: ShapeDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: OvalBorder(),
                            ),
                            child: Image.asset(
                              ImageUtils.qr_code,
                              scale: 1.8,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => SettingsPage()),
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            margin: EdgeInsets.only(
                              right: 15.w,
                              left: 10.w,
                            ),
                            decoration: ShapeDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: OvalBorder(),
                            ),
                            child: Image.asset(
                              ImageUtils.profile_setting,
                              scale: 1.8,
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
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            clipBehavior: Clip.none,
                            children: [
                              Obx(() => Container(
                                    height: 64,
                                    alignment: Alignment.center,
                                    child: Opacity(
                                      opacity: userController
                                                  .userProfile.userAvatar ==
                                              1
                                          ? 1
                                          : 0.3,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              userController.userProfile.avatar,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
                              Image.asset(
                                ImageUtils.profile_avatar_border,
                                width: 64.w,
                              ),
                            ]),
                      ),
                      Expanded(
                        child: GestureDetector(
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
                                            userController.userProfile.nickName,
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
                                    6.horizontalSpace,
                                    6.horizontalSpace,
                                  ],
                                ),
                                6.verticalSpace,

                                /// labels: sex、language、location
                                Row(
                                  children: [
                                    Text(
                                      '${t.user.value.followers}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    6.horizontalSpace,
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Color(0xFF808388),
                                        fontSize: 12.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      width: 1.w,
                                      height: 14.h,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF727272)),
                                    ),
                                    Text(
                                      '${t.user.value.fans}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    6.horizontalSpace,
                                    Text(
                                      'Fans',
                                      style: TextStyle(
                                        color: Color(0xFF808388),
                                        fontSize: 12.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      width: 1.w,
                                      height: 14.h,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF727272)),
                                    ),
                                    Text(
                                      '${t.user.value.posts}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    6.horizontalSpace,
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                        color: Color(0xFF808388),
                                        fontSize: 12.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
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
              margin: EdgeInsets.only(left: 15, right: 15, top: 20).r,
              child: Column(
                children: [
                  Container(
                    height: 50.h,
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
                                width: 30.w,
                                height: 30.w,
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: Obx(() => MyProgressbar(
                                      value:
                                          t.user.value.totalmins.toDouble() == 0
                                              ? 0
                                              : t.user.value.avamins /
                                                  t.user.value.totalmins
                                                      .toDouble(),
                                      width: 234.w,
                                      height: 12.h,
                                      padding: EdgeInsets.only(
                                        right: 234.w -
                                            (t.user.value.totalmins
                                                            .toDouble() ==
                                                        0
                                                    ? 0
                                                    : t.user.value.avamins /
                                                        t.user.value.totalmins
                                                            .toDouble())
                                                .w,
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
                              Text(
                                '${t.user.value.avamins} min',
                                style: TextStyle(
                                  color: Color(0xFFFFCB0D),
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                vertical: 18.h,
              ),
              margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 10.h),
              decoration: ShapeDecoration(
                color: Color(0xFF141517),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_wallet,
                          "Wallet".tr,
                          onTap: () {
                            userController.checkLogin(() =>
                                Get.to(() => BalancePage())?.whenComplete(
                                    () => userController.updateInfo()));
                          },
                        ),
                      ),
                      // Expanded(
                      //   child: Showcase(
                      //     key: GlobalKeyConstants.profileSideKickKey,
                      //     description: 'Apply now to play with'.tr,
                      //     child: _dashboardLabelItem(
                      //       "assets/images/profile/icon_sidekick.webp",
                      //       "SideKick".tr,
                      //       onTap: () {
                      //         //  Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 0);
                      //         Get.toNamed(AppPages.SkillList)?.then(
                      //             (value) =>
                      //                 userController.updateInfo());
                      //       },
                      //       badgeNum: userController
                      //           .userProfile.sidekickNum,
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: _dashboardLabelItem(
                      //     ImageUtils.icon_order,
                      //     "Orders".tr,
                      //     onTap: () => Get.to(
                      //       () => MyOrdersPage(),
                      //     )?.then(
                      //         (value) => userController.updateInfo()),
                      //     badgeNum:
                      //         userController.userProfile.orderNum,
                      //   ),
                      // ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.share,
                          "Invite".tr,
                          onTap: () => Get.to(
                            () => InvitePage(),
                            arguments: "Invite".tr,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_bookings,
                          "Bookings".tr,
                          onTap: () {
                            Get.to(() => BookingPage());
                          },
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_activities,
                          "Activities".tr,
                          onTap: () {
                            Get.to(() => MyEventsPage());
                          },
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Expanded(
                      //   child: _dashboardLabelItem(
                      //     ImageUtils.icon_post,
                      //     "Post".tr,
                      //     onTap: () => Get.to(() => MyPostsPage())
                      //         ?.then((value) =>
                      //             userController.updateInfo()),
                      //     badgeNum:
                      //         userController.userProfile.postNum,
                      //   ),
                      // ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_task,
                          "Quest".tr,
                          onTap: () => Get.to(() => TaskPage())
                              ?.then((value) => userController.updateInfo()),
                          badgeNum: userController.userProfile.taskNum,
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_riot,
                          "Connections".tr,
                          onTap: () => Get.to(() => AddGameAccountPage()),
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_consumption,
                          "Consumption".tr,
                          onTap: () {
                            Get.to(() => StoreConsumListPage());
                          },
                        ),
                      ),
                      Expanded(
                        child: _dashboardLabelItem(
                          ImageUtils.icon_task,
                          "Integral".tr,
                          onTap: () => Get.to(() => IntegralHomePage()),
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
    );
  }

  Widget _memberVipWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15).r,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: LinearGradient(
          colors: [Color(0xff433B31), Color(0xff262731)],
        ),
      ),
      child: Swiper(
        itemCount: userController.userProfile.ads.length,
        itemBuilder: (c, i) => ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: ExtendedImage.network(
            userController.userProfile.ads[i].url,
            fit: BoxFit.fill,
          ),
        ),
        scrollDirection: Axis.vertical,
        autoplay: userController.userProfile.ads.length > 1 ? true : false,
        onTap: (index) => userController.userProfile.ads[index].link != null
            ? NavigatorHelper.gotoConfigTarget(
                userController.userProfile.ads[index].link!)
            : showError('link is null'.tr),
      ),
    );
  }

  Widget achievements() => Obx(() => Container(
        decoration: ShapeDecoration(
          color: Color(0xFF141517),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 15.h),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              children: [
                achievementItem(
                  '£${t.user.value.balance}',
                  ImageUtils.ic_corns_new2,
                  "Credits".tr,
                  'UK offline store top-up'.tr,
                  onTap: () {
                    if (StorageManager.getOnline())
                      Get.to(() => BalancePage())?.whenComplete(
                          () => UserController.instance().updateInfo());
                  },
                ),
                achievementItem(t.user.value.coupons, ImageUtils.ic_coupons_new,
                    "Vouchers".tr, 'Your Coupons'.tr, onTap: () {
                  NavigatorHelper.gotoCouponPage(
                    couponType: 5,
                    whenComplete: () => UserController.instance().updateInfo(),
                  );
                }),
                achievementItem(
                    t.user.value.checkTotal,
                    ImageUtils.ic_coupons_points,
                    "Points".tr,
                    'Your Coupons'.tr,
                    onTap: () => Get.to(() => IntegralHomePage())?.whenComplete(
                        () => UserController.instance().updateInfo())),
              ],
            ),
          ],
        ),
      ));

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
                    fontSize: 12.sp,
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
                  width: 26,
                ),
              ),
              6.verticalSpace,
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
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
  StreamSubscription? subscription;

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

    subscription = eventBus.on<UserInfoSucBean>().listen((event) {
      user.value = UserController.find.userProfile;
    });
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
    super.onClose();

    subscription?.cancel();
    subscription = null;
  }
}
