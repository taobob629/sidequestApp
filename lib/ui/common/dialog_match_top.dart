import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/widget/home/index.dart';

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
          height: 150.h,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30.h,
                margin: EdgeInsets.only(left: 14.w, bottom: 10.h),
                child: Row(
                  children: [
                    Text(
                      'I want to invite you to play the games'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Obx(
                      () => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          countDownUtil.stopCountDown();
                          Get.back();
                        },
                        child: Text(
                          countTime.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
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
              Row(
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
                  Expanded(
                    child: Column(
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
                            6.horizontalSpace,
                            SexAndAgeWidget(
                              sex: player.sex,
                              age: player.age,
                            ),
                          ],
                        ),
                        6.verticalSpace,
                        Row(
                          children: [
                            Text(
                              '${player.game}',
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Text(
                              '${player.unit} x${player.quantity}',
                              style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            6.horizontalSpace,
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 56.w),
                child: Text(
                  player.requests,
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Spacer(),
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
        distance: model.distance,
        uid: model.orderInfo.uid,
        price: model.price,
        memberCode: model.memberCode,
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

      List<JumpMatchSucBean> beans = [];
      beans.add(bean);
      Get.offAndToNamed(
        AppPages.side_kick_match_suc_page,
        arguments: beans,
      );
      return;
    }
    Get.back();
  }
}
