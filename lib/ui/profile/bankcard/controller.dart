import 'dart:convert';

import 'package:flutter/material.dart';
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

  // late TextEditingController bankCountryTEC;
  late TextEditingController bankNameTEC;

  //late TextEditingController bankIBANTEC;
  late TextEditingController bankAddressTEC;
  late TextEditingController accountNumTEC;
  late TextEditingController nameOnAccountNumTEC;

  late TextEditingController billAddressTEC;
  RxBool _isLodded = RxBool(false);

  bool get isLodded => _isLodded.value;

  set isLodded(bool value) {
    _isLodded.value = value;
  }

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

  RxList<SimpleBankModel> _filterBanks = RxList();

  List<SimpleBankModel> get filterBanks => _filterBanks.value;

  set filterBanks(List<SimpleBankModel> value) {
    _filterBanks.value = value;
  }

  RxString _keyWord = RxString('');

  String get keyWord => _keyWord.value;

  set keyWord(String value) {
    _keyWord.value = value;
  }

  filterBank(String text) {
    if (banks.isEmpty) return;
    if (text.isEmpty) {
      filterBanks = banks;
      return;
    }
    keyWord = text;
    filterBanks = banks.where((item) => item.bank?.toUpperCase()?.contains(text) == true).toList();
    flog('filterBanks $filterBanks');
  }

  var bankId;
  BankCardModel? model;

  @override
  void onInit() {
    super.onInit();
    // bankId=Get.arguments['id'];
    model = Get.arguments;
    flog('Get.model ${model}');
    initCountries();
    if (model == null) {
      isLodded = true;
    }
    // flog('country $country');
    //  privacyCheckController = PrivacyCheckController();
    sortCodeTEC = TextEditingController(text: model?.sortcode);
    swiftCodeTEC = TextEditingController(text: model?.swift);
    //bankCountryTEC = TextEditingController(text: model?.);
    // bankIBANTEC = TextEditingController();
    bankAddressTEC = TextEditingController(text: model?.bankAddress);
    billAddressTEC = TextEditingController(text: model?.billAddress);
    accountNumTEC = TextEditingController(text: model?.cardNumber);
    nameOnAccountNumTEC = TextEditingController(text: model?.accountName);
    //bankNameTEC.text = model?.bankName ?? '';
    //accountAddressTEC = TextEditingController();
    sortCodeTEC.addListener(() {
      var text = sortCodeTEC.text;
      if (text.length == 8) {
        search(text);
      }
    });
  }

  initCountries() async {
    countries.clear();
    var res = await rootBundle.loadString('assets/data/country.json');
    countries = (jsonDecode(res) as List).map((json) => Country.fromJson(json)).toList();
    if (model == null) return;
    this.country = countries.firstWhereOrNull((element) {
      flog('name${element.name} counrty ${model?.country}');
      return element.name == model?.country;
    });
    this._country.refresh();
    isLodded = true;
    flog('country${country?.name} ${country?.emojiU}');
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
    var swiftCode = swiftCodeTEC.text;
    var bankName = bankNameTEC.text;
    var bankAddress = bankAddressTEC.text;
    var country = this.country?.name;
    var billAddress = this.billAddressTEC.text;
    //  var iban = this.bankIBANTEC.text;
    var cardNumber = accountNumTEC.text;
    var accountName = nameOnAccountNumTEC.text;
    // var accountAddress = accountAddressTEC.text;
    await BalanceApi.addBankCard(
            Map<String, dynamic>()
              ..['id'] = model?.id
              ..['sortcode'] = this.country?.name == ENGLAND ? sortcode : ''
              ..['swift'] = this.country?.name != ENGLAND ? swiftCode : ''
              ..['bankName'] = bankName
              ..['cardNumber'] = cardNumber
              ..['accountName'] = accountName
              ..['bankAddress'] = bankAddress
              ..['country'] = country
              ..['billAddress'] = billAddress,
            isEdit: model != null)
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
    if (country != ENGLAND) {
      var code = swiftCodeTEC.text;
      var bankAddress = bankAddressTEC.text;
      var billAddress = billAddressTEC.text;
      if (code.isEmpty || bankAddress.isEmpty || billAddress.isEmpty) return false;
    }
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
    flog('onClose');
    //   privacyCheckController.dispose();
    sortCodeTEC.dispose();
    swiftCodeTEC.dispose();
    //  bankCountryTEC.dispose();
    //  bankIBANTEC.dispose();
    // bankNameTEC.dispose();
    bankAddressTEC.dispose();
    accountNumTEC.dispose();
    nameOnAccountNumTEC.dispose();
  }
}
