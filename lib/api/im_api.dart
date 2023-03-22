import 'package:dio/dio.dart';

import '../model/im_sig_model.dart';
import '../model/play_detail_model.dart';
import '../model/play_order_detail_model.dart';
import 'wy_http.dart';

class ImApi {
  static Future<ImSigModel> login() async {
    var response = await http.get(
      '/peiwan/app/tim/getSig',
    );
    return ImSigModel.fromJson(response.data);
  }

  static Future<PlayDetailModel> getPlayDetail(String id, String gid, bool isMemberCode) async {
    String url = '/peiwan/app/home/super/$id?gid=$gid';
    if (isMemberCode) {
      url = '/peiwan/app/home/superMemberCode/$id';
    }
    var response = await http.get(url, queryParameters: ({}));
    return PlayDetailModel.fromJson(response.data);
  }

  static Future<PlayDetailModel> getPlayDetailByMemberCode(String memberCode) async {
    var response =
        await http.get('/peiwan/app/home/superMemberCode/$memberCode', queryParameters: ({}));
    return PlayDetailModel.fromJson(response.data);
  }

  static Future<PlayOrderDetailModel?> getCurrentPlayOrderDetail(
      String memberCode, String orderSn) async {
    var response = await http.get('/peiwan/app/order/imOrderDetail',
        queryParameters: ({'memberCode': memberCode, if (orderSn != '') 'orderSn': orderSn}));
    if (response.data != null) {
      return PlayOrderDetailModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  static Future<PlayOrderDetailModel> getPlayOrderDetail(int orderId) async {
    var response =
        await http.get('/peiwan/app/order/orderDetail', queryParameters: ({'orderId': orderId}));
    return PlayOrderDetailModel.fromJson(response.data);
  }

  static Future<void> cancelOrder(var orderId) async {
    var formData = {"orderId": orderId, "reason": ""};
    await http.post('/peiwan/app/new/orders/cancel',
        queryParameters: ({'orderId': orderId}), data: formData);
  }

  static Future<Response> acceptOrder(var orderId) async {
    var formData = {"orderId": orderId};
    return await http.post('/peiwan/app/new/orders/accept',
        queryParameters: ({'orderId': orderId}), data: formData);
  }

  ///大神是否同意退款
  static Future<Response> dsRefundOrder(var orderId, String status,
      {var playerRejectRefundReason}) async {
    var formData = {
      "orderId": orderId,
    };
    return await http.post('/peiwan/app/order/god/refund',
        queryParameters: ({
          'orderId': orderId,
          'status': status,
          'playerRejectRefundReason': playerRejectRefundReason
        }),
        data: formData);
  }

  static Future<Response> rejectOrder(String orderId, String reason) async {
    var formData = {"orderId": orderId};
    return await http.post('/peiwan/app/new/orders/reject',
        queryParameters: ({'orderId': orderId, 'reason': reason}), data: formData);
  }

  static Future<Response> refundOrder(String orderId, String reason) async {
    var formData = {"orderId": orderId};
    return await http.post('/peiwan/app/new/orders/askRefund',
        queryParameters: ({'orderId': orderId, 'reason': reason}), data: formData);
  }

  static Future<void> finishOrder(String orderId, double star, String comments) async {
    var formData = {"id": orderId, "star": star, "comments": comments};
    await http.post('/peiwan/app/new/orders/complete',
        queryParameters: ({'orderId': orderId}), data: formData);
  }
}
