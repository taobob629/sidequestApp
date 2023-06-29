import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../config/app_pages.dart';
import '../../config/icon_font.dart';
import '../../model/booking_model.dart';
import '../../model/cybercafe_detail_model.dart';
import '../../res/dimens.dart';
import '../../utils/time_utils.dart';
import '../common/colorful_button.dart';
import '../common/dialog_date_time_picker.dart';
import '../common/dialog_selector.dart';
import '../common/select_view.dart';
import '../profile/balance/balance_page.dart';

class BookingDialog extends StatelessWidget {
  var ifSelectDuration = false.obs;
  var ifSelectHowLong = false.obs;
  var ifSelectRoom = false.obs;

  var duration = BookingSelectModel().obs;
  RxList<BookingSelectModel> durationList = RxList();

  var area = BookingSelectModel().obs;
  RxList<BookingSelectModel> areas = RxList();

  var players = (-1).obs;
  RxList<BookingSelectModel> playersList = RxList();

  DateTime tomorrow = DateTime.now();
  static final DateTime bookingTime = DateTime.now();
  var time = bookingTime.obs;

  late TextEditingController telephoneCtr;

  int id;
  String telephone;

  BookingDialog(this.id, this.telephone);

  @override
  Widget build(BuildContext context) {
    ifSelectDuration.value = false;
    ifSelectHowLong.value = false;
    ifSelectRoom.value = false;
    players.value = -1;
    telephoneCtr = TextEditingController(text: telephone);

    DateTime start = DateTime.parse("1970-01-01 00:00:00");
    tomorrow = tomorrow
        .add(Duration(days: 1))
        .add(Duration(hours: (start.hour - tomorrow.hour)))
        .add(Duration(minutes: 0 - tomorrow.minute));

    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Color(0xff1B1A1E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
            ),
          ),
          padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reservation information'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.back(),
                      child: Text(
                        'Cancel'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SelectView(
                  label: "What Time".tr,
                  tips: "What Time".tr,
                  backgroundColor: Color(0xff262731),
                  marginDis: 4,
                  value: !ifSelectDuration.value
                      ? null
                      : formatDate(time.value,
                          [dd, '/', M, '/', yyyy, ' ', HH, ':', nn]),
                  onTap: showSelectTime,
                ),
                SelectView(
                  label: "How long".tr,
                  tips: "How long".tr,
                  value: !ifSelectHowLong.value ? null : duration.value.name,
                  backgroundColor: Color(0xff262731),
                  marginDis: 4,
                  onTap: showSelectHowLong,
                ),
                SelectView(
                  label: "Room".tr,
                  tips: "Select Room".tr,
                  backgroundColor: Color(0xff262731),
                  marginDis: 4,
                  value: ifSelectRoom.value ? area.value.name : null,
                  onTap: () => showSelectRoom(),
                ),
                SelectView(
                  label: "Players".tr,
                  tips: "Select Players".tr,
                  backgroundColor: Color(0xff262731),
                  value: players.value == -1 ? null : players.value.toString(),
                  marginDis: 4,
                  onTap: showSelectPlayers,
                ),
                _telephoneWidget(),
                30.verticalSpace,
                ColorfulButton(
                  child: Text(
                    "Book Now".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "DIN",
                      fontSize: 18.sp,
                    ),
                  ),
                  height: 40.h,
                  borderRadius: 20.r,
                  onTap: booking,
                ),
                contentPadding(
                    child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text:
                            "* For any bootcamps/party bookings please contact support@sidequestmeta.com. If you wish to organise a gaming event with us then contact event@sidequestmeta.com." +
                                '\n'.tr,
                        style: TextStyle(
                          color: Color(0xFFC5C3C6),
                          fontSize: 12.sp,
                          fontFamily: FONT_LIGHT,
                        )),
                    TextSpan(
                        text:
                            "* We require at least 4 people to attend bookings for Squad and Battle Rooms, and 2 people for Duo Rooms. If less people arrive for the booking then the deposit will not be refunded." +
                                '\n'.tr,
                        style: TextStyle(
                          color: Color(0xFFC5C3C6),
                          fontSize: 12.sp,
                          fontFamily: FONT_LIGHT,
                        )),
                    TextSpan(
                        text:
                            "* If you are late by more than 30 minutes to your booked time then your reservation will be cancelled and deposit won’t be refunded." +
                                '\n'.tr,
                        style: TextStyle(
                          color: Color(0xFFC5C3C6),
                          fontSize: 12.sp,
                          fontFamily: FONT_LIGHT,
                        )),
                  ]),
                  strutStyle: StrutStyle(
                    height: 1.1,
                    fontFamily: FONT_LIGHT,
                  ),
                )),
              ],
            ),
          ),
        ));
  }

  Widget _telephoneWidget() => Container(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
                top: 10,
              ).h,
              child: Text(
                'Telephone'.tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM),
              ),
            ),
            Container(
              height: 45.h,
              margin: EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 3),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xff262731),
                borderRadius: BorderRadius.circular(10).r,
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: telephoneCtr,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  isCollapsed: true,
                ),
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFFC5C3C6),
                  fontFamily: FONT_LIGHT,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      );

  void showSelectPlayers() {
    if (!ifSelectDuration.value) {
      showSelectTime();
      return;
    }
    if (!ifSelectHowLong.value) {
      showSelectHowLong();
      return;
    }
    if (!ifSelectRoom.value) {
      showSelectRoom();
      return;
    }

    playersList.clear();
    AreaVoList vo = area.value.model as AreaVoList;

    for (int i = 1; i <= vo.computers; i++) {
      BookingSelectModel model = BookingSelectModel();
      model.id = i;
      model.name = "$i";
      playersList.add(model);
    }
    Get.dialog(
      SelectorDialog(
        items: this.playersList,
        title: "Players".tr,
      ),
      barrierColor: Colors.black26,
    ).then((value) {
      if (value != null) {
        BookingSelectModel duration = value as BookingSelectModel;
        this.players.value = duration.id;
      }
    });
  }

  void showSelectRoom() async {
    if (!ifSelectDuration.value) {
      showSelectTime();
      return;
    }
    if (!ifSelectHowLong.value) {
      showSelectHowLong();
      return;
    }

    showLoading();
    var response = await http
        .get('/app/store/cybercafe/booking/stores/areas', queryParameters: {
      'storeId': id,
      'duration': duration.value.id,
      'time': (time.value.millisecondsSinceEpoch) ~/ 1000,
    });
    List<AreaVoList> list = response.data
        .map<AreaVoList>((item) => AreaVoList.fromJson(item))
        .toList();
    list.forEach((element) {
      BookingSelectModel model = BookingSelectModel();
      model.id = element.id;
      model.name = element.areaName;
      model.model = element;
      areas.add(model);
    });
    dismissLoading();

    Get.dialog(
      SelectorDialog(
        items: areas,
        title: "Select Room".tr,
        showInfo: true,
      ),
      barrierColor: Colors.black26,
    ).then((value) {
      if (value != null) {
        ifSelectRoom.value = true;
        this.area.value = value as BookingSelectModel;
        showSelectPlayers();
      }
    });
  }

  void showSelectTime() {
    Get.dialog<DateTime?>(
            DateTimePickerDialog(
              format: "dd-MMM-yyyy HH:mm",
              initDateTime: tomorrow,
              minDateTime: tomorrow,
              maxDateTime: TimeUtils.getSomeDay(tomorrow, 15),
              minuteDivider: 30,
              ifSkip: true,
            ),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        ifSelectDuration.value = true;
        this.time.value = value;
        showSelectHowLong();
      }
    });
  }

  void showSelectHowLong() {
    durationList.clear();
    for (int i = 1; i <= 6; i++) {
      BookingSelectModel model = BookingSelectModel();
      model.id = i;
      model.name = "$i ${'hours'.tr}";
      durationList.add(model);
    }
    Get.dialog(SelectorDialog(items: this.durationList, title: "How Long".tr),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        ifSelectHowLong.value = true;
        BookingSelectModel duration = value as BookingSelectModel;
        this.duration.value = duration;
        showSelectRoom();
      }
    });
  }

  void booking() async {
    if (!ifSelectDuration.value) {
      showSelectTime();
      return;
    }
    if (!ifSelectHowLong.value) {
      showSelectHowLong();
      return;
    }
    if (!ifSelectRoom.value) {
      showSelectRoom();
      return;
    }
    if (players.value == -1) {
      showSelectPlayers();
      return;
    }
    if (telephoneCtr.text.isEmpty) {
      showToast('Please enter your telephone'.tr);
      return;
    }

    showLoading();
    var response =
        await http.post('/app/store/cybercafe/booking/reserve', data: {
      "storeId": id,
      "areaId": area.value.id,
      "people": players.value,
      "duration": duration.value.id,
      "time": (time.value.millisecondsSinceEpoch) ~/ 1000,
      "storeName": (area.value.model as AreaVoList).storeName,
      "areaName": area.value.name,
      "phone": telephoneCtr.text,
    });
    dismissLoading();
    if (response.data == null || response.data == '') {
      if (response.statusCode == 200) {
        showToast(response.statusMessage);
        Get.back();
        Get.offAndToNamed(AppPages.BOOKING_PAGE);
        return;
      }
    }

    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.code == 1003) {
      // 跳转充值页面
      Get.back();
      Get.off(() => BalancePage());
      return;
    } else if (respData.code == 500) {
      return;
    }

    Get.back();
    Get.offAndToNamed(AppPages.BOOKING_PAGE);
  }
}
