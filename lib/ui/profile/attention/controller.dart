/*
  controller
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttentionTabController extends GetxController with GetSingleTickerProviderStateMixin {
  var tabs = ['Follow', 'Fans'];
  late TabController tabController = TabController(vsync: this, length: tabs.length, initialIndex: 0);

  @override
  void onInit() {
    super.onInit();
  }
}
