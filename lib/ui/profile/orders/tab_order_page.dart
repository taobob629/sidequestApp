import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/order_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/order_model.dart';
import 'package:wy/ui/common/empty_view.dart';

import '../../../utils/toast_utils.dart';
import 'orders_item.dart';

class TabOrderPage extends StatelessWidget {

  final int status;

  late final TabOrderPageController controller;


  TabOrderPage({required this.status}){
    controller = Get.put(TabOrderPageController(status: status),tag: "$status");
  }
  @override
  Widget build(BuildContext context) {
    return Obx(()=> controller.initializing.value ? Container() : controller.list.length == 0 ? EmptyView():
      ListView.separated(
      itemBuilder: (context, index){
        OrderModel orderModel = controller.list[index];
        return OrdersItem(orderModel: orderModel, status: status,);
      },
      separatorBuilder: (context, index){
        return Container(height: 15,);
      },
      itemCount: controller.list.length
    ));
  }
}

class TabOrderPageController extends GetxListController<OrderModel> {

  late int status;

  TabOrderPageController({required this.status});

  @override
  Future<List<OrderModel>> loadData({int pageNum = 0}) async {
    showLoading();
    List<OrderModel> list = await OrderApi.list(status);
    dismissLoading();
    return list;
  }

}