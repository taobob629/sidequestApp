import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/ui/playwith/balance/play_balance_child.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/city_picker/model/select_status_model.dart';

/**
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class BindBankCardController extends GetxController {
  late TextEditingController sortCodeTEC;
  late TextEditingController swiftCodeTEC;
  late TextEditingController bankCountryTEC;
  late TextEditingController bankNameTEC;
  //late TextEditingController bankIBANTEC;
  late TextEditingController bankAddressTEC;
  late TextEditingController accountNumTEC;
  late TextEditingController nameOnAccountNumTEC;
//  late TextEditingController accountAddressTEC;
  RxString _bankName = RxString('');

  String get bankName => _bankName.value;

  set bankName(String value) {
    _bankName.value = value;
  }

  Rxn<Country> _country = Rxn();

  Country? get country => _country.value;

  set country(Country? value) {
    _country.value = value;
  }

  RxList<Country> _countries = RxList();

  List<Country> get countries => _countries.value;

  set countries(List<Country> value) {
    _countries.value = value;
  }

  RxList<SimpleBankModel> _banks = RxList();

  List<SimpleBankModel> get banks => _banks.value;

  set banks(List<SimpleBankModel> value) {
    _banks.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    initCountries();
  //  privacyCheckController = PrivacyCheckController();
    sortCodeTEC = TextEditingController();
    swiftCodeTEC = TextEditingController();
    bankCountryTEC = TextEditingController();
    // bankIBANTEC = TextEditingController();
    bankNameTEC = TextEditingController();
    bankAddressTEC = TextEditingController();
    accountNumTEC = TextEditingController();
    nameOnAccountNumTEC = TextEditingController();
    //accountAddressTEC = TextEditingController();
    sortCodeTEC.addListener(() {
      var text = sortCodeTEC.text;
      if (text.length == 8) {
        search(text);
      }
    });
  }

  initCountries() async {
    if (countries.isNotEmpty) return countries;
    countries.clear();
    var res = await rootBundle.loadString('assets/data/country.json');
    countries = (jsonDecode(res) as List).map((json) => Country.fromJson(json)).toList();
  }

  search(String? text) async {
    bankName = await IndexApi.searchBankByCode(text);
    bankNameTEC.text = bankName;
  }

  save() async {
    // if (privacyCheckController.check()) {
    if (!validateForm()) {
        EasyLoading.showToast('Incomplete information!');
        return;
      }
      EasyLoading.show();
      var sortcode = sortCodeTEC.text;
      var bankName = bankNameTEC.text;
      var bankAddress = bankAddressTEC.text;
      var country = this.country?.name;
      var billAddress = this.bankAddressTEC.text;
    //  var iban = this.bankIBANTEC.text;
    var cardNumber = accountNumTEC.text;
      var accountName = nameOnAccountNumTEC.text;
     // var accountAddress = accountAddressTEC.text;

      await BalanceApi.addBankCard(Map<String, dynamic>()
          ..['sortcode'] = sortcode
          ..['bankName'] = bankName
          ..['cardNumber'] = cardNumber
          ..['accountName'] = accountName
          ..['bankAddress'] = bankAddress
          ..['country'] = country
          ..['billAddress'] = billAddress
         )
        //..['iban'] = iban)
        .catchError((e) {
        EasyLoading.dismiss();
      });
      refreshBankList();
      EasyLoading.dismiss();
      Get.back();
    //  }
  }

  bool validateForm() {
    var bankName = bankNameTEC.text;
    // var bankAddress = bankAddressTEC.text;
    var country = this.country?.name;
    // var billAddress = this.bankAddressTEC.text;
 //   var iban = this.bankIBANTEC.text;
    var cardNumber = accountNumTEC.text;
    var accountName = nameOnAccountNumTEC.text;
   // var accountAddress = accountAddressTEC.text;
 //   flog('$bankName  $bankAddress $country ${billAddress} $cardNumber $accountName');
    return bankName.isNotEmpty &&
        // bankAddress.isNotEmpty &&
        country?.isNotEmpty == true &&
        // billAddress.isNotEmpty &&
        cardNumber.isNotEmpty &&
        //accountAddress.isNotEmpty&&
        accountName.isNotEmpty;
  }

  /**
   * 添加完成银行卡之后刷新列表
   */
  refreshBankList() {
    try {
      Get.find<WalletBalancePageController>().getBankList();
    } catch (e) {}
  }

  updateBanks(Country? country) async {
    this.country = country;
    banks = await BalanceApi.getBanks(country?.name);
    flog('banks $banks');
  }

  @override
  void onClose() {
    super.onClose();
    //   privacyCheckController.dispose();
    sortCodeTEC.dispose();
    swiftCodeTEC.dispose();
    bankCountryTEC.dispose();
    //  bankIBANTEC.dispose();
    bankNameTEC.dispose();
    bankAddressTEC.dispose();
    accountNumTEC.dispose();
    nameOnAccountNumTEC.dispose();
  }
}
