import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/wy_http.dart';
import '../../../common/colorful_button.dart';
import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../image_utils.dart';
import '../../../model/cybercafe_detail_model.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../login/login_page.dart';
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
                      if (_ctr.model != null)
                        Image.network(
                          '${_ctr.model?.headImage}',
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
                              color: const Color(0xffFFD20E),
                            ),
                          ),
                          const Spacer(),
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
                        'Price'.tr,
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
                      ListView.separated(
                        itemCount: _ctr.model?.areaVoList.length ?? 0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) {
                          AreaVoList? vo = _ctr.model?.areaVoList[i];
                          List<DescriptionBean> dList =
                              _ctr.dealPrice(vo?.description);

                          return Container(
                            decoration: BoxDecoration(
                              color: Color(0xff262731),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                15.verticalSpace,
                                Row(
                                  children: [
                                    Image.asset(
                                      _ctr.getIconRes(
                                          _ctr.model?.areaVoList[i].areaName),
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                    13.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _ctr.model?.areaVoList[i].areaName ??
                                              '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: FONT_MEDIUM,
                                            color: Colors.white,
                                          ),
                                        ),
                                        6.verticalSpace,
                                        Text(
                                          '${vo?.computers} seats',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: FONT_MEDIUM,
                                            color: Color(0xff808388),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      dList.length == 1
                                          ? '￡ ${dList[0].price}/hr/person'
                                          : '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: FONT_MEDIUM,
                                        color: Color(0xffFFD20E),
                                      ),
                                    ),
                                  ],
                                ),
                                if (dList.length == 1) 15.verticalSpace,
                                if (dList.length > 1)
                                  ...dList
                                      .map(
                                        (e) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          child: Row(
                                            children: [
                                              29.horizontalSpace,
                                              Text(
                                                '${e.startTime}-${e.endTime}',
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
                                                '£ ${e.price}/hr/person',
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
                                      )
                                      .toList(),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (c, i) => 12.verticalSpace,
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.only(
                  bottom: 30.h,
                  left: 15.w,
                  right: 15.w,
                ),
                child: ColorfulButton(
                  height: 40.h,
                  borderRadius: 20.r,
                  onTap: () {
                    var account = StorageManager.getToken();
                    if (account.isEmpty) {
                      Get.to(() => LoginPage());
                    } else {
                      Get.bottomSheet(
                        BookingDialog(
                          _ctr.model?.id ?? 0,
                          _ctr.model?.userPhone ?? '',
                        ),
                        isScrollControlled: true,
                      );
                    }
                  },
                  child: Text(
                    "Book Now".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "DIN",
                        fontSize: 18.sp),
                  ),
                ),
              ),
            ));
  }
}

class BookingDetailCtr extends GetxController {
  static BookingDetailCtr get find => Get.find();
  CyberCafeDetailModel? model;

  @override
  void onInit() {
    super.onInit();

    _requestData();
  }

  void _requestData() async {
    showLoading();
    var response = await http.get('/app/store/cybercafe/booking/stores/info',
        queryParameters: ({
          'id': Get.arguments as int,
        }));
    model = CyberCafeDetailModel.fromJson(response.data);
    dismissLoading();
    update();
  }

  String getIconRes(String? areaName) {
    if (areaName?.toLowerCase().contains('duo') == true) {
      return ImageUtils.icon_duo_room;
    }
    if (areaName?.toLowerCase().contains('squad') == true) {
      return ImageUtils.icon_squad_room;
    }
    if (areaName?.toLowerCase().contains('battle') == true) {
      return ImageUtils.icon_battle_room;
    }
    if (areaName?.toLowerCase().contains('ps') == true) {
      return ImageUtils.icon_ps;
    }

    return ImageUtils.icon_public_area;
  }

  List<DescriptionBean> dealPrice(String? description) {
    if (description == null) {
      return [];
      // return '£ 0.0';
    }

    List<DescriptionBean> list = jsonDecode(description)
        .map<DescriptionBean>((item) => DescriptionBean.fromJson(item))
        .toList();

    String week = formatDate(DateTime.now(), [DD]);
    int weekDay = 0;
    switch (week) {
      case "Monday":
        weekDay = 1;
        break;
      case "Tuesday":
        weekDay = 2;
        break;
      case "Wednesday":
        weekDay = 3;
        break;
      case "Thursday":
        weekDay = 4;
        break;
      case "Friday":
        weekDay = 5;
        break;
      case "Saturday":
        weekDay = 6;
        break;
      case "Sunday":
        weekDay = 0;
        break;
    }

    List<DescriptionBean> filterList =
        list.where((element) => element.week == weekDay).toList();

    if (filterList.isNotEmpty) {
      return filterList;
    }
    return [];
  }

  void jumpPhoneOrMap(bool ifToPhone) async {
    if (ifToPhone) {
      Uri uri = Uri.parse('tel:${model?.telephone}');

      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
      return;
    }

    Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${model?.map}');
    // Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  List<String> dealTime() {
    if (model == null) {
      return [];
    }

    List<String> timeList = jsonDecode(model!.openTime)
        .toString()
        .replaceAll(RegExp(r'[{}]'), '')
        .split(',');

    return timeList;
  }
}
