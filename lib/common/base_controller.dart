/**
    author:mac
    创建日期:2023/2/12
    描述:
 */
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'page/empty_view.dart';

class PageState {
  static const  int initialing = 0;
  static const  int loaded = 1;
  static const int err = 2;
  static const int empty = 3;
  static const int sucess = 4;
}

class BasePageController extends GetxController {
  RxInt _pageState = RxInt(PageState.initialing);

  int get pageState => _pageState.value;

  set pageState(int value) {
    _pageState.value = value;
  }

  showLoadding() {
    EasyLoading.show();
  }

  dismissLoadding() {
    EasyLoading.dismiss();
  }
  toast(var msg) {
    EasyLoading.showToast(msg);
  }

  info(var msg) {
    EasyLoading.showInfo(msg);
  }

  err(var msg) {
    EasyLoading.showError(msg);
  }

  buildEmpty() {
    return EmptyView();
  }
}
