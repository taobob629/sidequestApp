import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../model/profile_model.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../utils/storage_manager.dart';
import '../../../../utils/toast_utils.dart';
import '../../../consum/list/view.dart';
import '../../booking/booking_page.dart';
import '../../notification/notification_page.dart';
import '../../order/list/view.dart';
import '../../setting/settings_page.dart';
import '../balance/balance_page.dart';
import '../integral/integral_home_page.dart';
import '../qrcode/my_qr_code_page.dart';
import 'my_dashboard_page.dart';
import 'my_profile_page.dart';
import 'select_avatar_dialog.dart';

class MyProfilePageV2 extends StatelessWidget {
  MyProfilePageV2({Key? key}) : super(key: key);

  final ProfileController t =
      Get.isRegistered<ProfileController>()
          ? ProfileController.find
          : Get.put(ProfileController());
  final UserController userController = UserController.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ProfileV2Colors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 790;

            return ScrollConfiguration(
              behavior: const _NoScrollbarBehavior(),
              child: SmartRefresher(
                controller: t.refreshController,
                onRefresh: () => t.onRefresh(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    0,
                    16.w,
                    compact ? 14.h : 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _topBar(compact),
                      _identity(compact),
                      SizedBox(height: compact ? 8.h : 12.h),
                      _gamingBalance(compact),
                      SizedBox(height: compact ? 15.h : 18.h),
                      _sectionHeader(
                        title: 'My assets',
                        trailing: 'TAP TO MANAGE',
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 6.h : 8.h),
                      _assetsCard(compact),
                      SizedBox(height: compact ? 15.h : 18.h),
                      _sectionHeader(
                        title: 'Quick actions',
                        trailing: 'MY FEATURES',
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 4.h : 6.h),
                      _quickActions(compact),
                      SizedBox(height: compact ? 15.h : 18.h),
                      _loyaltyCard(compact),
                      if (Platform.isAndroid) ...[
                        SizedBox(height: compact ? 10.h : 14.h),
                        MyDashboardPage(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar(bool compact) {
    return SizedBox(
      height: compact ? 52.h : 58.h,
      child: Row(
        children: [
          Text(
            'PROFILE',
            style: TextStyle(
              color: _ProfileV2Colors.muted,
              fontSize: 11.sp,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const Spacer(),
          _settingsButton(),
          SizedBox(width: 10.w),
          _scanButton(),
        ],
      ),
    );
  }

  Widget _settingsButton() {
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap:
              () => Get.to(
                () => SettingsPage(),
                transition: Transition.noTransition,
              )?.then((value) => t.onRefresh()),
          child: Center(
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.055),
                border: Border.all(color: _ProfileV2Colors.outline),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                ImageUtils.profile_setting,
                width: 21.w,
                height: 21.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _scanButton() {
    return SizedBox(
      height: 48.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap:
              () => Get.to(
                () => MyQrCodePage(),
                transition: Transition.noTransition,
              ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.055),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: _ProfileV2Colors.outline),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              ImageUtils.scan_code_icon,
              width: 68.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _identity(bool compact) {
    final avatarSize = compact ? 64.w : 72.w;

    return Obx(() {
      final profile = userController.getRxuserProfile().value;
      final isLoggedIn =
          StorageManager.getToken().isNotEmpty && profile.memberId != 0;

      return Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openAvatar(profile, isLoggedIn),
            child: Container(
              width: avatarSize,
              height: avatarSize,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(compact ? 19.r : 22.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _ProfileV2Colors.lime,
                    _ProfileV2Colors.orange,
                    _ProfileV2Colors.coral,
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(compact ? 16.r : 19.r),
                child: Container(
                  color: _ProfileV2Colors.background,
                  padding: EdgeInsets.all(3.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(compact ? 13.r : 16.r),
                    child: _avatarImage(profile, isLoggedIn, avatarSize),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: compact ? 12.w : 16.w),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: t.goDev,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          isLoggedIn ? profile.nickName : 'LOGIN',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 23.sp : 27.sp,
                            fontFamily: FONT_BLACK,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                          ),
                        ),
                      ),
                      if (profile.vipLevel >= 5) ...[
                        SizedBox(width: 6.w),
                        Image.asset(
                          'assets/images/huizhang_${profile.vipLevel}.webp',
                          height: 20.w,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: compact ? 6.h : 9.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profile.uk,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _ProfileV2Colors.softText,
                            fontSize: 13.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      if (profile.lv != -1) ...[
                        SizedBox(width: 9.w),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6.r),
                            onTap:
                                () => Get.to(
                                  () => IntegralHomePage(),
                                  transition: Transition.noTransition,
                                )?.whenComplete(() => t.onRefresh()),
                            child: Container(
                              height: 20.h,
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _ProfileV2Colors.lime,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'LV.${profile.lv}',
                                style: TextStyle(
                                  color: const Color(0xFF211800),
                                  fontSize: 9.sp,
                                  fontFamily: FONT_BLACK,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _avatarImage(
    ProfileModel profile,
    bool isLoggedIn,
    double avatarSize,
  ) {
    if (!isLoggedIn || profile.avatar.isEmpty) {
      return Image.asset(
        ImageUtils.logo_icon,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
      );
    }

    return Opacity(
      opacity: profile.userAvatar == 1 ? 1 : 0.3,
      child: CachedNetworkImage(
        imageUrl: profile.avatar,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(color: _ProfileV2Colors.surfaceRaised),
        errorWidget:
            (context, url, error) =>
                Image.asset(ImageUtils.logo_icon, fit: BoxFit.cover),
      ),
    );
  }

  void _openAvatar(ProfileModel profile, bool isLoggedIn) {
    if (!isLoggedIn) {
      NavigatorHelper.gotoLoginPage();
      return;
    }

    showCustom(
      SelectAvatarDialog(),
      alignment: Alignment.bottomCenter,
      clickMaskDismiss: true,
    );
  }

  Widget _gamingBalance(bool compact) {
    return Obx(() {
      final profile = t.user.value;
      final progress =
          profile.totalmins == 0
              ? 0.0
              : (profile.avamins / profile.totalmins)
                  .clamp(0.0, 1.0)
                  .toDouble();

      return Container(
        height: compact ? 72.h : 78.h,
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: compact ? 8.h : 10.h,
        ),
        decoration: BoxDecoration(
          color: _ProfileV2Colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _ProfileV2Colors.lime.withOpacity(0.10)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -12.h,
              right: -12.w,
              child: Opacity(
                opacity: 0.25,
                child: Image.asset(
                  ImageUtils.emenry_bg_icon,
                  width: 128.w,
                  height: 84.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: compact ? 40.w : 44.w,
                  height: compact ? 40.w : 44.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _ProfileV2Colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Image.asset(
                    ImageUtils.emenry_pc_icon,
                    width: compact ? 35.w : 39.w,
                    height: compact ? 35.w : 39.w,
                  ),
                ),
                SizedBox(width: compact ? 10.w : 12.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gaming balance',
                        style: TextStyle(
                          color: _ProfileV2Colors.softText,
                          fontSize: 12.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: compact ? 7.h : 9.h),
                      _gradientProgress(progress),
                    ],
                  ),
                ),
                SizedBox(width: compact ? 10.w : 14.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.getShowTime(),
                      style: TextStyle(
                        color: _ProfileV2Colors.amber,
                        fontSize: compact ? 20.sp : 22.sp,
                        fontFamily: FONT_BLACK,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'REMAINING',
                      style: TextStyle(
                        color: _ProfileV2Colors.muted,
                        fontSize: 8.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _gradientProgress(double value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        height: 8.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.white.withOpacity(0.08)),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _ProfileV2Colors.orange,
                        _ProfileV2Colors.amber,
                        _ProfileV2Colors.lime,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String trailing,
    required bool compact,
  }) {
    return SizedBox(
      height: compact ? 22.h : 26.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 15.sp : 16.sp,
              fontFamily: FONT_BLACK,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          Text(
            trailing,
            style: TextStyle(
              color: _ProfileV2Colors.muted,
              fontSize: 9.sp,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetsCard(bool compact) {
    return Obx(() {
      final profile = t.user.value;

      return Container(
        height: compact ? 86.h : 94.h,
        decoration: BoxDecoration(
          color: _ProfileV2Colors.surface,
          borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
          border: Border.all(color: _ProfileV2Colors.outline),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: _assetItem(
                title: 'Credits'.tr,
                value: '£${profile.balance}',
                icon: ImageUtils.ic_corns_new2,
                color: _ProfileV2Colors.lime,
                compact: compact,
                onTap:
                    () => Get.to(
                      () => BalancePage(),
                      transition: Transition.noTransition,
                    )?.whenComplete(() => t.onRefresh()),
              ),
            ),
            _assetDivider(compact),
            Expanded(
              flex: 4,
              child: _assetItem(
                title: 'Vouchers'.tr,
                value: '${profile.coupons}',
                icon: ImageUtils.ic_coupons_new,
                color: _ProfileV2Colors.amber,
                compact: compact,
                onTap:
                    () => NavigatorHelper.gotoCouponPage(
                      couponType: 5,
                      whenComplete: () => t.onRefresh(),
                    ),
              ),
            ),
            _assetDivider(compact),
            Expanded(
              flex: 4,
              child: _assetItem(
                title: 'Points'.tr,
                value: '${profile.checkTotal}',
                icon: ImageUtils.ic_coupons_points,
                color: _ProfileV2Colors.coral,
                compact: compact,
                onTap:
                    () => Get.to(
                      () => IntegralHomePage(),
                      transition: Transition.noTransition,
                    )?.whenComplete(() => t.onRefresh()),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _assetDivider(bool compact) {
    return Container(
      width: 1,
      height: compact ? 66.h : 70.h,
      color: _ProfileV2Colors.outline,
    );
  }

  Widget _assetItem({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required bool compact,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 11.w : 14.w,
            compact ? 11.h : 14.h,
            8.w,
            compact ? 9.h : 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(icon, width: 15.w, height: 15.w),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 10.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 17.sp : 20.sp,
                  fontFamily: FONT_BLACK,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActions(bool compact) {
    final actions = <_ProfileAction>[
      _ProfileAction(
        title: 'Top Up'.tr,
        icon: ImageUtils.icon_wallet,
        onTap:
            () => userController.checkLogin(
              () => Get.to(
                () => BalancePage(),
                transition: Transition.noTransition,
              )?.whenComplete(() => t.onRefresh()),
            ),
      ),
      _ProfileAction(
        title: 'Vouchers'.tr,
        icon: ImageUtils.icon_vouchers,
        onTap:
            () => NavigatorHelper.gotoCouponPage(
              couponType: 5,
              whenComplete: () => t.onRefresh(),
            ),
      ),
      _ProfileAction(
        title: 'Orders'.tr,
        icon: ImageUtils.icon_orders,
        onTap:
            () => Get.to(
              () => OrderListPage(),
              transition: Transition.noTransition,
            ),
      ),
      _ProfileAction(
        title: 'Bookings'.tr,
        icon: ImageUtils.icon_bookings,
        onTap:
            () => Get.to(
              () => BookingPage(),
              transition: Transition.noTransition,
            ),
      ),
      _ProfileAction(
        title: 'Your Games'.tr,
        icon: ImageUtils.icon_consumption,
        onTap:
            () => Get.to(
              () => StoreConsumListPage(),
              transition: Transition.noTransition,
            ),
      ),
      _ProfileAction(
        title: 'Notifications'.tr,
        icon: ImageUtils.message_icon,
        showBadge: userController.showProfileBadge.value,
        onTap:
            () => Get.to(
              () => NotificationPage(),
              transition: Transition.noTransition,
            ),
      ),
    ];

    return Obx(() {
      actions.last.showBadge = userController.showProfileBadge.value;

      return Container(
        height: compact ? 150.h : 166.h,
        decoration: BoxDecoration(
          color: _ProfileV2Colors.surface,
          borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
          border: Border.all(color: _ProfileV2Colors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _quickActionColumn(actions[0], actions[3], compact),
            _quickActionDivider(compact),
            _quickActionColumn(actions[1], actions[4], compact),
            _quickActionDivider(compact),
            _quickActionColumn(actions[2], actions[5], compact),
          ],
        ),
      );
    });
  }

  Widget _quickActionColumn(
    _ProfileAction top,
    _ProfileAction bottom,
    bool compact,
  ) {
    return Expanded(
      child: Column(
        children: [
          Expanded(child: _quickActionItem(top, compact)),
          Expanded(child: _quickActionItem(bottom, compact)),
        ],
      ),
    );
  }

  Widget _quickActionDivider(bool compact) {
    return Container(
      width: 1,
      height: compact ? 126.h : 140.h,
      color: _ProfileV2Colors.outline,
    );
  }

  Widget _quickActionItem(_ProfileAction action, bool compact) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: compact ? 34.w : 38.w,
                  height: compact ? 34.w : 38.w,
                  child: Center(
                    child: Image.asset(
                      action.icon,
                      width: compact ? 25.w : 27.w,
                      height: compact ? 25.w : 27.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (action.showBadge)
                  Positioned(
                    top: -1.h,
                    right: -4.w,
                    child: Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5B4D),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 4.h : 7.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _ProfileV2Colors.softText,
                  fontSize: 11.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loyaltyCard(bool compact) {
    return Obx(() {
      final remaining = t.user.value.loyaltyModel.loyalty;
      final collected = (10 - remaining).clamp(0, 10).toInt();

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: t.jumpTaskDetail,
          child: Container(
            height: compact ? 160.h : 176.h,
            padding: EdgeInsets.all(compact ? 16.w : 18.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _ProfileV2Colors.amber.withOpacity(0.14),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF18191A),
                  Color(0xFF211B21),
                  Color(0xFF2A1D27),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: compact ? 5.h : 7.h,
                  right: -8.w,
                  child: Image.asset(
                    ImageUtils.profile_loyalty_icon,
                    width: compact ? 136.w : 148.w,
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 220.w,
                      child: Text(
                        'Loyalty Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 20.sp : 22.sp,
                          fontFamily: FONT_BLACK,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 6.h : 8.h),
                    SizedBox(
                      width: compact ? 210.w : 220.w,
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: 'Buy ',
                          style: TextStyle(
                            color: _ProfileV2Colors.softText,
                            fontSize: compact ? 11.sp : 12.sp,
                            fontFamily: FONT_MEDIUM,
                            height: 1.45,
                          ),
                          children: [
                            TextSpan(
                              text: '$remaining more ',
                              style: TextStyle(
                                color: _ProfileV2Colors.amber,
                                fontFamily: FONT_BLACK,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(
                              text: 'Bubble Teas to unlock a free drink.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    _loyaltyStamps(collected),
                    SizedBox(height: compact ? 5.h : 7.h),
                    Text(
                      '$collected of 10 collected',
                      style: TextStyle(
                        color: _ProfileV2Colors.muted,
                        fontSize: 8.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _loyaltyStamps(int collected) {
    return Row(
      children: List.generate(10, (index) {
        final completed = index < collected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 9 ? 0 : 4.w),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      completed ? _ProfileV2Colors.amber : Colors.transparent,
                  border:
                      completed
                          ? null
                          : Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.local_cafe_outlined,
                  size: 11.sp,
                  color:
                      completed
                          ? const Color(0xFF1B1608)
                          : const Color(0xFF656765),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ProfileAction {
  _ProfileAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  final String title;
  final String icon;
  final VoidCallback onTap;
  bool showBadge;
}

class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class _ProfileV2Colors {
  const _ProfileV2Colors._();

  static const background = Color(0xFF090909);
  static const surface = Color(0xFF151617);
  static const surfaceRaised = Color(0xFF1C1D1F);
  static const softText = Color(0xFFC9CAC4);
  static const muted = Color(0xFF979997);
  static const amber = Color(0xFFFFB20E);
  static const orange = Color(0xFFFF8E0E);
  static const lime = Color(0xFFD7E57F);
  static const coral = Color(0xFFED5A24);
  static const outline = Color(0x14FFFFFF);
}
