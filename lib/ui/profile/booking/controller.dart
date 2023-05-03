/**
    author:mac
    创建日期:2023/3/7
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/booking_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';

import '../../../utils/toast_utils.dart';
class BookingPageController extends GetxListController<BookingModel> {

  late ScrollController scrollController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.offset - offset > 0) { //down
        if (floatingActionButtonShow.value) {
          floatingActionButtonShow.value = false;
        }
      } else { //up
        if (!floatingActionButtonShow.value) {
          floatingActionButtonShow.value = true;
        }
      }
      offset = scrollController.offset;
    });
    super.onReady();
  }

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