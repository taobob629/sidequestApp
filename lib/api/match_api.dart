import 'package:wy/api/wy_http.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';

import '../model/match/match_operation_model.dart';
import '../model/match/match_play_model.dart';
import '../model/match_init_model.dart';
import '../model/send_match_model.dart';

class MatchApi {
  static Future<MatchInitModel> selfOrder() async {
    var response = await http.get('/peiwan/app/selfOrder/init');
    return MatchInitModel.fromJson(response.data);
  }

  static Future<int> sendMatch(Map params) async {
    var response = await http.post('/peiwan/app/selfOrder/match', data: params);
    return response.data;
  }

  static Future<dynamic> acceptMatchOrder(
      String id, Map<String, dynamic> params) async {
    var response = await http.get('/peiwan/app/selfOrder/acceptMatchOrder/$id',
        queryParameters: params);
    return response;
  }

  static Future<dynamic> stopMatch(int id) async {
    var response = await http.get('/peiwan/app/selfOrder/stopMatch/$id');
    return response;
  }

  static Future<dynamic> cancelAcceptMatchOrder(
      String id, bool? ifPlayer) async {
    var response;
    if (ifPlayer == true) {
      // 接单人取消
      response = await http.get(
        '/peiwan/app/selfOrder/cancelAcceptMatchOrder/$id',
      );
    } else {
      // 老板取消
      response = await http.get(
        '/peiwan/app/selfOrder/cancelMatch/$id',
      );
    }
    return response;
  }

  static Future<MatchPlayModel?> playGame(List<Map<String, int>> params) async {
    var response = await http.post('/peiwan/app/new/orders/preMulitOrder',
        data: {"preOrdersBos": params});
    return MatchPlayModel.fromJson(response.data);
  }
}
