import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/address_api.dart';
import '../../../../../common/address_model.dart';
import '../../../../../common/getx_list_controller.dart';
import '../../../../../utils/toast_utils.dart';

/**
    author:mac
    创建日期:2023/4/1
    描述:
 */

class AddressPageController extends GetxListController<AddressModel> {

  late ScrollController scrollController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  Rx<AddressModel> defaultAddress = AddressModel().obs;

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

  Future<List<AddressModel>> loadData() async {
    List<AddressModel> addressList = [];
    showLoading();
    addressList = await AddressApi.list();
    dismissLoading();
    if(addressList.length > 0) {
      defaultAddress.value = addressList.firstWhere((element) => element.useDefault, orElse:()=>addressList.first);
    }
    return addressList;
  }
}