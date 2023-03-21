/**
    author:mac
    创建日期:2023/3/21
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api/order_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/model/order_detail.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/im/chat.dart';
import 'package:wy/ui/im/dialog_reject.dart';
import 'package:wy/ui/order/controller.dart';
import 'package:wy/ui/order/list/controller.dart';
import 'package:wy/utils/utils.dart';

class OrderDetailPageController extends BasePageController {
  static const double starInit = 5;
  RxDouble starPer = RxDouble(starInit);
  RxDouble starRes = RxDouble(starInit);
  RxDouble starEnj = RxDouble(starInit);
  RxDouble starFri = RxDouble(starInit);

  // double get starPer => _starPer.value;
  //
  // set starPer(double value) {
  //   _starPer.value = value;
  // }

  var id;
  var type;
  TextEditingController etCommnetController = TextEditingController();
  Rxn<OrderDetailModel?> _model = Rxn();

  OrderDetailModel? get model => _model.value;

  set model(OrderDetailModel? value) {
    _model.value = value;
  }

  @override
  void onInit() {
    var params = Get.arguments as Map;
    id = params['id'];
    type = params['type'];
    pageState = PageState.initialing;
    initData();
    super.onInit();
  }

  initData() async {
    model = await OrderApi.getOrderDetail(id);
    pageState = PageState.sucess;
  }

  toChat(BuildContext context) async {
    var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
    V2TimValueCallback<V2TimConversation> conv =
        await conversationManager.getConversation(conversationID: "c2c_${model?.uk}");
    if (conv.data != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            selectedConversation: conv.data!,
            orderSn: '${model?.orderSn}',
          ),
        ),
      );
    }
  }

/*double get starRes => _starRes.value;

  set starRes(double value) {
    _starRes.value = value;
  }

  double get starEnj => _starEnj.value;

  set starEnj(double value) {
    _starEnj.value = value;
  }

  double get starFri => _starFri.value;

  set starFri(double value) {
    _starFri.value = value;
  }*/
  cancelOrder() {
    Get.dialog(
        ConfirmDialog(
          title: "Cancel Order".tr,
          info: "Do you want to cancel this order?".tr,
          confirmBtn: "CONFIRM".tr,
          onConfirm: () async {
            cancelOrderRequest();
          },
        ),
        barrierColor: Colors.black26);
  }

  Future<void> acceptOrder() async {
    EasyLoading.show();
    var res = await ImApi.acceptOrder(id).catchError((v) {});
    EasyLoading.showToast('${res.statusMessage}');
    EasyLoading.dismiss();
    Get.back();
  }

  ///大神拒绝退款
  Future<void> dsRejectOrder() async {
    Get.dialog(RejectDialog()).then((value) async {
      if (value == null) return;
      EasyLoading.show();
      var res =
          await ImApi.dsRefundOrder(id, '4', playerRejectRefundReason: value).catchError((v) {});
      EasyLoading.showToast('${res.statusMessage}');
      EasyLoading.dismiss();
      Get.back();
    });
  }

  void cancelOrderRequest() {
    Get.back();
    EasyLoading.show();
    ImApi.cancelOrder(id);
    EasyLoading.dismiss();
    Get.back();
  }

  ///大神同意退款
  Future<void> dsRefundOrder() async {
    EasyLoading.show();
    var res = await ImApi.dsRefundOrder(id, '5').catchError((v) {});
    EasyLoading.showToast('${res.statusMessage}');
    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> finishOrder() async {
    EasyLoading.show();
    var response;
    if (type == TYPE_ORDER_RECEIVED) {
      response = await OrderApi.finishOrder(id).whenComplete(() => EasyLoading.dismiss());
    } else {
      response = await OrderApi.custumFinishOrder(Map<String, dynamic>()
            ..['performance'] = starPer.value
            ..['responsive'] = starRes.value
            ..['enjoyment'] = starEnj.value
            ..['friendless'] = starFri.value
            ..['id'] = id
            ..['comments'] = etCommnetController.text)
          .whenComplete(() => EasyLoading.dismiss());
    }
    if (response.statusCode != 200) {
      EasyLoading.showToast('${response.statusMessage}');
    }
    //todo 刷新列表
    try{
      Get.find<OrderListController>(tag: 'OrderList_$type')?.refresh();
    }catch(e){

    }
    Get.back();
  }
}
