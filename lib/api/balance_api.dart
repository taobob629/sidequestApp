import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

import '../model/chage_rule_model.dart';

class BalanceApi {

  /*
   * 金币和金额充值规则
   */
  static Future<ChargeRuleModel> chargeRule() async {
    var response = await http.get('/peiwan/app/home/chargeRule');
    return ChargeRuleModel.fromJson(response.data);
  }
  //添加银行卡
  static Future<void> addBankCard(Map<String, dynamic> params,{bool isEdit=false}) async{
    var response=  await http.post(isEdit?'/peiwan/app/card/editCard':'/peiwan/app/card/addCard',
        data: params
    );
  }

  static Future<void> unbindBankCard(var id) async {
    var response = await http.get('/peiwan/app/card/delete/$id');
  }

  /*
  提现
   */
  static Future<Response> withDraw(Map<String, dynamic> params) async {
    var response = await http.post('/peiwan/app/withDrawal/order', data: params);
    return response;
  }
  /*
  新版本提现接口
   */
  static Future<Response> withDrawOrder(Map<String, dynamic> params) async {
    var response = await http.post('/peiwan/app/withDrawal/add', data: params);
    return response;
  }

  static Future<Response> exchangeToCoin(var amount) async {
    Response response =
        await http.post('/peiwan/app/withDrawal/voteToCoin', queryParameters: ({'amount': amount}));
    return response;
  }
}
