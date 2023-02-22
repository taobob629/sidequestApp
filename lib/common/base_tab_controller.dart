/**
    author:mac
    创建日期:2021/11/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

int DEFAULT_TAB_INDEX = 0;

abstract class BaseTabContoller<T> extends BasePageController {
  TabController? tabbarController;
  RxList<T> _tabs = RxList();

  List<T> get tabs => _tabs.value;

  set tabs(List<T> value) {
    _tabs.value = value;
  }

  initTabs();

  @override
  onInit() {
    pageState = PageState.sucess;
    initTabs();
  }

  Rxn _tab_index = Rxn(DEFAULT_TAB_INDEX);

  int get tab_index => _tab_index.value;

  set tab_index(int value) {
    _tab_index.value = value;
  }

  resetTab() {
    tab_index = DEFAULT_TAB_INDEX;
  }

  @override
  void onClose() {
    tab_index = 0;
    tabbarController?.dispose();
    super.onClose();
  }
}
