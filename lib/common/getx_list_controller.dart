
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../utils/toast_utils.dart';
import 'base_controller.dart';

abstract class GetxListController<T> extends BasePageController {

  RxList<T> list = RxList();
  var initializing = true.obs;

  @override
  @mustCallSuper
  void onReady() async{
    super.onReady();
    var data = await loadData();
    list.clear();
    list.addAll(data);
    initializing.value = false;
  }

  @override
  @mustCallSuper
  void onClose(){
    dismissLoading();
    super.onClose();
  }

  Future<List<T>> loadData();

  void reload() async{
    showLoading();
    var data = await loadData();
    list.clear();
    list.addAll(data);
    dismissLoading();
  }
}