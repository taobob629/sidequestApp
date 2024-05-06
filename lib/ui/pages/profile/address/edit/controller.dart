/**
    author:mac
    创建日期:2023/4/1
    描述:
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/address_api.dart';
import '../../../../../common/address_model.dart';
import '../../../../../common/getx_list_controller.dart';
import '../../../../../config/app_config.dart';
import '../../../../../model/shire.dart';
import '../../../../../utils/string_utils.dart';
import '../../../../../utils/toast_utils.dart';

class EditAddressPageController extends GetxListController<Shire> {
  var useAsDefault = true.obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  // var line1Controller = TextEditingController();
  // var line2Controller = TextEditingController();
  var codeController = TextEditingController();
  // var cityController = TextEditingController();

  var id = 0;

  EditAddressPageController({required AddressModel? address}){
    if(address != null) {
      firstNameController.text = address.firstName;
      lastNameController.text = address.lastName;
      emailController.text = address.email;
      phoneController.text = address.phone;
      // line1Controller.text = address.line1;
      // line2Controller.text = address.line2;
      codeController.text = address.postCode;
      // cityController.text = address.city;
      useAsDefault.value = address.useDefault;
      id = address.id;
    }
  }

  @override
  void onClose(){
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    // line1Controller.dispose();
    // line2Controller.dispose();
    codeController.dispose();
    // cityController.dispose();
    super.onClose();
  }

  Future<List<Shire>> loadData() async {
    List<Shire> shireList = [];

    List<dynamic> stateList = jsonDecode(AppConfig.cityJson);
    shireList = stateList
        .map((e) => Shire.fromJson(e))
        .where((element) => element.countryCode == "GB").toList();
    jsonEncode(shireList);
    return shireList;
  }

  void delete() async {
    showLoading();
    await AddressApi.delete(id);
    dismissLoading();
    Get.back(result: true);
  }

  void save() async{
    String firstName = firstNameController.text;
    if(firstName.isEmpty){
      showToast("Please input a first name".tr);
      return;
    }
    String lastName = lastNameController.text;
    if(lastName.isEmpty){
      showToast("Please input a last name".tr);
      return;
    }
    String email = emailController.text;
    if(email.isEmpty||!StringUtil.isEmail(email)){
      showToast("Please input a email".tr);
      return;
    }
    String phone = phoneController.text;
    if(phone.isEmpty){
      showToast("Please input a phone number".tr);
      return;
    }
    // String line1 = line1Controller.text;
    // if(line1.isEmpty){
    //   showToast("Please input a detail address".tr);
    //   return;
    // }
    // String line2 = line2Controller.text;

    String code = codeController.text;
    if(code.isEmpty){
      showToast("Please input a post code".tr);
      return;
    }

    // String city = cityController.text;
    // if(city.isEmpty){
    //   showToast("Please input your city".tr);
    //   return;
    // }
    AddressModel model = AddressModel();
    model.id = id;
    model.firstName = firstName;
    model.lastName = lastName;
    model.email = email;
    model.phone = phone;
    // model.line1 = line1;
    // model.line2 = line2;
    model.postCode = code;
    // model.city = city;
    model.useDefault = useAsDefault.value;
    showLoading();
    await AddressApi.save(model);
    dismissLoading();
    Get.back(result: true);
  }
}