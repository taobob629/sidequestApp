/**
    author:mac
    创建日期:2023/3/7
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/booking_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';

import '../../../utils/toast_utils.dart';

class BookingPageController extends GetxListController<BookingModel> {

  Future<List<BookingModel>> loadData() async {
    showLoading();
    List<BookingModel> bookingList = await BookingApi.list();
    dismissLoading();
    return bookingList;
  }

  Future <void> cancelBook(int id)async{
    Get.dialog(ConfirmDialog(title: "Cancel Booking".tr, info: "Do you confirm to cancel this booking?".tr), barrierColor: Colors.black26).then((value) async{
      if(value != null && value == true){
        showLoading();
        await BookingApi.cancel(id);
        reload();
      }
    });

  }
}