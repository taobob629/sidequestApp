class PayType {
  static const BUY_GOODS = -1; //购买商品
  static const WB = 0; //网吧账户充值
  static const PW_RECHARGE = -2; //陪玩支付
  static const PAY_GIFTS = -3; //送礼物
  static const PW_STRIP_ACCOUNT = 2; //陪玩账户充值
  static const PW_ALIPAY_ACCOUNT = 3; //陪玩金币账户充值
}

class PayOrderModel {
  // 订单类型 -1购买商品 0网吧账户充值  >=5 开会员 -2陪玩支付 2陪玩账户充值 -3打赏/送礼物
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
  late int chargeid = 0; //金币兑换规则id

  //陪玩使用
  late int svctm = 0;
  late String liveuid = "";
  late String skillid = "";
  late int nums = 1;
  late String des = "";
  late String serviceItemId = "";
  late String code = "";

  late String totalAmount = "0";

  ///送礼物 receiverId,id,postId,nums
  late String liveId = "";
  late String giftId = "";
  late String postId = "";
  late String uid = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['type'] = type;
    json['tax'] = tax;
    json['couponPrice'] = couponPrice;
    json['couponCode'] = couponCode;
    json['payType'] = payType;
    json['orderShot'] = orderShot;
    json['phrase'] = phrase;
    json['couponId'] = couponId;
    json['chargeid'] = chargeid;
    json['svctm'] = svctm;
    json['liveuid'] = liveuid;
    json['skillid'] = skillid;
    json['nums'] = nums;
    json['des'] = des;
    json['serviceItemId'] = serviceItemId;
    json['code'] = code;
    json['totalAmount'] = totalAmount;
    json['addressId'] = addressId;
    json['goodsPrice'] = goodsPrice;
    json['freightPrice'] = freightPrice;
    return json;
  }

  @override
  String toString() {
    return 'PayOrderModel{type: $type, addressId: $addressId, goodsPrice: $goodsPrice, freightPrice: $freightPrice, tax: $tax, couponPrice: $couponPrice, couponCode: $couponCode, payType: $payType, orderShot: $orderShot, phrase: $phrase, couponId: $couponId, chargeid: $chargeid, svctm: $svctm, liveuid: $liveuid, skillid: $skillid, nums: $nums, des: $des, serviceItemId: $serviceItemId, code: $code, totalAmount: $totalAmount}';
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
