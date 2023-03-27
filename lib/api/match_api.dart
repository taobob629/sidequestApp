import 'package:wy/api/wy_http.dart';

import '../model/match_init_model.dart';
import '../model/send_match_model.dart';

class MatchApi {

  static Future<MatchInitModel> selfOrder() async {
    var response = await http.get('/peiwan/app/selfOrder/init');
    return MatchInitModel.fromJson(response.data);
  }

  static Future<SendMatchModel> sendMatch(Map params) async {
    var response = await http.post('/peiwan/app/selfOrder/match', data: params);
    return SendMatchModel.fromJson(response.data);
  }
}
