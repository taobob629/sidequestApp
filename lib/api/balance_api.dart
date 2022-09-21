import 'package:wy/api/wy_http.dart';
import 'package:wy/model/coin_charge_rule_model.dart';
import 'package:wy/model/balance_record_model.dart';

class BalanceApi {

  static Future<List<ConsumeRecordModel>> chargeRecords(int pageNum, int pageSize) async {
    var response = await http.get('/app/balance/chargeRecords',
      queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    if(response.data == null){
      return [];
    }
    List<ConsumeRecordModel> list = response.data
      .map<ConsumeRecordModel>((item) => ConsumeRecordModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<ConsumeRecordModel>> machineRecords(int pageNum, int pageSize) async {
    var response = await http.get('/app/consume/machineRecords',
      queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    if(response.data == null){
      return [];
    }
    List<ConsumeRecordModel> list = response.data
      .map<ConsumeRecordModel>((item) => ConsumeRecordModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<ConsumeRecordModel>> consumeRecords(int pageNum, int pageSize) async {
    var response = await http.get('/app/consume/consumeRecords',
      queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    if(response.data == null){
      return [];
    }
    List<ConsumeRecordModel> list = response.data
      .map<ConsumeRecordModel>((item) => ConsumeRecordModel.fromJson(item))
      .toList();
    return list;
  }

  /**
   * 金币和金额充值规则
   */
  static Future<List<CoinChargeRuleModel>> chargeRule() async {
    var response = await http.get('/peiwan/app/home/chargeRule');
    if (response.data == null) {
      return [];
    }
    List<CoinChargeRuleModel> list = response.data['pw_charge_rules']
        .map<CoinChargeRuleModel>((item) => CoinChargeRuleModel.fromJson(item))
        .toList();
    return list;
  }
}
