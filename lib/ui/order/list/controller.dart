/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:wy/api/network_method.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/event_bus/beans/order_bean.dart';
import 'package:wy/model/activity_list_model.dart';
import 'package:dio/src/response.dart' as dio;
import 'package:wy/model/service_list_model.dart';
import 'package:wy/utils/index.dart';

import '../../../event_bus/event_bus.dart';

class OrderListController extends RefreshListController<ServiceListModel> {

  late var type;
  late var status;

  OrderListController(this.type, this.status);

  StreamSubscription? subscription;

  @override
  buildMethodType() {
    return NWMethod.GET;
  }

  @override
  void onInit() {
    super.onInit();

    subscription = eventBus.on<OrderBean>().listen((event) {
      status = event.status;
      request();
    });
  }

  @override
  void onClose() {
    super.onClose();

    subscription?.cancel();
    subscription = null;
  }

  @override
  Map<String, dynamic> buildParams() => {};

  @override
  String buildUrl() {
    return '/peiwan/app/new/orders/list?type=$type&status=$status';
  }

  @override
  bool paged() => true;

  @override
  List<ServiceListModel> dealData(dio.Response<dynamic> response) {
    return response.data['rows']
        .map<ServiceListModel>((item) => ServiceListModel.fromJson(item))
        .toList();
  }

  @override
  needAutoLoadData() => true;

  toDetail(ServiceListModel item) {
    Get.toNamed(AppPages.OrderDetail,
        arguments: Map()
          ..['id'] = item.id
          ..['type'] = type)?.then((value) {
            if(value==true) onRefresh();
    });
  }
}
