import 'package:wy/api/wy_http.dart';

import '../model/match/match_operation_model.dart';
import '../model/match/match_play_model.dart';

class MatchApi {
  static Future<dynamic> selfOrder() async {
    var response = await http.get('/peiwan/app/selfOrder/init');
    return response.data;
  }

  static Future<int> sendMatch(Map params) async {
    var response = await http.post('/peiwan/app/selfOrder/match', data: params);
    return response.data;
  }

  static Future<List<MatchOperationModel>?> acceptMatchOrder(
      String id, Map<String, dynamic> params) async {
    var response = await http.get('/peiwan/app/selfOrder/acceptMatchOrder/$id',
        queryParameters: params);

    if (response.data == null) {
      return null;
    }
    List<MatchOperationModel> list = response.data
        .map<MatchOperationModel>((item) => MatchOperationModel.fromJson(item))
        .toList();

    return list;
  }

  static Future<dynamic> stopMatch(int id) async {
    var response = await http.get('/peiwan/app/selfOrder/stopMatch/$id');
    return response;
  }

  static Future<dynamic> cancelAcceptMatchOrder(
      String id, bool? ifPlayer) async {
    var response;
    if (ifPlayer == false) {
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
