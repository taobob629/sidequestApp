
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

abstract class GetxListController<T> extends GetxController {

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
    EasyLoading.dismiss(animation: false);
    super.onClose();
  }

  Future<List<T>> loadData();

  void reload() async{
    EasyLoading.show();
    var data = await loadData();
    list.clear();
    list.addAll(data);
    EasyLoading.dismiss();
  }
}