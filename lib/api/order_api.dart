import 'package:dio/src/response.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/order_detail.dart';
import 'package:wy/model/order_model.dart';

class OrderApi {
  static Future<List<OrderModel>> list(int status) async {
    var response = await http.get('/app/order/list', queryParameters: ({"status": status}));
    List<OrderModel> list =
        response.data.map<OrderModel>((item) => OrderModel.fromJson(item)).toList();
    return list;
  }

  static Future<void> delete(String id) async {
    await http.get('/app/order/delete', queryParameters: ({"orderId": id}));
  }

  static Future<OrderDetailModel> getOrderDetail(var id) async {
    var response =
        await http.get('/peiwan/app/new/orders/orderDetail', queryParameters: ({"orderId": id}));
    return OrderDetailModel.fromJson(response.data);
  }

  static Future<Response> finishOrder(var id) async {
    return await http.get('/peiwan/app/new/orders/player/finish',
        queryParameters: ({"orderId": id}));
  }
  //顾客完成订单
  static Future<Response> custumFinishOrder(var params) async {
    return await http.post('/peiwan/app/new/orders/complete',
        data: params);
  }
}
