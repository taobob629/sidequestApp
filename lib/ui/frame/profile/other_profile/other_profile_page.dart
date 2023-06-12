import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';
import 'package:wy/ui/frame/social/post/view/gift_animation.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_profile.dart';
import 'package:wy/widget/profile/voice_widget.dart';

import '../../../../model/skill_model.dart';
import '../../../../utils/global_key_constants.dart';
import '../../../../widget/cs_Intimacy_progress.dart';
import '../../../../widget/route.dart';
import '../../../playwith/balance/my_earnings_page.dart';
import '../../../service/add/add_game_page.dart';
import '../../social/post/view/gift_suc_anim.dart';
import '../my_profile/badges_widget.dart';
import '../play_order/play_order_page.dart';
import 'other_album_page.dart';
import 'other_dashboard_page.dart';
import 'other_posts_page.dart';
import 'package:just_audio/just_audio.dart';

class PlayState {
  static const int idle = 0;
  static const int playing = 1;
  static const int loadding = 2;
}

class OtherProfilePage extends StatelessWidget {
  OtherProfilePage({Key? key}) : super(key: key);
  final t = Get.put(OtherProfileController());

  @override
  Widget build(BuildContext context) {
    final String text = t.player.value.signature.isNotEmpty
        ? t.player.value.signature
        : "Thank you for your attention and love";
    final TextStyle textStyle = TextStyle(
      fontSize: 13.sp,
      color: Color(0xFFC5C5C5),
      fontFamily: FONT_LIGHT,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 5,
    );

    // 必须要有这个maxWidth，不然就会只能是一行
    textPainter.layout(maxWidth: Get.width - 40);

    final expandedHeight = Platform.isAndroid
        ? t.isSelf
            ? textPainter.height + 90.h + 250.h
            : textPainter.height + 140.h + 250.h
        : t.isSelf
            ? textPainter.height + 60.h + 250.h
            : textPainter.height + 110.h + 250.h;

    return ShowCaseWidget(
        autoPlay: true,
        autoPlayDelay: Duration(seconds: 5),
        onFinish: () => StorageManager.setBoolValue('followKey', true),
        builder: Builder(builder: (builder) {
          t.myContext = builder;
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
                                style: TextStyle(
                                    fontSize: 19.sp, fontFamily: FONT_LIGHT),
                              ))),
                          centerTitle: true,
                          expandedHeight: expandedHeight,
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Container(
                              // color: Colors.lightBlue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200.h,
                                    width: double.infinity,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Obx(() => ImageUtil.networkImage(
                                              url: t.player.value.backGround,
                                              fit: BoxFit.cover,
                                            )),
                                        Container(
                                          color: Color(0xFF161616)
                                              .withOpacity(0.26),
                                        ),
                                        Positioned(
                                          left: 20,
                                          right: 0,
                                          height: 65.h,
                                          bottom: 12.5.h,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (!t.isSelf) {
                                                    UserController.find
                                                        .jumpChat(
                                                            t.player.value.uk);
                                                  }
                                                },
                                                child: Obx(() => Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    (65 / 2).r),
                                                      ),
                                                      child:
                                                          ExtendedImage.network(
                                                        t.player.value.avatar,
                                                        width: 65.h,
                                                        height: 65.h,
                                                        fit: BoxFit.cover,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )),
                                              ),
                                              8.horizontalSpace,
                                              Spacer(),
                                              Obx(() => Visibility(
                                                    visible: t.player.value
                                                        .voice.isNotEmpty,
                                                    child: Obx(() =>
                                                        VoiceProfileWidget(
                                                          pwId: UserController
                                                              .find
                                                              .userProfile
                                                              .pwId,
                                                          voice: t.player.value
                                                              .voice,
                                                          maginBottom: 0,
                                                          marginLeft: 12.w,
                                                          needEdit: t.isSelf,
                                                          width: t.isSelf
                                                              ? 98.w
                                                              : 80.w,
                                                          toRecordPage: () =>
                                                              t.toRecordPage(
                                                                  context),
                                                        )),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            left: 66.w,
                                            bottom: 16.h,
                                            child: Obx(() => Visibility(
                                                  visible:
                                                      t.player.value.follow,
                                                  child: Image.asset(
                                                    "assets/images/profile/followed.webp",
                                                    width: 26.w,
                                                    height: 26.w,
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: !t.isSelf,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => SmartDialog.show(
                                        builder: (builder) => GiftSucAnim(
                                            '{maxIntimacy: ${t.player.value.maxIntimacy}, currentIntimacy: ${t.player.value.currentIntimacy}, intimacyLevel: ${t.player.value.intimacyLevel}, avatar: ${t.player.value.avatar}'),
                                        displayTime: Duration(seconds: 2),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 14, right: 14, top: 15),
                                        child: CsIntimacyProgress(
                                          firstAvatar: t.player.value.avatar,
                                          secondAvatar: UserController
                                              .find.userProfile.avatar,
                                          lv: t.player.value.intimacyLevel,
                                          currentIntimacy:
                                              t.player.value.currentIntimacy,
                                          maxIntimacy:
                                              t.player.value.maxIntimacy,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, top: 15),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  /// nickname
                                                  Obx(() => Container(
                                                        height: 24.h,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          240),
                                                              height: 24.h,
                                                              child: Text(
                                                                t.player.value
                                                                    .nickName,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      19.sp,
                                                                  fontFamily:
                                                                      FONT_MEDIUM,
                                                                ),
                                                              ),
                                                            ),
                                                            12.horizontalSpace,
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              height: 16.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              3),
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment
                                                                              .centerLeft,
                                                                          end: Alignment
                                                                              .centerRight,
                                                                          colors: [
                                                                            if (t.player.value.sex ==
                                                                                0) ...[
                                                                              Color(0xFF1F84C9),
                                                                              Color(0xFF7CB9D5),
                                                                            ] else if (t.player.value.sex ==
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
                                                                  if (t
                                                                          .player
                                                                          .value
                                                                          .sex !=
                                                                      2)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              3),
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/profile/icon_sex_${t.player.value.sex}.png",
                                                                        width:
                                                                            8,
                                                                      ),
                                                                    )
                                                                  else
                                                                    Text(
                                                                      "?",
                                                                      style: TextStyle(
                                                                          fontSize: 10
                                                                              .sp,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  Text(
                                                                    "${t.player.value.age}",
                                                                    style: TextStyle(
                                                                        fontSize: 10
                                                                            .sp,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            7.horizontalSpace,
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              height: 19.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(10
                                                                              .r),
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment
                                                                              .centerLeft,
                                                                          end: Alignment
                                                                              .centerRight,
                                                                          colors: [
                                                                            Color(0xFF9A6FE9),
                                                                            Color(0xFF8050E5),
                                                                          ])),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5),
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/profile/icon_level_${(t.player.value.userLevel ~/ 5) * 5}.webp",
                                                                      width:
                                                                          12.w,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${t.player.value.userLevel}",
                                                                    style: TextStyle(
                                                                        fontSize: 11
                                                                            .sp,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // Visibility(
                                                            //   visible: !t.isSelf,
                                                            //   child: GestureDetector(
                                                            //     onTapDown: (details) {
                                                            //       t.followOrNot(context, details.globalPosition);
                                                            //     },
                                                            //     child: Container(
                                                            //       height: 30,
                                                            //       padding: const EdgeInsets.only(left: 10),
                                                            //       child: Image.asset(
                                                            //         t.player.value.follow ? "assets/images/profile/followed.webp" : "assets/images/profile/follow.webp",
                                                            //         width: 20,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                      )),

                                                  /// labels: sex、language、location
                                                  Obx(() => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Visibility(
                                                              visible: t
                                                                  .player
                                                                  .value
                                                                  .location
                                                                  .country
                                                                  .isNotEmpty,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/profile/icon_dibiao.webp",
                                                                    width: 8.w,
                                                                  ),
                                                                  4.horizontalSpace,
                                                                  Container(
                                                                    constraints:
                                                                        BoxConstraints(
                                                                            maxWidth:
                                                                                120.w),
                                                                    child: Text(
                                                                      '${t.player.value.location.country}',
                                                                      strutStyle:
                                                                          StrutStyle(
                                                                              forceStrutHeight: true),
                                                                      maxLines:
                                                                          1,
                                                                      softWrap:
                                                                          false,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontFamily:
                                                                            FONT_MEDIUM,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: t
                                                                  .player
                                                                  .value
                                                                  .language
                                                                  .isNotEmpty,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 15
                                                                            .w),
                                                                height: 16.h,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/profile/icon_language.webp",
                                                                      width:
                                                                          11.w,
                                                                    ),
                                                                    2.horizontalSpace,
                                                                    Text(
                                                                      t
                                                                          .player
                                                                          .value
                                                                          .language,
                                                                      strutStyle:
                                                                          StrutStyle(
                                                                              forceStrutHeight: true),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontFamily:
                                                                            FONT_MEDIUM,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            15.horizontalSpace,
                                                            Text(
                                                              "ID:" +
                                                                  t.player.value
                                                                      .uk,
                                                              strutStyle:
                                                                  StrutStyle(
                                                                      forceStrutHeight:
                                                                          true),
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    FONT_MEDIUM,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTapDown: (details) {
                                      print(details.globalPosition);
                                      Offset offset = details.globalPosition;
                                      Get.dialog(Stack(
                                        alignment:
                                            AlignmentDirectional.topCenter,
                                        children: [
                                          Positioned(
                                            top: offset.dy -
                                                MediaQuery.of(Get.context!)
                                                    .padding
                                                    .top +
                                                15,
                                            left: offset.dx - 10,
                                            child: ClipPath(
                                              clipper: Triangle(dir: -1),
                                              child: Container(
                                                width: 20.0,
                                                height: 10.0,
                                                color: Color(0xff282640),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: offset.dy -
                                                MediaQuery.of(Get.context!)
                                                    .padding
                                                    .top +
                                                15 +
                                                10,
                                            child: Container(
                                              width: Get.width - 30.w,
                                              padding: EdgeInsets.all(10.r),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff282640),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                              child: Text(
                                                t.player.value.signature,
                                                style: TextStyle(
                                                  color: Color(0xff8291B4),
                                                  height: 1.2,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 10.h,
                                          top: 10.h),
                                      child: Text(
                                        text,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Container(
                                      height: 43.h,
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: BorderSide(
                                            color: AppColor.itemBg, width: 1),
                                        bottom: BorderSide(
                                            color: AppColor.itemBg, width: 1),
                                      )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Followings".tr +
                                                ": ${t.player.value.followers}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          ),
                                          Text(
                                            "Followers".tr +
                                                ": ${t.player.value.fans}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          ),
                                          Visibility(
                                            child: Text(
                                              "Rating".tr +
                                                  ": ${t.player.value.ranking}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontFamily: FONT_MEDIUM,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Orders".tr +
                                                ": ${t.player.value.age}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          bottom: PreferredSize(
                              preferredSize: Size(double.infinity, 40.h),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 30, right: 20),
                                  child: TabBar(
                                    padding: EdgeInsets.zero,
                                    controller: t.tabController,
                                    isScrollable: false,
                                    labelColor: Color(0xFFFFCB0D),
                                    unselectedLabelColor: AppColor.textC5C5,
                                    indicatorColor: Color(0xFFFFCB0D),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorWeight: 2,
                                    indicatorPadding:
                                        EdgeInsets.only(bottom: 5),
                                    labelPadding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 8),
                                    labelStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                    tabs: createTabs(),
                                  ),
                                ),
                              )),
                        ),
                      ];
                    },
                    body: TabBarView(
                        controller: t.tabController, children: createPages())),
                if (!t.isSelf)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 42.h + Get.mediaQuery.padding.bottom + 20,
                      child: Visibility(
                        visible: !t.isSelf && !t.player.value.follow,
                        child: Container(
                          color: AppColor.itemBg,
                          child: Row(
                            children: [
                              15.horizontalSpace,
                              Showcase(
                                key: GlobalKeyConstants.followKey,
                                description:
                                    'Click Follow to receive notifications about playing with you'
                                        .tr,
                                targetBorderRadius: BorderRadius.circular(21.r),
                                targetShapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: GestureDetector(
                                  onTapDown: (details) {
                                    t.followOrNot(
                                        context, details.globalPosition);
                                  },
                                  child: Container(
                                    width: 110.w,
                                    height: 42.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: t.player.value.follow
                                          ? null
                                          : Border.all(color: AppColor.yellow),
                                      gradient: t.player.value.follow
                                          ? LinearGradient(
                                              colors: AppColor.yellowGradient)
                                          : null,
                                      borderRadius: BorderRadius.circular(21.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: Image.asset(
                                            "assets/images/profile/follow.webp",
                                            width: 16,
                                            // color: AppColor.accent,
                                            // color: t.player.value.follow ? AppColor.accent : AppColor.yellow,
                                          ),
                                        ),
                                        Text(
                                          "Follow".tr,
                                          style: TextStyle(
                                              color: AppColor.yellow,
                                              fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    t.jumpChat(t.player.value.uk);
                                  },
                                  child: Visibility(
                                    child: Container(
                                      height: 42.h,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: AppColor.yellowGradient),
                                        borderRadius:
                                            BorderRadius.circular(21.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Image.asset(
                                              "assets/images/profile/icon_pinlun.webp",
                                              width: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Messages".tr,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
              ],
            ),
          );
        }));
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    if (t.player.value.isAuth)
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
    if (t.player.value.isAuth) pages.add(OtherDashboardPage());
    pages.add(OtherPostsPage());
    pages.add(OtherAlbumPage());
    return pages;
  }
}

class OtherProfileController extends BasePageController {
  static OtherProfileController get find => Get.find();
  BuildContext? myContext;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioManager audioManager = AudioManager.instance;
  late TabController tabController;

  // final vm = ProfileModel().obs;
  final showTitle = false.obs;

  final player = PlayerInfoModel().obs;

  ScrollController scrollController = ScrollController();

  double limitedHeight = 88 + Get.mediaQuery.padding.top;

  bool isSelf = false;

  @override
  void onInit() {
    // initPlayer();
    player.value = Get.arguments;

    if (player.value.isAuth) {
      tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    } else {
      tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    }
    isSelf = UserController.find.userProfile.pwId == player.value.uid;

    scrollController.addListener(() {
      showTitle.value = scrollController.offset >= limitedHeight;
    });

    bool? followKey = StorageManager.getBoolByKey('followKey');
    if (followKey == null || followKey == false) {
      if (!isSelf && !player.value.follow) {
        ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
          (_) => ShowCaseWidget.of(myContext!).startShowCase([
            GlobalKeyConstants.followKey,
            GlobalKeyConstants.playKey,
          ]),
        );
      } else {
        ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
          (_) => ShowCaseWidget.of(myContext!).startShowCase([
            GlobalKeyConstants.playKey,
          ]),
        );
      }
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // getProfileInfo();
  }

  // getProfileInfo() {
  //   ProfileApi.getPlayerInfo(playerId: player.value.uid).then((value) {
  //     player.value = value..uid = player.value.uid;
  //   });
  // }

  followOrNot(context, offset) {
    if (isSelf) {
      return;
    }
    UserApi.attention(player.value.uid).then((value) {
      player.value.follow = !player.value.follow;
      if (player.value.follow) {
        player.value.fans += 1;
        showHearts(context, offset, "");
      } else {
        player.value.fans -= 1;
      }
      player.refresh();
    }).catchError((e) {
      print(e);
    });
  }

  editService(GamesItem game, ServiceItem serviceItem, String discount) async {
    if (isSelf) {
      // Get.toNamed(AppPages.ServiceAndOrders);
      List<SkillModel> list = await UserApi.myauthlist();
      Iterable<SkillModel> skillModel =
          list.where((element) => element.id == game.id);
      jumpPage(AddGamePage(skillModel.first.toJson()), callback: (res) {
        flog('Get.ard ${Get.arguments}');
      });
    } else {
      var uk = await Get.to(() {
        return MulitablePlayOrderPage(
          serviceItemList: [serviceItem],
          discount: discount,
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
    super.onClose();
    AudioManager.instance.stop();
    // stop();
  }

  // void initPlayer() {
  //   audioPlayer.playerStateStream.listen((state) {
  //     flog('playerStateStream $state');
  //     if (state.playing) {
  //       playState = PlayState.playing;
  //     }
  //     switch (state.processingState) {
  //       case ProcessingState.idle:
  //         playState = PlayState.idle;
  //         break;
  //       case ProcessingState.loading:
  //         playState = PlayState.loadding;
  //         break;
  //       case ProcessingState.buffering:
  //         break;
  //       case ProcessingState.ready:
  //         break;
  //       case ProcessingState.completed:
  //         stop();
  //         break;
  //     }
  //   });
  // }

  // RxInt _playState = RxInt(PlayState.idle);
  //
  // int get playState => _playState.value;
  //
  // set playState(int value) {
  //   _playState.value = value;
  // }

  // Future<void> play() async {
  //   if (audioPlayer?.playing == true) {
  //     await audioPlayer.stop();
  //     return;
  //   }
  //   var url = OtherProfileController.find.player.value.voice;
  //   if (url.isEmpty) err('No Voice'.tr);
  //   final duration = await audioPlayer?.setUrl(url); // Schemes: (https: | file: | asset: )
  //   audioPlayer.play();
  // }
  toRecordPage(BuildContext context) {
    pickVoiceDialog(context, player.value.voice, (result) {
      flog('callback $result');
      if (result != null) player.value.voice = result;
    });
    // Get.toNamed(AppPages.Record,arguments: player.value.voice)?.then((result) {
    //   if (result != null) player.value.voice = result;
    // });
  }

  String getDiscount(List<ServiceItem> serviceItem) {
    String discount = '';
    for (int i = 0; i < serviceItem.length; i++) {
      if (serviceItem[i].discount != '' &&
          jsonDecode(serviceItem[i].discount)['enable'] == 1) {
        discount = serviceItem[i].discount;
        break;
      }
    }

    if (discount.contains('type')) {
      dynamic result = jsonDecode(discount);
      int type = result['type'];
      if (type == 1) {
        return 'Discount ${result['discount']}% OFF';
      } else if (type == 2) {
        return 'Buy ${result['buy']} Get ${result['get']}';
      } else if (type == 3) {
        return '1st Order Free ${result['discount']}% OFF';
      }
    }

    return discount;
  }

  String getItemDiscount(String discount) {
    if (discount.isEmpty) {
      return discount;
    }
    dynamic result = jsonDecode(discount);
    int type = result['type'];
    if (type == 1) {
      return 'Discount ${result['discount']}% OFF';
    } else if (type == 2) {
      return 'Buy ${result['buy']} Get ${result['get']}';
    } else if (type == 3) {
      return '1st Order Free ${result['discount']}% OFF';
    }
    return discount;
  }

// stop() async {
//   playState=PlayState.idle;
//   if(audioPlayer?.playing == true)
//   await audioPlayer?.stop();
// }
}
