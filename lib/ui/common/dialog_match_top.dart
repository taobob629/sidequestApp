import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/match_init_model.dart';

import '../../api/match_api.dart';
import '../../config/icon_font.dart';
import '../../image_utils.dart';
import '../../model/beans/JumpMatchSucBean.dart';
import '../../model/match/match_operation_model.dart';
import '../../model/match/match_order_player.dart';
import '../../utils/count_down_util.dart';

class MatchTopDialog extends StatelessWidget {
  var countTime = '10s'.obs;
  late CountDownUtil countDownUtil;
  late MatchOrderPlayer player;

  MatchTopDialog({required this.player}) {
    countDownUtil = CountDownUtil(
      (data) {
        countTime.value = data;
      },
      () {
        countDownUtil.stopCountDown();
        Get.back();
      },
      seconds: 10,
    );
    countDownUtil.startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 134.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageUtils.matchTopBg,
              ),
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.only(left: 20.w, right: 6.w),
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Container(
                height: 30.h,
                margin: EdgeInsets.only(left: 14.w, bottom: 10.h),
                child: Row(
                  children: [
                    Text(
                      'I want to play games with you'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Obx(
                      () => Text(
                        countTime.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        countDownUtil.stopCountDown();
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                    ),
                    6.horizontalSpace,
                  ],
                ),
              ),
              Container(
                height: 50.w,
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          player.avatar,
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              player.nickname,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 7.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFF351BD),
                                    Color(0xFFFF1549),
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  // 0男 1女 2未知
                                  Image.asset(
                                    player.sex == 0
                                        ? ImageUtils.iconSex0
                                        : ImageUtils.iconSex1,
                                    width: 5.w,
                                    height: 7.h,
                                  ),
                                  3.horizontalSpace,
                                  Text(
                                    '${player.age}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Text(
                              player.language,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            Container(
                              width: 1.w,
                              height: 8.h,
                              color: Color(0xffC1A3DB),
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                            ),
                            Text(
                              player.unit,
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => joinGame(1),
                      child: Container(
                        width: 70.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Color(0x70ffffff)),
                        margin: EdgeInsets.only(right: 10.w),
                        child: Center(
                          child: Text(
                            "Reject".tr,
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontFamily: FONT_MEDIUM,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => joinGame(0),
                      child: Container(
                        width: 70.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFD49C21),
                                  Color(0xFFE96524)
                                ])),
                        child: Center(
                          child: Text(
                            "Join".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: FONT_MEDIUM,
                                fontSize: 13.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void joinGame(int operation) async {
    EasyLoading.show();
    Map<String, dynamic> params = {"operation": operation};
    final result =
        await MatchApi.acceptMatchOrder(player.orderId.toString(), params);
    EasyLoading.dismiss();

    countDownUtil.stopCountDown();

    if (result != null && result.data != null) {
      MatchOperationModel model = MatchOperationModel.fromJson(result.data);

      JumpMatchSucBean bean = JumpMatchSucBean(
        orderId: model.orderId.toString(),
        avatar: model.avatar,
        nickname: model.nickname,
        sex: model.sex,
        age: model.age,
        stars: model.stars,
        levelNameEn: model.levelNameEn,
        tags: model.orderInfo.types,
        category: model.orderInfo.category,
        game: model.orderInfo.game,
        priceRange: '${model.orderInfo.minPrice}~${model.orderInfo.maxPrice}',
        unit: model.orderInfo.unit,
        launguage: model.orderInfo.language,

        skillAuthId: model.skillAuthId,
        liveuid: model.liveuid,
        serviceItemId: model.serviceItemId,
      );
      bean.ifPlayer = true;
      Get.offAndToNamed(
        AppPages.side_kick_match_suc_page,
        arguments: bean,
      );
    } else {
      Get.back();
    }
  }
}
