import 'package:wy/model/safe_convert.dart';

class OrderDetailModel {
  // 1
  final int amount;
  List<CommentsModel> history = [];
  final EnvaluateModel? comments;

  // PA20230321167586
  final String orderSn;

  final String userAvatar;

  final String skillThumb;

  // 青柠
  final String nickName;

  // 0
  final int discount;

  // Naraka：Bladepoint
  final String skillName;

  // Hour
  final String unit;

  // 60
  final int total;

  // naraka
  final String serviceItemName;

  // UK2022635757
  final String uk;

  // 65926
  final int pwId;

  // 60
  final int price;

  // 60
  final int subtotal;

  // Mar 21,2023 04:51 PM
  final String time;

  // 2
  final int status;

  OrderDetailModel({
    this.comments,
    required this.history,
    this.amount = 0,
    this.skillThumb = '',
    this.userAvatar = '',
    this.orderSn = "",
    this.nickName = "",
    this.discount = 0,
    this.skillName = "",
    this.unit = "",
    this.total = 0,
    this.serviceItemName = "",
    this.uk = "",
    this.pwId = 0,
    this.price = 0,
    this.subtotal = 0,
    this.time = "",
    this.status = 0,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
        amount: asT<int>(json, 'amount'),
        orderSn: asT<String>(json, 'orderSn'),
        skillThumb: asT<String>(json, 'skillThumb'),
        userAvatar: asT<String>(json, 'userAvatar'),
        nickName: asT<String>(json, 'nickName'),
        discount: asT<int>(json, 'discount'),
        skillName: asT<String>(json, 'skillName'),
        unit: asT<String>(json, 'unit'),
        total: asT<int>(json, 'total'),
        serviceItemName: asT<String>(json, 'serviceItemName'),
        uk: asT<String>(json, 'uk'),
        pwId: asT<int>(json, 'pwId'),
        price: asT<int>(json, 'price'),
        subtotal: asT<int>(json, 'subtotal'),
        time: asT<String>(json, 'time'),
        status: asT<int>(json, 'status'),
        history: asT<List>(json, 'history').map((e) => CommentsModel.fromJson(e)).toList(),
        comments:json['comments']!=null? EnvaluateModel.fromJson(asT<Map<String, dynamic>>(json, 'comments')):null,
      );

  Map<String, dynamic> toJson() => {
        'history': history,
        'amount': amount,
        'orderSn': orderSn,
        'nickName': nickName,
        'discount': discount,
        'skillName': skillName,
        'unit': unit,
        'total': total,
        'serviceItemName': serviceItemName,
        'uk': uk,
        'pwId': pwId,
        'price': price,
        'subtotal': subtotal,
        'time': time,
        'status': status,
      };
}

class CommentsModel {
  // Mar 23,2023 12:50 PM
  final String time;

  // bob-prod2 accept the order!
  final String content;

  CommentsModel({
    this.time = "",
    this.content = "",
  });

  factory CommentsModel.fromJson(Map<String, dynamic>? json) => CommentsModel(
        time: asT<String>(json, 'time'),
        content: asT<String>(json, 'content'),
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'content': content,
      };
}

class EnvaluateModel {
  // 933
  final int id;

  // 29049
  final int uid;

  // 2
  final int liveuid;

  // 9
  final int skillid;

  // 1432
  final int orderid;

  // eeeeddd
  final String content;

  // 4.0
  final double star;
  final String label;

  // 1679578103
  final int addtime;

  // 4
  final double performance;

  // 4
  final double responsive;

  // 4
  final double enjoyment;

  // 4
  final double friendless;

  // 🐸🐸🐶
  final String nickName;

  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1666015473587.jpg
  final String userAvatar;

  EnvaluateModel({
    this.id = 0,
    this.uid = 0,
    this.liveuid = 0,
    this.skillid = 0,
    this.orderid = 0,
    this.content = "",
    this.star = 0.0,
    this.label = "",
    this.addtime = 0,
    this.performance = 0,
    this.responsive = 0,
    this.enjoyment = 0,
    this.friendless = 0,
    this.nickName = "",
    this.userAvatar = "",
  });

  factory EnvaluateModel.fromJson(Map<String, dynamic>? json) => EnvaluateModel(
        id: asT<int>(json, 'id'),
        uid: asT<int>(json, 'uid'),
        liveuid: asT<int>(json, 'liveuid'),
        skillid: asT<int>(json, 'skillid'),
        orderid: asT<int>(json, 'orderid'),
        content: asT<String>(json, 'content'),
        star: asT<double>(json, 'star'),
        label: asT<String>(json, 'label'),
        addtime: asT<int>(json, 'addtime'),
        performance: asT<double>(json, 'performance'),
        responsive: asT<double>(json, 'responsive'),
        enjoyment: asT<double>(json, 'enjoyment'),
        friendless: asT<double>(json, 'friendless'),
        nickName: asT<String>(json, 'nickName'),
        userAvatar: asT<String>(json, 'userAvatar'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'liveuid': liveuid,
        'skillid': skillid,
        'orderid': orderid,
        'content': content,
        'star': star,
        'label': label,
        'addtime': addtime,
        'performance': performance,
        'responsive': responsive,
        'enjoyment': enjoyment,
        'friendless': friendless,
        'nickName': nickName,
        'userAvatar': userAvatar,
      };
}
