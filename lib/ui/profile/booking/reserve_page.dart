import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/booking_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/model/selector_item.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/dialog_date_time_picker.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/controller/user_controller.dart';

import '../../common/select_view.dart';
import '../balance/balance_page.dart';

class ReservePage extends StatelessWidget {
  final controller = Get.put(ReservePageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Book A Room".tr,
      body: Stack(
        children: [
          _buildMouth(),
          _buildShadow(),
          _buildContent(context),
          _buildDashLine(),
          _buildHoleShadow(),
          _buildHole()
        ],
      ),
      floatingActionButton: FloatingButton(
        label: "BOOK".tr,
        onTap: () => controller.book(),
      ),
    );
  }

  Widget _buildMouth() {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 0),
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff28263c), Color(0xff353350)]),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Container(
            height: 11,
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                      color: Color(0xff353350), borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  height: 10,
                  margin: const EdgeInsets.only(left: 1, right: 1, top: 1),
                  decoration: BoxDecoration(
                      color: AppColor.background, borderRadius: BorderRadius.circular(5)),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildShadow() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 15),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.4, 0.8],
              colors: [Color(0xff353350), Colors.transparent]),
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() => Container(
          margin: const EdgeInsets.only(left: 26, right: 26, top: 16),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 0.8],
                  colors: [Color(0xff28263c), AppColor.background]),
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.4],
                        colors: [Color(0xff312f49), Color(0xff28263c)])),
              ),
              SelectView(
                label: "Store".tr,
                tips: "Select One Store".tr,
                value: controller.store.value.name,
                onTap: () async {
                  controller.showSelectLocation();
                },
              ),
              SelectView(
                label: "Area".tr,
                tips: "Select One Area".tr,
                value: controller.area.value.name,
                onTap: () async {
                  if (controller.store.value.id == 0) {
                    controller.showSelectLocation();
                  } else {
                    controller.showSelectArea();
                  }
                },
              ),
              // SelectView(
              //   label: "Number of People",
              //   tips: "Number of people",
              //   value: controller.people.value.name,
              //   onTap: () async {
              //     controller.showSelectPeople();
              //   },
              // ),
              SelectView(
                label: "What Time".tr,
                tips: "What Time".tr,
                value: controller.timeSelect.value
                    ? formatDate(controller.time.value, [dd, '/', M, '/', yyyy, ' ', HH, ':', nn])
                    : "",
                onTap: () {
                  controller.showSelectTime();
                },
              ),
              SelectView(
                label: "How Long".tr,
                tips: "How Long".tr,
                value: controller.duration.value.name,
                onTap: () async {
                  controller.showSelectDuration();
                },
              ),
              InputView(
                height: 45.h,
                label: "Phone".tr,
                tips: "Contact Phone".tr,
                textInputType: TextInputType.phone,
                controller: controller.phoneController,
                focusNode: controller.focusNode,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Text(
                  "* Any Events / BootCamp / Birthday booking requirements please contact our customer service directly."
                      .tr,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Text(
                  "* We require at least 4 people to attend bookings for Battle Rooms or Squad Rooms, and a minimum of 2 people for Duo Rooms."
                      .tr,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Text(
                  "* If you arrive more than half an hour after your booking time, your reservation will be invalidated."
                      .tr,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Text(
                  "* Please note that if you don't meet the above criteria, the deposit will not be refundable."
                      .tr,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildDashLine() {
    return Positioned(
      left: 35,
      right: 35,
      top: 65,
      child: CYDashedLine(
        width: 10,
        count: 20,
        color: Color(0xFF0D0C1D),
      ),
    );
  }

  Widget _buildHoleShadow() {
    return Positioned(
        left: 10,
        right: 10,
        top: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipPath(
              clipper: _LeftHalfPath(),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xff323232),
              ),
            ),
            ClipPath(
              clipper: _RightHalfPath(),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xff323232),
              ),
            )
          ],
        ));
  }

  Widget _buildHole() {
    return Positioned(
        left: 10,
        right: 10,
        top: 50.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipPath(
              clipper: _LeftHalfPath(),
              child: CircleAvatar(
                radius: 14.5,
                backgroundColor: AppColor.background,
              ),
            ),
            ClipPath(
              clipper: _RightHalfPath(),
              child: CircleAvatar(
                radius: 14.5,
                backgroundColor: AppColor.background,
              ),
            )
          ],
        ));
  }
}

