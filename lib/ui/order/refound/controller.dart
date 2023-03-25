/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/order_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/model/order_detail.dart';
import 'package:wy/utils/utils.dart';

const contact_emal = '1277389320@qq.com';

class OrderRefoundController extends BasePageController {
  RxList<RefoundReasonModel> list = RxList();
  TextEditingController etCommnetController = TextEditingController();
  late var orderId;
  late var order;

  @override
  void onInit() {
    super.onInit();
    Map params = Get.arguments;
    order = params['order'];
    orderId = params['orderId'];
    initReasons();
  }

  //获取退款理由
  initReasons() async {
    var result = await OrderApi.getRefoundReasons();
    list.addAll(result);
  }

  Rxn<RefoundReasonModel?> _reason = Rxn();

  RefoundReasonModel? get reason => _reason.value;

  set reason(RefoundReasonModel? value) {
    _reason.value = value;
  }

  choseReason() {
    if (list.isEmpty) return;
    Get.bottomSheet(
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            RefoundReasonModel item = list[index];
            return Container(
              child: ListTile(
                onTap: () {
                  Get.back();
                  reason = item;
                },
                dense: true,
                title: Text('${item.reason}'),
              ),
            );
          },
          itemCount: list.length,
        ),
        backgroundColor: Color(0xFF313033),
        isScrollControlled: false);
  }

  submit() async {
    if (reason == null) {
      toast('Select reason first!');
      return;
    }
    await OrderApi.askRefund(Map<String, dynamic>()
      ..['label'] = reason?.reason
      ..['reason'] = etCommnetController.text
      ..['orderId'] = orderId);
  }
}
