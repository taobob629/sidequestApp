import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../model/service_list_model.dart';
import '../../../res/styles.dart';
import '../../../utils/image_util.dart';
import 'my_orders_ctr.dart';

class MyOrdersPage extends StatelessWidget {
  final _ctr = Get.put(MyOrdersCtr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'.tr),
      ),
      body: Obx(() => Column(
            children: [
              Row(
                children: [
                  20.horizontalSpace,
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _ctr.ifScaleBigReceived.value = true;
                      _ctr.onRefresh();
                    },
                    child: Column(
                      children: [
                        Transform.scale(
                          scale: _ctr.ifScaleBigReceived.value ? 1.1 : 0.8,
                          child: Column(
                            children: [
                              Text(
                                'Received'.tr,
                                style: TextStyle(
                                  color: _ctr.ifScaleBigReceived.value
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: _ctr.ifScaleBigReceived.value
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 22.sp,
                                ),
                              ),
                              4.verticalSpace,
                              if (_ctr.ifScaleBigReceived.value)
                                Container(
                                  width: 14.w,
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.horizontalSpace,
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _ctr.ifScaleBigReceived.value = false;
                      _ctr.onRefresh();
                    },
                    child: Column(
                      children: [
                        Transform.scale(
                          scale: !_ctr.ifScaleBigReceived.value ? 1.1 : 0.8,
                          child: Column(
                            children: [
                              Text(
                                'Provided'.tr,
                                style: TextStyle(
                                  color: !_ctr.ifScaleBigReceived.value
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: !_ctr.ifScaleBigReceived.value
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 22.sp,
                                ),
                              ),
                              4.verticalSpace,
                              if (!_ctr.ifScaleBigReceived.value)
                                Container(
                                  width: 14.w,
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _ctr.ifSelectCompleted.value = true;
                      _ctr.onRefresh();
                    },
                    child: Container(
                      height: 30.h,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      margin: EdgeInsets.only(left: 15.w, right: 15.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23).r,
                          gradient: _ctr.ifSelectCompleted.value
                              ? LinearGradient(colors: [
                                  Color(0xFF612AD7),
                                  Color(0xFFBE39CC),
                                  Color(0xFFE68887),
                                ])
                              : LinearGradient(colors: [
                                  AppColor.tabBackGround,
                                  AppColor.tabBackGround
                                ])),
                      alignment: Alignment.center,
                      child: Text(
                        'Completed'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _ctr.ifSelectCompleted.value = false;
                      _ctr.onRefresh();
                    },
                    child: Container(
                      height: 30.h,
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23).r,
                          gradient: !_ctr.ifSelectCompleted.value
                              ? LinearGradient(colors: [
                                  Color(0xFF612AD7),
                                  Color(0xFFBE39CC),
                                  Color(0xFFE68887),
                                ])
                              : LinearGradient(colors: [
                                  AppColor.tabBackGround,
                                  AppColor.tabBackGround
                                ])),
                      alignment: Alignment.center,
                      child: Text(
                        'Others'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
              Expanded(
                child: SmartRefresher(
                    controller: _ctr.refreshController,
                    onLoading: () => _ctr.loadMore(),
                    onRefresh: () => _ctr.onRefresh(),
                    enablePullUp: true,
                    enablePullDown: true,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var model = _ctr.list[index];
                        return Container(
                          width: Get.width,
                          child: InkWell(
                            child: item(model),
                          ),
                        );
                      },
                      itemCount: _ctr.list.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        color: Colors.transparent,
                        height: 15.h,
                      ),
                    )),
              ),
            ],
          )),
    );
  }

  Widget innnerBg(Widget view) => Container(
        margin: EdgeInsets.only(left: 15, right: 15).r,
        padding: itemPadding10,
        decoration: itemDecoration(color: Color(0xFF262731), radius: 17.r),
        child: view,
      );

  Widget item(ServiceListModel model) => innnerBg(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(), color: model.statusColor())),
              10.horizontalSpace,
              Text(
                '${orderStatusMap[model.status]}',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: FONT_MEDIUM,
                    fontSize: 13.sp),
              ),
              Spacer(),
              Text(
                '${model.time}',
                style: TextStyle(color: Color(0xFFB2B9C9), fontSize: 11.sp),
              )
            ],
          ),
          10.verticalSpace,
          listDivider,
          10.verticalSpace,
          Row(
            children: [
              ImageUtil.networkImage(
                  url: model.icon,
                  border: 17.r,
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.cover),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${model.gameName}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM),
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Image(
                        image:
                            AssetImage('assets/images/ic_balance_money.webp'),
                        width: 15,
                        height: 15,
                      ),
                      3.horizontalSpace,
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: '${model?.price}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM)),
                        TextSpan(
                            text: '/${model.unit}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM)),
                      ])),
                      //  Spacer(),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Text(
                'X${model.amount}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM),
              )
            ],
          )
        ],
      ));
}
