import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/**
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class BindBankCardController extends GetxController{
  TextEditingController? sortCodeTEC;
  TextEditingController? bankNameTEC;
  TextEditingController? accountNumTEC;
  TextEditingController? nameOnAccountNumTEC;
  @override
  void onInit() {
    super.onInit();
    sortCodeTEC=TextEditingController();
    bankNameTEC=TextEditingController();
    accountNumTEC=TextEditingController();
    nameOnAccountNumTEC=TextEditingController();
  }
}