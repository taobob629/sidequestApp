import 'package:wy/api/wy_http.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/model/chage_rule_model.dart';
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

  /*
   * 金币和金额充值规则
   */
  static Future<ChargeRuleModel> chargeRule() async {
    var response = await http.get('/peiwan/app/home/chargeRule');
    return ChargeRuleModel.fromJson(response.data);
  }
  //添加银行卡
  static Future<void> addBankCard(Map<String, dynamic> params) async{
    var response=  await http.post('/peiwan/app/card/addCard',
        data: params
    );
  }

  //获取银行卡列表
  static Future<List<BankCardModel>> getBankList() async{
    var response=  await http.get('/peiwan/app/card/list');
    List<BankCardModel> list = response.data
        .map<BankCardModel>((item) => BankCardModel.fromJson(item))
        .toList();
    return list;
  }
  static Future<void> unbindBankCard(var id) async {
    var response=  await http.get('/peiwan/app/card/delete/$id');
  }
  /*
  提现
   */
  static Future<void> withDraw(Map<String,dynamic> params) async {
    var response=  await http.post('/peiwan/app/withDrawal/order',data: params);
  }
}
