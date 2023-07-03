import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/icon_font.dart';
import '../../../model/service_list_model.dart';
import '../../../res/styles.dart';
import '../../../utils/image_util.dart';
import '../../model/gift_model.dart';
import '../../utils/time_utils.dart';
import 'my_gift_ctr.dart';
import 'my_gift_detail_page.dart';

class MyGiftPage extends StatelessWidget {
  final _ctr = Get.put(MyGiftCtr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Gift'.tr),
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
                            onTap: () =>
                                Get.to(() => MyGiftDetailPage(), arguments: {
                              'id': model.id,
                              'type': _ctr.ifScaleBigReceived.value ? 0 : 1,
                            }),
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

  Widget item(GiftListModel model) => innnerBg(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                '${TimeUtils.convertTime(model.createTime)}',
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
                  url: model.image,
                  border: 17.r,
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.cover),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${model.name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
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
                        Text(
                          '${model.price}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        //  Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                'X${model.nums}',
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
