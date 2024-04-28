import 'package:badges/badges.dart' as badges;
import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/controller/user_controller.dart';
import 'package:sq_hub_app/model/profile_model.dart';
import 'package:sq_hub_app/ui/pages/booking/booking_page.dart';
import 'package:sq_hub_app/ui/pages/profile/qrcode/my_qr_code_page.dart';
import 'package:sq_hub_app/ui/pages/profile/select_avatar_dialog.dart';
import 'package:sq_hub_app/ui/pages/profile/task/task_page.dart';
import 'package:sq_hub_app/ui/pages/profile/view/energy_view.dart';
import 'package:sq_hub_app/utils/navigator_helper.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../image_utils.dart';
import '../setting/settings_page.dart';
import 'balance/balance_page.dart';
import 'my_dashboard_page.dart';

class MyProfilePage extends StatelessWidget {
  MyProfilePage({Key? key}) : super(key: key);
  final t = Get.put(ProfileController());
  final userController = UserController.find;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 1.sh,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              ImageUtils.profile_top_bg,
              fit: BoxFit.fill,
              height: 0.4.sh,
            ),
            Column(
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
                                            child: ExtendedImage.network(
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
                                    width: 64,
                                  ),
                                ]),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// nickname
                                    Row(
                                      children: [
                                        Obx(() => Text(
                                              userController
                                                  .userProfile.nickName,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        6.horizontalSpace,
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
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
                                                            .userProfile
                                                            .gender ==
                                                        0) ...[
                                                      Color(0xFF1F84C9),
                                                      Color(0xFF7CB9D5),
                                                    ] else if (userController
                                                            .userProfile
                                                            .gender ==
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3),
                                                  child: Image.asset(
                                                    "assets/images/icon_sex_${userController.userProfile.gender}.png",
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
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    6.verticalSpace,

                                    /// labels: sex、language、location
                                    Obx(() => Row(
                                          children: [
                                            Text(
                                              "ID:${userController.userProfile.uk}",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                                fontFamily: FONT_MEDIUM,
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: Text(
                                                userController
                                                    .userProfile.email,
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                  fontFamily: FONT_MEDIUM,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          15.horizontalSpace,
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
                        height: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF413A62),
                              Color(0xFF591E3A),
                              Color(0xFF413A62),
                            ],
                          ),
                        ),
                        child: Obx(() => EnergyView(
                              width: 1.sw - 60.w,
                              percent: UserController.find.userProfile.totalmins
                                          .toDouble() ==
                                      0
                                  ? 0
                                  : UserController.find.userProfile.avamins /
                                      UserController.find.userProfile.totalmins
                                          .toDouble(),
                              remaining:
                                  UserController.find.userProfile.avamins,
                            )),
                      ),
                      achievements(),
                    ],
                  ),
                ),
                Obx(() => Visibility(
                      visible: userController.userProfile.ads.isNotEmpty,
                      child: _memberVipWidget(),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    left: 15.w,
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 16.h,
                        margin: EdgeInsets.only(right: 4.w),
                        color: hexColor('FFB20E'),
                      ),
                      Text(
                        'MY SERVICES'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 18.h,
                  ),
                  margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff262731),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      _dashboardLabelItem(
                        ImageUtils.icon_wallet,
                        "Wallet".tr,
                        onTap: () {
                          userController.checkLogin(() =>
                              Get.to(() => BalancePage())?.whenComplete(
                                  () => userController.updateInfo()));
                        },
                      ),
                      20.horizontalSpace,
                      _dashboardLabelItem(
                        ImageUtils.icon_bookings,
                        "Bookings".tr,
                        onTap: () {
                          Get.to(() => BookingPage());
                        },
                      ),
                    ],
                  ),
                ),
                MyDashboardPage(),
              ],
            ),
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

  Widget remainingTimes() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Remaining game time: '.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xFFC5C5C5),
                  fontFamily: FONT_MEDIUM)),
          Obx(() => Text('${UserController.find.userProfile.avamins}mins',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.textYellow,
                  fontFamily: FONT_MEDIUM)))
        ],
      );

  Widget contentPadding(Widget child, {var top, var bootom}) => Container(
        margin: EdgeInsets.all(15).r,
        padding: EdgeInsets.all(15).r,
        decoration: BoxDecoration(
          color: Color.fromRGBO(40, 37, 60, 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            remainingTimes(),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.symmetric(vertical: 15.h),
            ),
            child,
          ],
        ),
      );

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

  Widget achievements() => Container(
        height: 70.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF2D2923),
              Color(0xFF262731),
            ],
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          children: [
            Obx(() => achievementItem(
                  '£${UserController.find.userProfile.balance}',
                  ImageUtils.ic_corns_new,
                  "Credits\n".tr,
                  'UK offline store top-up'.tr,
                  onTap: () => Get.to(() => BalancePage())?.whenComplete(
                      () => UserController.instance().updateInfo()),
                )),
            Obx(() => achievementItem(
                  UserController.find.userProfile.coupons,
                  ImageUtils.ic_coupons_new,
                  "Vouchers\n".tr,
                  'Your Coupons'.tr,
                  onTap: () {
                    NavigatorHelper.gotoCouponPage(
                      couponType: 5,
                      whenComplete: () =>
                          UserController.instance().updateInfo(),
                    );
                  },
                )),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 36.w,
              height: 36.w,
            ),
            8.horizontalSpace,
            RichText(
              text: TextSpan(
                text: iconText,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: FONT_LIGHT,
                  fontSize: 11.sp,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: "$text",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: FONT_MEDIUM,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
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
          alignment: Alignment.centerLeft,
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
  }
}