class _LeftHalfPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0); //x,y坐标
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _RightHalfPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0); //x,y坐标
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CYDashedLine extends StatelessWidget {
  final Axis axis; // 方向
  final double width; //宽度
  final double height; //高度
  final int count; // 个数，密度
  final Color color;

  CYDashedLine(
      {this.axis = Axis.horizontal,
      this.width = 1,
      this.height = 1,
      this.count = 10,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (_) {
        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(width)),
          ),
        );
      }),
    );
  }
}

class ReservePageController extends GetxController {
  RxList<BookingSelectModel> stores = RxList();
  RxList<BookingSelectModel> areas = RxList();

  RxList<BookingSelectModel> peopleList = RxList();
  RxList<BookingSelectModel> durationList = RxList();

  static final DateTime bookingTime = DateTime.now();

  var store = BookingSelectModel().obs;
  var area = BookingSelectModel().obs;
  var people = BookingSelectModel().obs;
  var duration = BookingSelectModel().obs;
  var time = bookingTime.obs;

  var timeSelect = false.obs;

  late TextEditingController phoneController;
  late FocusNode focusNode;

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void onReady() async {
    super.onReady();
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    stores.addAll(await BookingApi.listStores());
    EasyLoading.dismiss();
    for (int i = 1; i <= 10; i++) {
      BookingSelectModel model = BookingSelectModel();
      model.id = i;
      model.name = "$i";
      peopleList.add(model);
    }
    showSelectLocation();

    var userController = Get.find<UserController>();
    phoneController.text = userController.user.value.phone;
  }

  @override
  void onClose() {
    EasyLoading.dismiss(animation: false);
    phoneController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void showSelectLocation() {
    Get.dialog(
            SelectorDialog(
              items: this.stores,
              title: "Select Store".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        BookingSelectModel store = value as BookingSelectModel;
        storeSelect(store);
      }
    });
  }

  void storeSelect(BookingSelectModel storeModel) async {
    store.value = storeModel;
    areas.clear();
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    areas.addAll(await BookingApi.listAreas(storeModel.id));
    EasyLoading.dismiss();
    showSelectArea();
  }

