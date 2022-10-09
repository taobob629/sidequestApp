/*
  controoler
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:get/get.dart';

class GradeController extends GetxController{
 RxBool _isLoadding=RxBool(true);

 bool get isLoadding => _isLoadding.value;

  set isLoadding(bool value) {
    _isLoadding.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 2000),(){
      isLoadding=false;
    });
  }
  //获取等级数据
  initData(){

  }
}