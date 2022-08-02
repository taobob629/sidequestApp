import 'package:wy/api/wy_http.dart';
import 'package:wy/model/order_model.dart';

class OrderApi {

  static Future<List<OrderModel>> list(int status) async {
    var response = await http.get('/app/order/list',
      queryParameters: ({"status":status})
    );
    List<OrderModel> list = response.data
      .map<OrderModel>((item) => OrderModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<void> delete(String id) async {
    await http.get('/app/order/delete',queryParameters: ({"orderId":id}));
  }
}