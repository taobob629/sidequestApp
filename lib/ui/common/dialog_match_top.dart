import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/widget/home/index.dart';

import '../../api/match_api.dart';
import '../../config/icon_font.dart';
import '../../image_utils.dart';
import '../../model/beans/jump_match_suc_bean.dart';
import '../../model/match/match_operation_model.dart';
import '../../model/match/match_order_player.dart';
import '../../utils/count_down_util.dart';
import '../../utils/toast_utils.dart';

class MatchTopDialog extends StatelessWidget {
  final _ctr = Get.put(DialogMatchTopController());

  MatchTopDialog(Map map) {
    _ctr.initData(map);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DialogMatchTopController>(builder: (builder) {
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
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: MediaQuery.of(context).padding.top),
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
                            _ctr.countDownUtil.stopCountDown();
                          },
                          child: Text(
                            _ctr.countTime.value,
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
                          _ctr.countDownUtil.stopCountDown();
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
                          _ctr.player.avatar,
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
                                _ctr.player.nickname,
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ),
                              6.horizontalSpace,
                              SexAndAgeWidget(
                                sex: _ctr.player.sex,
                                age: _ctr.player.age,
                              ),
                            ],
                          ),
                          6.verticalSpace,
                          Row(
                            children: [
                              Text(
                                '${_ctr.player.game}',
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
                                '${_ctr.player.unit} x${_ctr.player.quantity}',
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
                    _ctr.player.requests,
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
    });
  }

  void joinGame(int operation) async {
    _ctr.countDownUtil.stopCountDown();

    showLoading();
    Map<String, dynamic> params = {"operation": operation};
    List<MatchOperationModel>? result =
        await MatchApi.acceptMatchOrder(_ctr.player.orderId.toString(), params);
    dismissLoading();

    if (result == null) {
      return;
    }

    List<JumpMatchSucBean> beans = [];
    result.forEach((element) {
      JumpMatchSucBean bean = JumpMatchSucBean(
        distance: element.distance,
        uid: element.orderInfo.uid,
        price: element.price,
        memberCode: element.memberCode,
        orderId: element.orderId.toString(),
        avatar: element.avatar,
        nickname: element.nickname,
        sex: element.sex,
        age: element.age,
        stars: element.stars,
        levelNameEn: element.levelNameEn,
        tags: element.orderInfo.types,
        category: element.orderInfo.category,
        game: element.orderInfo.game,
        priceRange:
            '${element.orderInfo.minPrice}~${element.orderInfo.maxPrice}',
        unit: element.orderInfo.unit,
        launguage: element.orderInfo.language,
        skillAuthId: element.skillAuthId,
        liveuid: element.liveuid,
        serviceItemId: element.serviceItemId,
      );

      beans.add(bean);
    });
    Get.toNamed(
      AppPages.side_kick_match_suc_page,
      arguments: beans,
    );
  }
}

class DialogMatchTopController extends GetxController {
  var countTime = '10s'.obs;
  late CountDownUtil countDownUtil;
  late MatchOrderPlayer player;

  void initData(map) {
    player = map['player'];

    countDownUtil = CountDownUtil(
      (data) {
        countTime.value = data;
      },
      () {
        countDownUtil.stopCountDown();
      },
      seconds: map['seconds'],
    );
    countDownUtil.startCountDown();
  }
}