  void showSelectArea() {
    Get.dialog(
            SelectorDialog(
              items: this.areas,
              title: "Select Area".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        BookingSelectModel area = value as BookingSelectModel;
        this.area.value = area;
        if (timeSelect.value == false) {
          showSelectTime();
        }
      }
    });
  }

  // void showSelectPeople(){
  //   Get.dialog(SelectorDialog(items:this.peopleList,title: "Number of people"),barrierColor: Colors.black26).then((value) {
  //     if (value != null) {
  //       BookingSelectModel people = value as BookingSelectModel;
  //       this.people.value = people;
  //       if(this.time.value == bookingTime){
  //         showSelectTime();
  //       }
  //     }
  //   });
  // }

  void showSelectTime() {
    if (store.value.id == 0) {
      showSelectLocation();
      return;
    }
    DateTime start = DateTime.parse("1970-01-01 00:00:00");
    if (store.value.model != null) {
      StoreModel storeModel = store.value.model as StoreModel;
      start = storeModel.getStart();
    }
    var tomorrow = DateTime.now();
    tomorrow = tomorrow
        .add(Duration(days: 1))
        .add(Duration(hours: (start.hour - tomorrow.hour)))
        .add(Duration(minutes: 0 - tomorrow.minute));
    this.time.value = this.timeSelect.value == true ? this.time.value : tomorrow;
    Get.dialog<DateTime?>(
            DateTimePickerDialog(
              format: "dd-MMM-yyyy HH:mm",
              initDateTime: this.timeSelect.value == true ? this.time.value : tomorrow,
              minDateTime: tomorrow,
              minuteDivider: 30,
            ),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        this.timeSelect.value = true;
        StoreModel storeModel = store.value.model as StoreModel;
        DateTime end = storeModel.getEnd();
        DateTime start = storeModel.getStart();
        if (value.hour > end.hour - 1) {
          EasyLoading.showError(
              "${storeModel.name} ${'closed at this time, please choose another time.'.tr}");
          this.time.value = tomorrow.add(Duration(hours: (end.hour - start.hour - 1)));
          return;
        } else if (value.hour < start.hour) {
          EasyLoading.showError(
              "${storeModel.name} ${'not open at this time, please choose another time.'.tr}");
          this.time.value = tomorrow;
          return;
        } else {
          this.time.value = value;
        }

        if (this.duration.value.id == 0) {
          showSelectDuration();
        } else {
          if (end.hour - this.time.value.hour < this.duration.value.id) {
            this.duration.value.id = 0;
            this.duration.value.name = "";
            showSelectDuration();
          }
        }
      }
    });
  }

  void showSelectDuration() {
    if (this.timeSelect.value == false) {
      showSelectTime();
      return;
    }
    durationList.clear();
    StoreModel storeModel = store.value.model as StoreModel;
    DateTime end = storeModel.getEnd();
    BookingSelectModel model = BookingSelectModel();
    model.id = 1;
    model.name = "1 hour".tr;
    durationList.add(model);
    int j = 2;
    for (int i = time.value.hour + 1; i < end.hour; i++) {
      BookingSelectModel model = BookingSelectModel();
      model.id = j;
      model.name = "$j ${'hours'.tr}";
      durationList.add(model);
      j++;
    }
    Get.dialog(SelectorDialog(items: this.durationList, title: "How Long".tr),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        BookingSelectModel duration = value as BookingSelectModel;
        this.duration.value = duration;
      }
    });
  }

  void book() async {
    BookingModel model = BookingModel();
    model.storeId = store.value.id;
    model.areaId = area.value.id;
    model.duration = duration.value.id;
    model.people = people.value.id;
    model.time = 100 * (time.value.millisecondsSinceEpoch ~/ 100000);
    model.phone = phoneController.text;

    if (model.storeId == 0) {
      EasyLoading.showInfo("Please select store location".tr);
      return;
    }

    if (model.areaId == 0) {
      EasyLoading.showInfo("Please select one area".tr);
      return;
    }

    if (model.duration == 0) {
      EasyLoading.showInfo("Please select how long".tr);
      return;
    }

    // if(model.people == 0){
    //   EasyLoading.showToast("Please select number of people");
    //   return;
    // }
    if (time.value == bookingTime) {
      EasyLoading.showInfo("Please select what time".tr);
      return;
    }

    if (model.phone.isEmpty) {
      EasyLoading.showInfo("Please input your phone".tr);
      return;
    }

    checkFee(() async {
      EasyLoading.show();
      await BookingApi.reserve(model);
      EasyLoading.dismiss();

      Get.dialog(
              ConfirmDialog(
                title: "Congratulations!".tr,
                info: "Your room is reserved. An confirmation email will send to you shortly.".tr,
                cancelable: false,
              ),
              barrierColor: Colors.black26)
          .whenComplete(() => Get.back(result: true));
    });
  }

  void checkFee(Function checkDone) {
    double price = 0;
    if (area.value.model != null) {
      StoreAreaModel storeAreaModel = area.value.model as StoreAreaModel;
      price = storeAreaModel.bookingPrice;
    }
    if (price > 0) {
      String tips =
          "${'We will charge a deposit of'.tr} £ ${price.toStringAsFixed(2)} ${'from your balance for booking this area, Please make sure that you have enough balance.'.tr}";
      Get.dialog(ConfirmDialog(title: "Deposit Required".tr, info: tips),
              barrierColor: Colors.black26)
          .then((value) {
        if (value == true) {
          UserController userController = Get.find<UserController>();
          double userBalance = double.parse(userController.userInfoModel.value.balance);
          if (userBalance >= price) {
            checkDone.call();
          } else {
            Get.to(() => BalancePage(
                  amount: price,
                ));
          }
        }
      });
    } else {
      checkDone.call();
    }
  }
}
