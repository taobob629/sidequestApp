import 'dart:convert';

import 'package:wy/api/wy_http.dart';
import 'package:wy/model/pay_info_model.dart';
import 'package:wy/model/pay_order_model.dart';

class PayApi {
  static Future<PayInfoModel> pay(PayOrderModel model) async {
    if(model.type == -1){
      return await _buy(model);
    }else if(model.type == 0 ||model.type==2){
      return await _charge(model);
    }else if(model.type == -2){//陪玩
      return await _play(model);
    }

    return await _openVip(model);

  }

  static Future<PayInfoModel> _charge(PayOrderModel model) async {
    var formData = {
      "type" : model.type,
      "addressId" : 0,
      "goodsPrice" : model.goodsPrice,
      "freightPrice" : "0",
      "tax" : "0",
      "couponPrice" : "0",
      "couponCode" : "",
      "payType" : model.payType,
      "orderShot" : "",
      "phrase" : 0,
      'chargeid':model.chargeid
    };
    var response = await http.post(model.payType == 1 ? '/app/order/stripe/charge' : '/app/order/charge',
      data: formData
    );

    return PayInfoModel.fromJson(response.data);
  }

  static Future<PayInfoModel> _openVip(PayOrderModel model) async {
    var formData = {
      "type" : model.type,
      "addressId" : 0,
      "goodsPrice" : model.goodsPrice,
      "freightPrice" : "0",
      "tax" : "0",
      "couponPrice" : "0",
      "couponCode" : "",
      "payType" : model.payType,
      "orderShot" : "",
      "phrase" : model.phrase,
    };
    var response = await http.post('/app/order/stripe/member',
      data: formData
    );

    return PayInfoModel.fromJson(response.data);
  }

  static Future<PayInfoModel> _buy(PayOrderModel model) async {
    var formData = {
      "type" : 2,
      "addressId" : model.addressId,
      "goodsPrice" : model.goodsPrice,
      "freightPrice" : model.freightPrice,
      "tax" : model.tax,
      "couponId" : model.couponId,
      "couponPrice" : model.couponPrice,
      "couponCode" : model.couponCode,
      "payType" : model.payType,
      "orderShot" : model.orderShot,
      "phrase" : 0,
    };
    var response = await http.post(model.payType == 1 ? '/app/order/stripe/goods' : '/app/order/goods',
      data: formData
    );

    return PayInfoModel.fromJson(response.data);
  }

  static Future<PayInfoModel> _play(PayOrderModel model) async {
    var formData = {
      "liveuid" : model.liveuid,
      "skillid" : model.skillid,
      "svctm" : model.svctm,
      "nums" : model.nums,
      "des" : model.des,
      "type" : model.payType,
      "serviceItemId":model.serviceItemId,
      "code":model.code,
      'couponId': model.couponId
    };
    var response = await http.post('/peiwan/app/order/setorder',
      data: formData
    );

    PayInfoModel payInfoModel = PayInfoModel();
    if(model.payType == 2){
      if(response.data == -1){
        payInfoModel.insufficient = true;
      }else{
        payInfoModel.insufficient = false;
        payInfoModel.orderNo = response.data;
      }
      return payInfoModel;
    }
    return PayInfoModel.fromJson(response.data);
  }

  static Future<bool> checkPassword(String password) async {
    var response = await http.get('/app/pay/checkPassword',
      queryParameters: ({"password":password})
    );
    return response.data['data'];
  }

  static Future<bool> status(int type, String orderNo) async {
    String url = '/app/order/status';
    if(type == -2){
      url = '/peiwan/app/order/status';
    }
    var response = await http.get(url,
      queryParameters: ({"orderNo":orderNo})
    );
    return response.data["status"];
  }

  static Future<String> genToken() async {
    var response = await http.get('/app/pay/auth',
      queryParameters: ({})
    );

    Map<String,dynamic> map = jsonDecode(response.data["auth"]) as Map<String,dynamic>;
    return map["clientToken"];
  }

  static Future<String> getShippingFee() async {
    var response = await http.get('/app/address/deliverFee',
      queryParameters: ({})
    );
    return response.data["deliverFee"];
  }

  static Future<OrderPriceModel> getPrice(PayOrderModel model) async {
    var formData = {
      "type" : 2,
      "addressId" : model.addressId,
      "goodsPrice" : model.goodsPrice,
      "freightPrice" : model.freightPrice,
      "tax" : model.tax,
      "couponPrice" : model.couponPrice,
      "couponCode" : model.couponCode,
      "couponId" : model.couponId,
      "payType" : model.payType,
      "orderShot" : model.orderShot,
      "phrase" : 0,
    };
    var response = await http.post('/app/order/calculate',
      data: formData
    );

    return OrderPriceModel.fromJson(response.data);
  }

  static Future<void> notifyCardPay(String orderId,String tranId) async {
    var response = await http.get('/app/pay/notify',
      queryParameters: ({"orderId":orderId,"tranId":tranId})
    );
  }

  static Future<bool> backgroundNotify(String orderId,String tranId) async {
    var response = await http.get('/app/pay/appChargeNotify',
      queryParameters: ({"orderId":orderId,"tranId":tranId})
    );
    print(response);
    if(response.data != null){
      return response.data;
    }
    return false;
  }

}