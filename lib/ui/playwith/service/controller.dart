import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/utils/utils.dart';

/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class MoreGamesPageController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController=TabController(
  vsync: this, length: 0, initialIndex: 0);

  @override
  void onInit() {
    super.onInit();
    flog('onInit');
    initData();
  }
 initData(){
  IndexApi.getMoreGames(pwid: 0);
 }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
