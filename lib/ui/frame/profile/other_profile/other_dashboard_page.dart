import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/ui/frame/profile/other_profile/badge_detail_widget.dart';
import 'package:wy/utils/global_key_constants.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_profile.dart';

import '../../../../event_bus/beans/badge_event.dart';
import '../../../../image_utils.dart';
import '../../game/game_home_page.dart';
import 'other_profile_page.dart';

class OtherDashboardPage extends StatelessWidget {
  const OtherDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = OtherProfileController.find;
    return Obx(() => ListView(
          padding: EdgeInsets.zero,
          children: [
            Visibility(
              visible: t.player.value.trophies.isNotEmpty,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            "Badge".tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 65,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        children: t.player.value.trophies
                            .map(
                              (e) => GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                // onTap: () => Get.dialog(BadgeDetailPage(t.player.value.trophies), name: "BadgeDetailPage"),
                                onTap: () => SmartDialog.show(
                                    builder: (builder) => BadgeDetailWidget(e),
                                    animationTime: Duration.zero,
                                    clickMaskDismiss: false,
                                    onMask: () {
                                      eventBus.fire(BadgeEvent());
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColor.itemBg,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageUtil.networkImage(
                                        url: e.iconLightImage,
                                        width: 36.w,
                                        height: 36.h,
                                      ),
                                      Text(e.iconName,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        "Services  ".tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontFamily: FONT_MEDIUM,
                        ),
                      )
                    ],
                  ),
                ),
                ...t.player.value.games
                    .map((game) => GestureDetector(
                          onTap: () => Get.to(() => GameHomePage(), arguments: {
                            "liveid": t.player.value.uid,
                            "skillId": game.serviceItem[0].skillid,
                            "gameId": game.id,
                            "avatar": t.player.value.avatar,
                            "nickName": t.player.value.nickName,
                            "sex": t.player.value.sex,
                            "age": t.player.value.age,
                            "uk": t.player.value.uk,
                            "price": game.serviceItem.first.price,
                            "unit": game.serviceItem.first.unit,
                          }),
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 16),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: AppColor.itemBg,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 12),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Stack(
                                            children: [
                                              ImageUtil.networkImage(
                                                url: game.thumb,
                                                width: 96.w,
                                                height: 90.h,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Visibility(
                                                  visible: game.isTech == 1,
                                                  child: Image.asset(ImageUtils.is_tech_pro_icon),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 90.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          game.name,
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FONT_MEDIUM,
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: game
                                                              .serviceItem
                                                              .isNotEmpty,
                                                          child: Container(
                                                            child: Text(
                                                              game.level
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: AppColor
                                                                    .textC3,
                                                                fontFamily:
                                                                    FONT_MEDIUM,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        10.verticalSpace,
                                                        if (game.serviceItem
                                                            .isNotEmpty) ...[
                                                          Row(
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                    'assets/images/ic_balance_money.webp'),
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                              3.horizontalSpace,
                                                              SizedBox(
                                                                // width: 150,
                                                                child: Text.rich(
                                                                    TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                        text:
                                                                            '${double.parse(game.serviceItem.first.price).floor()}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontFamily:
                                                                              FONT_MEDIUM,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            '/${game.serviceItem.first.unit}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              8.sp,
                                                                          fontFamily:
                                                                              FONT_MEDIUM,
                                                                        ),
                                                                      ),
                                                                    ])),
                                                              ),
                                                            ],
                                                          )
                                                        ]
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Visibility(
                                                        visible: game.gameVoice
                                                            .isNotEmpty,
                                                        maintainAnimation: true,
                                                        maintainState: true,
                                                        maintainSize: true,
                                                        child:
                                                            VoiceProfileWidget(
                                                          voice: game.gameVoice,
                                                          maginBottom: 0,
                                                          marginLeft: 12.w,
                                                          width: 70.w,
                                                          needEdit: false,
                                                        ),
                                                      ),
                                                      t.player.value.games
                                                                  .indexOf(
                                                                      game) ==
                                                              0
                                                          ? Column(
                                                              children: [
                                                                Showcase(
                                                                    key: GlobalKeyConstants
                                                                        .playKey,
                                                                    description:
                                                                        'Place an order and play the game together'
                                                                            .tr,
                                                                    targetBorderRadius:
                                                                        BorderRadius.circular(
                                                                            13),
                                                                    targetPadding:
                                                                        EdgeInsets.only(
                                                                            bottom:
                                                                                0),
                                                                    child:
                                                                        EditPlayBtn(
                                                                      isEdit: t
                                                                          .isSelf,
                                                                      onTap:
                                                                          () {
                                                                        if (game.serviceItem.length ==
                                                                            1) {
                                                                          t.editService(
                                                                              game,
                                                                              game.serviceItem.first,
                                                                              (game.serviceItem.length >= 1 && t.getItemDiscount(game.serviceItem[0].discount).isNotEmpty && jsonDecode(game.serviceItem[0].discount)['enable'] == 1) ? t.getItemDiscount(game.serviceItem[0].discount) : '');
                                                                        } else {
                                                                          game.ifShow.value = !game
                                                                              .ifShow
                                                                              .value;
                                                                        }
                                                                      },
                                                                    )),
                                                                13.verticalSpace,
                                                              ],
                                                            )
                                                          : EditPlayBtn(
                                                              isEdit: t.isSelf,
                                                              onTap: () {
                                                                if (game.serviceItem
                                                                        .length ==
                                                                    1) {
                                                                  t.editService(
                                                                      game,
                                                                      game.serviceItem
                                                                          .first,
                                                                      (game.serviceItem.length >= 1 &&
                                                                              t.getItemDiscount(game.serviceItem[0].discount).isNotEmpty &&
                                                                              jsonDecode(game.serviceItem[0].discount)['enable'] == 1)
                                                                          ? t.getItemDiscount(game.serviceItem[0].discount)
                                                                          : '');
                                                                } else {
                                                                  game.ifShow
                                                                          .value =
                                                                      !game
                                                                          .ifShow
                                                                          .value;
                                                                }
                                                              },
                                                            ).marginOnly(
                                                              bottom: 13.h)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (game.ifShow.value) ...[
                                      ...game.serviceItem.map((service) {
                                        return Container(
                                          height: 55.h,
                                          decoration: BoxDecoration(
                                            color: AppColor.itemBg,
                                          ),
                                          margin: EdgeInsets.only(
                                              top: service.enabled ? 10.h : 0),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 45.h,
                                                margin: EdgeInsets.only(
                                                  top: 10.h,
                                                  left: 10.w,
                                                  right: 10.w,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff2D2E3C),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(service.name,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              FONT_MEDIUM,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Spacer(),
                                                    Row(
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'assets/images/ic_balance_money.webp'),
                                                          width: 15,
                                                          height: 15,
                                                        ),
                                                        3.horizontalSpace,
                                                        Text.rich(
                                                            TextSpan(children: [
                                                          TextSpan(
                                                              text:
                                                                  '${double.parse(service.price).floor()}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontFamily:
                                                                      FONT_MEDIUM)),
                                                          TextSpan(
                                                              text:
                                                                  '/${service.unit}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      8.sp,
                                                                  fontFamily:
                                                                      FONT_MEDIUM)),
                                                        ])),
                                                        10.horizontalSpace,
                                                        GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onTap: () =>
                                                              t.editService(
                                                            game,
                                                            service,
                                                            ((t
                                                                        .getItemDiscount(service
                                                                            .discount)
                                                                        .isNotEmpty &&
                                                                    jsonDecode(service.discount)[
                                                                            'enable'] ==
                                                                        1))
                                                                ? t.getItemDiscount(
                                                                    service
                                                                        .discount)
                                                                : '',
                                                          ),
                                                          child: Container(
                                                            width: 28.w,
                                                            height: 28.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xff3F4050),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.w),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color:
                                                                  Colors.white,
                                                              size: 14.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (t
                                                      .getItemDiscount(
                                                          service.discount)
                                                      .isNotEmpty &&
                                                  jsonDecode(service.discount)[
                                                          'enable'] ==
                                                      1)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10.w),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffDA7A19),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15.r),
                                                      topRight:
                                                          Radius.circular(15.r),
                                                      bottomRight:
                                                          Radius.circular(15.r),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 4.h,
                                                  ),
                                                  child: Text(
                                                    t.getItemDiscount(
                                                        service.discount),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9.sp,
                                                      fontFamily: FONT_MEDIUM,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      })
                                    ],
                                    if (game.ifShow.value) 10.verticalSpace,
                                  ],
                                ),
                              ),
                              if (t.getDiscount(game.serviceItem) != '')
                                Transform.translate(
                                  offset: Offset(20, -5.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffDA7A19),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.r),
                                        topRight: Radius.circular(15.r),
                                        bottomRight: Radius.circular(15.r),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    child: Text(
                                      t.getDiscount(game.serviceItem),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                        fontFamily: FONT_MEDIUM,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ))
                    .toList()
              ],
            ),
          ],
        ));
  }
}

class EditPlayBtn extends StatelessWidget {
  EditPlayBtn({Key? key, this.isEdit = false, this.onTap}) : super(key: key);
  bool isEdit = false;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: 52,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColor.yellow,
        ),
        alignment: Alignment.center,
        child: Text(
          isEdit ? "EDIT" : "PLAY",
          style: TextStyle(
              fontSize: 12,
              color: AppColor.tabBackGround,
              fontWeight: FontWeight.bold,
              fontFamily: FONT_MEDIUM),
        ),
      ),
    );
  }
}
