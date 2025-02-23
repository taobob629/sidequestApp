/**
    author:mac
    创建日期:2023/3/7
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/booking_api.dart';
import '../../../common/getx_list_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/booking_model.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/dialog_confirm.dart';
import 'booking_dialog.dart';

class BookingPageController extends GetxListController<BookingModel> {
  Future<List<BookingModel>> loadData() async {
    showLoading();
    List<BookingModel> bookingList = await BookingApi.list();
    dismissLoading();
    return bookingList;
  }

  Future<void> cancelBook(int id) async {
    Get.dialog(
            ConfirmDialog(
                title: "Cancel Booking".tr,
                info: "Do you confirm to cancel this booking?".tr),
            barrierColor: Colors.black26)
        .then((value) async {
      if (value != null && value == true) {
        showLoading();
        await BookingApi.cancel(id);
        reload();
      }
    });
  }

  void gotoAddPage() async {
    await Get.bottomSheet(
      BookingDialog(
        true,
        -1,
        UserController.find.user.value.phone,
      ),
      isScrollControlled: true,
    );
    reload();
  }
}
