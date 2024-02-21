import 'package:wy/api/wy_http.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/profile/coupon/coupon_page.dart';
import 'package:wy/utils/index.dart';

class CouponApi {
  static Future<List<CouponModel>> list(
      {int couponType = 0, int tab = CouponPage.TYPE_STORE}) async {
    var response = await http.get('/app/coupon/list',
        queryParameters: ({"couponType": couponType, 'tab': tab}));
    List<CouponModel> list = response.data
        .map<CouponModel>((item) => CouponModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<CouponModel>> avaList(PayOrderModel model) async {
    var formData = {
      "type": 2,
      "addressId": model.addressId,
      "goodsPrice": model.goodsPrice,
      "freightPrice": model.freightPrice,
      "tax": model.tax,
      "couponId": model.couponId,
      "couponPrice": model.couponPrice,
      "couponCode": model.couponCode,
      "payType": model.payType,
      "orderShot": model.orderShot,
      "phrase": 0,
    };
    var response = await http.post('/app/coupon/avaList', data: formData);
    List<CouponModel> list = response.data
        .map<CouponModel>((item) => CouponModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<CouponModel>> avaiPwcoupons(
      Map<String, dynamic>? preOrder) async {
    var preModel = preOrder;
    preModel?.removeWhere((key, value) => key != "preOrdersBos");

    var response =
        await http.post('/peiwan/app/new/orders/pwcoupons', data: preOrder);
    List<CouponModel> list = response.data
        .map<CouponModel>((item) => CouponModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<CouponModel>> listCoupon(int type) async {
    var response = await http.get('/app/coupon/listCoupon?couponType=$type');
    List<CouponModel> list = response.data
        .map<CouponModel>((item) => CouponModel.fromJson(
              item,
              needHourMinSec: true,
            ))
        .toList();
    return list;
  }

  static Future<String?> add(String code) async {
    var response =
        await http.get('/app/coupon/add', queryParameters: ({"code": code}));

    return response.statusMessage;
  }

  //添加陪玩优惠券
  static Future<String?> addPW(String code) async {
    var response =
        await http.get('/app/coupon/pw/add', queryParameters: ({"code": code}));

    return response.statusMessage;
  }

  //计算优惠金额
  static Future<ActivityDiscountModel?> caculateFee(
      var couponId, var matchId) async {
    var response = await http.get('/app/coupon/selectCoupon',
        queryParameters: ({"couponId": couponId, 'matchId': matchId}));
    flog('response $response');
    return ActivityDiscountModel.fromJson(response.data);
  }
}
