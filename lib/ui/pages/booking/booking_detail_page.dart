import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/widget/image_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/booking_api.dart';
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
                      26.verticalSpace,
                      if (_ctr.model != null)
                        ImageUtil.networkImage(
                          url: '${_ctr.model?.headImage}',
                          height: 180.h,
                          width: Get.width,
                          fit: BoxFit.cover,
                          border: 10.r,
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
                                      width: 25.w,
                                      height: 25.h,
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
                                    Expanded(
                                      child: Text(
                                        dList.length == 1
                                            ? '￡ ${dList[0].price}/hr/person'
                                            : '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffFFD20E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 10.w),
                                Container(
                                  height: 1.h,
                                  color: hexColor('#3A3C48'),
                                  margin: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 10.w,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_ctr.currentIndex.value == -1) {
                                      _ctr.currentIndex.value = i;
                                    } else {
                                      if (_ctr.currentIndex.value == i) {
                                        _ctr.currentIndex.value = -1;
                                      } else {
                                        _ctr.currentIndex.value = i;
                                      }
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Configuration Details',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: FONT_LIGHT,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Obx(() => Icon(
                                            _ctr.currentIndex.value == i
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_right,
                                            color: Colors.white,
                                            size: 28.sp,
                                          )),
                                    ],
                                  ).paddingSymmetric(horizontal: 10.w),
                                ),
                                15.verticalSpace,
                                Obx(() => Visibility(
                                      visible: _ctr.currentIndex.value == i,
                                      child: Column(
                                        children: [
                                          configurationItemWidget(
                                            icon: ImageUtils.processer_icon,
                                            name: 'Processor',
                                            value: vo?.processor ?? '',
                                            bgColor: hexColor('#30313D'),
                                          ),
                                          configurationItemWidget(
                                            icon: ImageUtils.icon_gpu,
                                            name: 'GPU',
                                            value: vo?.gpu ?? '',
                                          ),
                                          configurationItemWidget(
                                            icon: ImageUtils.icon_ram,
                                            name: 'Ram',
                                            value: vo?.memory ?? '',
                                            bgColor: hexColor('#30313D'),
                                          ),
                                          configurationItemWidget(
                                            icon: ImageUtils.icon_size,
                                            name: 'Screen Size',
                                            value: vo?.screenSize ?? '',
                                          ),
                                          configurationItemWidget(
                                            icon: ImageUtils.icon_hz,
                                            name: 'Screens hz',
                                            value: vo?.screenHz ?? '',
                                            bgColor: hexColor('#30313D'),
                                          ),
                                          15.verticalSpace,
                                        ],
                                      ),
                                    )),
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
                  bottom: 20.h,
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
                          false,
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

  Widget configurationItemWidget({
    required String icon,
    required String name,
    required String value,
    Color? bgColor,
  }) =>
      Container(
        height: 44.h,
        color: bgColor ?? Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Image.asset(
              icon,
              scale: 2.6,
            ).paddingOnly(right: 8.w),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: FONT_LIGHT,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: FONT_LIGHT,
                color: hexColor('#FFD20E'),
              ),
            ),
          ],
        ),
      );
}

class BookingDetailCtr extends GetxController {
  static BookingDetailCtr get find => Get.find();
  CyberCafeDetailModel? model;
  var currentIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    _requestData();
  }

  void _requestData() async {
    showLoading();
    model = await BookingApi.storeDetail(Get.arguments as int);
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
