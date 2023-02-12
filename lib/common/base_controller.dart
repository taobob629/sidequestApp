/**
    author:mac
    创建日期:2023/2/12
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageState {
  static final int initialing = 0;
  static final int loaded = 1;
  static final int err = 2;
}

class BasePageController extends GetxController {
  RxInt _pageState = RxInt(PageState.initialing);

  int get pageState => _pageState.value;

  set pageState(int value) {
    _pageState.value = value;
  }
}
