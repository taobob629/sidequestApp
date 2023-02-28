import 'package:wy/api/wy_http.dart';
import 'package:wy/model/vip_info_model.dart';

class VipApi {
  static Future<List<VipInfoModel>> info() async {
    var response = await http.get('/app/vip/newInfo', queryParameters: ({}));
    List<VipInfoModel> list = response.data.map<VipInfoModel>((item) => VipInfoModel.fromJson(item)).toList();
    return list;
  }

  static Future<String> cancelInfo() async {
    var response = await http.get('/app/vip/cancellMsg', queryParameters: ({}));
    return response.data;
  }

  static Future<String> cancel() async {
    var response = await http.post('/app/order/stripe/member/end', queryParameters: ({}));
    return response.data;
  }

  static Future<String> cancelVip() async {
    var response = await http.post('/app/order/stripe/member/cancelVip', queryParameters: ({}));
    return response.data;
  }
}
