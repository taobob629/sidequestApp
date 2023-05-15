/**
    author:mac
    创建日期:2023/3/21
    描述:
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api/order_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/model/order_detail.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/messages/chat/chat_page.dart';
import 'package:wy/ui/im/dialog_reject.dart';
import 'package:wy/ui/order/controller.dart';
import 'package:wy/ui/order/list/controller.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/dialog/dialog_comment.dart';
import 'package:dio/src/response.dart';

import '../../../utils/toast_utils.dart';

class OrderDetailPageController extends BasePageController {
  Timer? timer;
  int seconds = 60 * 15;
  var countTime = "00:00".obs;
  var ifShowCountDown = false.obs;

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

  void _formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    countTime.value = '$formattedMinutes:$formattedSeconds';
  }

  initData() async {
    model = await OrderApi.getOrderDetail(id);
    if (type == null) {
      type = UserController.find.userProfile?.pwId == model?.pwuserId ? TYPE_ORDER_PROVIDED : TYPE_ORDER_RECEIVED;
    }
    pageState = PageState.sucess;
    etCommnetController.text = model?.comments?.content ?? '';
    if (model?.comments != null) {
      starFri.value = model?.comments?.friendless ?? 5.0;
      starPer.value = model?.comments?.performance ?? 5.0;
      starRes.value = model?.comments?.responsive ?? 5.0;
      starEnj.value = model?.comments?.enjoyment ?? 5.0;
    }

    if (model?.status == 1) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((model?.addtime ?? 0) * 1000);
      seconds = dateTime.difference(DateTime.now()).inSeconds + 15 * 60;
      if (seconds <= 0) {
        ifShowCountDown.value = false;
      } else {
        ifShowCountDown.value = true;
      }

      timer = Timer.periodic(const Duration(seconds: 1), (v) {
        if (seconds > 0) {
          seconds--;
          _formatTime();
        } else {
          ifShowCountDown.value = false;
          timer?.cancel();
          initData();
        }
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
  }

  void onRefresh(orderId) {
    id = orderId;
    initData();
  }

  toChat(BuildContext context) async {
    if (Get.isRegistered<ChatController>(tag: "ChatKey")) {
      Get.back();
    } else {
      var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
      V2TimValueCallback<V2TimConversation> conv = await conversationManager.getConversation(conversationID: "c2c_${model?.uk}");
      if (conv.data != null) {
        Get.to(() => ChatPage(
              selectedConversation: conv.data!,
              orderSn: '${model?.orderSn}',
            ));
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatPage(
        //       selectedConversation: conv.data!,
        //       orderSn: '${model?.orderSn}',
        //     ),
        //   ),
        // );
      }
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
          onConfirm: () {
            cancelOrderRequest();
          },
        ),
        barrierColor: Colors.black26);
  }

  appealOrder() {
    Get.dialog(DialogComment(
      title: 'Appeal'.tr,
      hint: 'Please input reason'.tr,
      onConfirm: (text) {
        apealOrderRequest(text);
      },
    ));
  }

  //申诉
  Future<void> apealOrderRequest(var text) async {
    showLoading();
    var res = await OrderApi.apealOrder(id, text).catchError((err) {
      flog('err $err');
    });
    dismissLoading();
    showToast('${res?.statusMessage}');
    Get.back(result: true);
  }

  Future<void> acceptOrder() async {
    showLoading();
    var res = await ImApi.acceptOrder(id).catchError((v) {});
    dismissLoading();
    showToast('${res.statusMessage}');
    Get.back(result: true);
  }

  ///大神拒绝退款
  Future<void> dsRejectOrder() async {
    Get.dialog(RejectDialog()).then((value) async {
      if (value == null) return;
      showLoading();
      var res = await ImApi.dsRefundOrder(id, '4', playerRejectRefundReason: value).catchError((v) {});
      dismissLoading();
      showToast('${res.statusMessage}');
      Get.back(result: true);
    });
  }

  Future<void> cancelOrderRequest() async {
    Get.back();
    showLoading();
    await ImApi.cancelOrder(id);
    refreshList();
    dismissLoading();
    Get.back(result: true);
  }

  ///大神同意退款
  Future<void> dsRefundOrder() async {
    showLoading();
    var res = await ImApi.dsRefundOrder(id, '5').catchError((v) {});
    dismissLoading();
    showToast('${res.statusMessage}');
    Get.back(result: true);
  }

  Future<void> finishOrder() async {
    var response;
    if (type == TYPE_ORDER_RECEIVED) {
      showLoading();
      response = await OrderApi.finishOrder(id).whenComplete(() => dismissLoading());
      if (response.statusCode != 200) {
        showToast('${response.statusMessage}');
      }
      Get.back(result: true);
    } else {
      var comments = etCommnetController.text;
      if (comments.isEmpty) {
        var result = await Get.dialog(
          ConfirmDialog(
            title: 'Confirm'.tr,
            concelBtn: 'Cancel'.tr,
            cancelable: true,
            info: 'Are you sure confirm the order without any comments? ',
            onConfirm: () async {
              Get.back(result: true);
            },
          ),
        );
        flog('result--$result');
        if (result == null) {
          return;
        }
      }
      response = await custumFinishOrderRequest(response);
      dismissLoading();
      Get.back(result: true);
    }
  }

  Future<dynamic> custumFinishOrderRequest(response) async {
    response = await OrderApi.custumFinishOrder(Map<String, dynamic>()
          ..['performance'] = starPer.value
          ..['responsive'] = starRes.value
          ..['enjoyment'] = starEnj.value
          ..['friendless'] = starFri.value
          ..['id'] = id
          ..['comments'] = etCommnetController.text)
        .whenComplete(() => dismissLoading());
    if (response.statusCode != 200) {
      showToast('${response.statusMessage}');
    }
    return response;
  }

  void refreshList() {
    /* try {
      Get.find<OrderListController>(tag: 'OrderList_$type')?.refresh();
    } catch (e) {
      flog('e $e');
    }*/
  }
}
