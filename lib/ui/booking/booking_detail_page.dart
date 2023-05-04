import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/utils/image_util.dart';

import '../../config/app_color.dart';
import '../../config/icon_font.dart';
import '../common/colorful_button.dart';
import 'booking_detail_ctr.dart';
import 'booking_dialog.dart';

class BookingDetailPage extends StatelessWidget {
  final _ctr = Get.put(BookingDetailCtr());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailCtr>(
        builder: (builder) => Scaffold(
              backgroundColor: AppColor.background,
              appBar: AppBar(
                backgroundColor: AppColor.background,
                elevation: 0,
                title: Text(
                  _ctr.model?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      28.verticalSpace,
                      ImageUtil.networkImage(
                        url: _ctr.model?.headImage ?? '',
                        height: 180.h,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                      15.verticalSpace,
                      Text(
                        _ctr.model?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      12.verticalSpace,
                      Text(
                        _ctr.model?.address ?? '',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: FONT_MEDIUM,
                            color: Colors.white,
                            height: 1.5),
                      ),
                      15.verticalSpace,
                      Row(
                        children: [
                          Text(
                            'In business'.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM,
                              color: Color(0xffFFD20E),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => _ctr.jumpPhoneOrMap(true),
                            child: Image.asset(
                              ImageUtils.icon_phone,
                              width: 38.w,
                              height: 38.w,
                            ),
                          ),
                          15.horizontalSpace,
                          GestureDetector(
                            onTap: () => _ctr.jumpPhoneOrMap(false),
                            child: Image.asset(
                              ImageUtils.icon_navigation,
                              width: 38.w,
                              height: 38.w,
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      Container(
                        height: 1.h,
                        color: Color(0xff262731),
                      ),
                      20.verticalSpace,
                      Text(
                        'Business hours'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      15.verticalSpace,
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 15.w,
                          childAspectRatio: 4.125,
                        ),
                        itemCount: _ctr.dealTime().length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) => Container(
                          decoration: BoxDecoration(
                            color: Color(0xff262731),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _ctr.dealTime()[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1.h,
                        color: Color(0xff262731),
                      ),
                      15.verticalSpace,
                      Text(
                        'Configuration list'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      15.verticalSpace,
                      ListView.builder(
                        itemCount: _ctr.model?.areaVoList.length ?? 0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) => Container(
                          decoration: BoxDecoration(
                            color: i % 2 == 0
                                ? Color(0xff262731)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          height: 45.h,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Image.asset(
                                _ctr.getIconRes(_ctr.model?.areaVoList[i].areaName),
                                width: 16.w,
                                height: 16.h,
                              ),
                              13.horizontalSpace,
                              Text(
                                _ctr.model?.areaVoList[i].areaName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '£ ${_ctr.model?.areaVoList[i].bookingPrice}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Color(0xffFFD20E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      ColorfulButton(
                        child: Text(
                          "Book Now".tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "DIN",
                              fontSize: 18.sp),
                        ),
                        height: 40.h,
                        borderRadius: 20.r,
                        onTap: () => Get.bottomSheet(
                          BookingDialog(_ctr.model?.id ?? 0),
                          isScrollControlled: true,
                        ),
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ));
  }
}
