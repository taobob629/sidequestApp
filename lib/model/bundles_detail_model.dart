class BundlesDetailModel {
  String? brief;
  String? image;
  String price;
  String originalPrice;
  List<String> stores;
  String? name;
  String? introduce;
  List<Voucher>? vouchers;
  int? saleOnApp;

  BundlesDetailModel({
    this.brief,
    this.image,
    required this.price,
    required this.originalPrice,
    required this.stores,
    this.name,
    this.introduce,
    this.vouchers,
    this.saleOnApp,
  });

  factory BundlesDetailModel.fromJson(Map<String, dynamic> json) => BundlesDetailModel(
    brief: json["brief"],
    image: json["image"],
    price: json["price"] ?? "0",
    originalPrice: json["originalPrice"] ?? "0",
    stores: json["stores"] == null ? [] : List<String>.from(json["stores"]!.map((x) => x)),
    vouchers: json["vouchers"] == null ? [] : List<Voucher>.from(json["vouchers"]!.map((x) => Voucher.fromJson(x))),
    name: json["name"],
    introduce: json["introduce"],
    saleOnApp: json["saleOnApp"],
  );
}

class Voucher {
  String? name;
  String? disc;

  Voucher({
    this.name,
    this.disc,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
    name: json["name"],
    disc: json["disc"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "disc": disc,
  };
}