import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/playwith/balance/play_balance_child.dart';

/**
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class BindBankCardController extends GetxController {
  late TextEditingController sortCodeTEC;
  late TextEditingController bankNameTEC;
  late TextEditingController accountNumTEC;
  late TextEditingController nameOnAccountNumTEC;
  late PrivacyCheckController privacyCheckController;
  RxString _bankName = RxString('');

  String get bankName => _bankName.value;

  set bankName(String value) {
    _bankName.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    privacyCheckController = PrivacyCheckController();
    sortCodeTEC = TextEditingController();
    bankNameTEC = TextEditingController();
    accountNumTEC = TextEditingController();
    nameOnAccountNumTEC = TextEditingController();
    sortCodeTEC.addListener(() {
      var text = sortCodeTEC.text;
      if (text.length == 8) {
        search(text);
      }
    });
  }

  search(String? text) async {
    bankName = await IndexApi.searchBankByCode(text);
    bankNameTEC.text = bankName;
  }

  save() async {
    if (privacyCheckController.check()) {
      EasyLoading.show();
      var sortcode = sortCodeTEC.text;
      var bankName = bankNameTEC.text;
      var cardNumber = accountNumTEC.text;
      var accountName = nameOnAccountNumTEC.text;
      await BalanceApi.addBankCard(Map<String, dynamic>()
            ..['sortcode'] = sortcode
            ..['bankName'] = bankName
            ..['cardNumber'] = cardNumber
            ..['accountName'] = accountName)
          .catchError((e) {
        EasyLoading.dismiss();
      });
      refreshBankList();
      EasyLoading.dismiss();
      Get.back();
    }
  }

  /**
   * 添加完成银行卡之后刷新列表
   */
  refreshBankList() {
    try {
      Get.find<WalletBalancePageController>().getBankList();
    } catch (e) {}
  }

  @override
  void onClose() {
    sortCodeTEC.dispose();
    bankNameTEC.dispose();
    accountNumTEC.dispose();
    nameOnAccountNumTEC.dispose();
    super.onClose();
  }
}
