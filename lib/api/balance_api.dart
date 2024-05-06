import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

import '../model/balance_record_model.dart';
import '../model/bank_card_model.dart';
import '../model/chage_rule_model.dart';
import '../model/coin_records_model.dart';
import '../model/withdraw_record_model.dart';

class BalanceApi {

  static Future<List<ConsumeRecordModel>> chargeRecords(int pageNum, int pageSize) async {
    var response = await http.get('/peiwan/app/consume/chargeRecords',
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
    var response = await http.get('/peiwan/app/consume/gaming',
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
    var response = await http.get('/peiwan/app/consume/consumeRecords',
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
  static Future<void> addBankCard(Map<String, dynamic> params,{bool isEdit=false}) async{
    var response=  await http.post(isEdit?'/peiwan/app/card/editCard':'/peiwan/app/card/addCard',
        data: params
    );
  }

  //获取银行卡列表
  static Future<List<BankCardModel>> getBankList() async {
    var response = await http.get('/peiwan/app/card/list');
    List<BankCardModel> list =
        response.data.map<BankCardModel>((item) => BankCardModel.fromJson(item)).toList();
    return list;
  }

  //获取银行卡根据id
  static Future<BankCardModel> getBankByCardId(int cardId) async {
    var response = await http.get('/peiwan/app/card/info/$cardId');
    BankCardModel model = BankCardModel.fromJson(response.data["card"]);
    return model;
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
  static Future<List<WithdrawRecordModel>> withDrawRecords(
      int pageNum, int pageSize) async {
    var response = await http.get('/peiwan/app/cash/pwWithDrawalRecord',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return [];
    }
    List<WithdrawRecordModel> list = response.data
        .map<WithdrawRecordModel>((item) => WithdrawRecordModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<CoinRecordsModel>> coinAndVotesRecords(
      int pageNum, int pageSize, String type) async {
    var response = await http.get('/peiwan/app/order/list/record',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize, 'type': type}));
    if (response.data == null) {
      return [];
    }
    List<CoinRecordsModel> list = response.data
        .map<CoinRecordsModel>((item) => CoinRecordsModel.fromJson(item)).toList();
    return list;
  }

  static Future<Response> exchangeToCoin(var amount) async {
    Response response =
        await http.post('/peiwan/app/withDrawal/voteToCoin', queryParameters: ({'amount': amount}));
    return response;
  }

  static Future<List<SimpleBankModel>> getBanks(var country) async {
    Response response = await http.get(
      '/peiwan/app/card/banks/$country',
    );
    if (response.data == null) return [];
    return response.data.map<SimpleBankModel>((item) => SimpleBankModel.fromJson(item)).toList();
  }
}
