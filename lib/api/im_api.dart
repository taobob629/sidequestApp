
import '../model/im_sig_model.dart';
import '../model/play_detail_model.dart';
import '../model/play_order_detail_model.dart';
import 'wy_http.dart';

class ImApi {

  static Future<ImSigModel> login() async {
    var response = await http.get('/peiwan/app/tim/getSig',);
    return ImSigModel.fromJson(response.data);
  }

  static Future<PlayDetailModel> getPlayDetail(String id,bool isMemberCode) async {
    String url = '/peiwan/app/home/super/$id';
    if(isMemberCode){
      url = '/peiwan/app/home/superMemberCode/$id';
    }
    var response = await http.get(url,
      queryParameters: ({})
    );
    return PlayDetailModel.fromJson(response.data);
  }

  static Future<PlayDetailModel> getPlayDetailByMemberCode(String memberCode) async {
    var response = await http.get('/peiwan/app/home/superMemberCode/$memberCode',
      queryParameters: ({})
    );
    return PlayDetailModel.fromJson(response.data);
  }

  static Future<PlayOrderDetailModel?> getCurrentPlayOrderDetail(String memberCode) async {
    var response = await http.get('/peiwan/app/order/imOrderDetail',
      queryParameters: ({'memberCode':memberCode})
    );
    if(response.data != null) {
      return PlayOrderDetailModel.fromJson(response.data);
    }else{
      return null;
    }
  }

  static Future<PlayOrderDetailModel> getPlayOrderDetail(int orderId) async {
    var response = await http.get('/peiwan/app/order/orderDetail',
      queryParameters: ({'orderId':orderId})
    );
    return PlayOrderDetailModel.fromJson(response.data);
  }

  static Future<void> cancelOrder(String orderId) async {
    var formData = {
      "orderId" : orderId,
      "reason" : ""
    };
    await http.put(
      '/peiwan/app/order/cancel',
      queryParameters: ({'orderId':orderId}),
      data: formData
    );
  }

  static Future<void> acceptOrder(String orderId) async {
    var formData = {
      "orderId" : orderId
    };
    await http.put(
      '/peiwan/app/order/accept',
      queryParameters: ({'orderId':orderId}),
      data: formData
    );
  }

  static Future<void> rejectOrder(String orderId) async {
    var formData = {
      "orderId" : orderId
    };
    await http.put(
      '/peiwan/app/order/reject',
      queryParameters: ({'orderId':orderId}),
      data: formData
    );
  }

  static Future<void> finishOrder(String orderId, double star, String comments) async {
    var formData = {
      "orderId" : orderId,
      "star" : star,
      "comments" : comments
    };
    await http.put(
      '/peiwan/app/order/complete',
      queryParameters: ({'orderId':orderId}),
      data: formData
    );
  }
}