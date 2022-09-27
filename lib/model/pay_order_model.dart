
class PayOrderModel {
  // 订单类型 -1购买商品 0网吧账户充值  >=5 开会员 -2陪玩支付 2陪玩账户充值
  late int type = 0;
  // 地址id
  late int addressId = 0;
  // 商品总价格 充值金额
  late String goodsPrice = "0";
  // 快递费用
  late String freightPrice = "0";
  // 税费
  late String tax = "0";
  // 优惠券费用
  late String couponPrice = "0";
  // 优惠券码
  late String couponCode = "";
  // 支付方式 1 卡(visa、master) 2 余额/陪玩金币  3 微信 4 支付宝
  late int payType = 1;
  // 商品快照
  late String orderShot = "";
  // 购买的会员时长 0 月 1 年
  late int phrase = 0;
  //优惠券ID
  late int couponId = 0;
  late int chargeid = 0;//金币兑换规则id

  //陪玩使用
  late int svctm = 0;
  late String liveuid = "";
  late String skillid = "";
  late int nums = 1;
  late String des = "";

  late String totalAmount = "0";

  @override
  String toString() {
    return 'PayOrderModel{type: $type, addressId: $addressId, goodsPrice: $goodsPrice, freightPrice: $freightPrice, tax: $tax, couponPrice: $couponPrice, couponCode: $couponCode, payType: $payType, orderShot: $orderShot, phrase: $phrase, couponId: $couponId, chargeid: $chargeid, svctm: $svctm, liveuid: $liveuid, skillid: $skillid, nums: $nums, des: $des, totalAmount: $totalAmount}';
  }
}

class OrderPriceModel {
  late String deliveryFee = "0";
  late String discount = "0";
  late String total = "0";
  late String tax = "0";

  OrderPriceModel();

  OrderPriceModel.fromJson(Map<String, dynamic> json) {
    deliveryFee = json["deliveryFee"];
    discount = json["discount"];
    total = json["total"];
    tax = json["tax"];
  }
}