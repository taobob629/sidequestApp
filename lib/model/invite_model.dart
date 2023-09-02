class InviteModel {
  int? diamond;
  int? nvited;
  int? orderNum;
  String? rule;
  int? sidekicker;
  String? url;
  String? image;
  int? coin;

  InviteModel({
    this.diamond,
    this.nvited,
    this.orderNum,
    this.rule,
    this.sidekicker,
    this.url,
    this.image,
    this.coin,
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) => InviteModel(
    diamond: json["diamond"],
    nvited: json["nvited"],
    orderNum: json["orderNum"],
    rule: json["rule"],
    sidekicker: json["sidekicker"],
    url: json["url"],
    image: json["image"],
    coin: json["coin"],
  );

  Map<String, dynamic> toJson() => {
    "diamond": diamond,
    "nvited": nvited,
    "orderNum": orderNum,
    "rule": rule,
    "sidekicker": sidekicker,
    "url": url,
    "image": image,
    "coin": coin,
  };
}
