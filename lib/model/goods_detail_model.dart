class GoodsDetailModel {
  String? brief;
  String? image;
  String? price;
  List<String> cpusize;
  String? name;
  List<String> ice;
  List<String> topping;
  List<String> sugar;

  GoodsDetailModel({
    this.brief,
    this.image,
    this.price,
    required this.cpusize,
    this.name,
    required this.ice,
    required this.topping,
    required this.sugar,
  });

  factory GoodsDetailModel.fromJson(Map<String, dynamic> json) => GoodsDetailModel(
    brief: json["brief"],
    image: json["image"],
    price: json["price"],
    cpusize: json["cpusize"] == null ? [] : List<String>.from(json["cpusize"]!.map((x) => x)),
    name: json["name"],
    ice: json["ice"] == null ? [] : List<String>.from(json["ice"]!.map((x) => x)),
    topping: json["topping"] == null ? [] : List<String>.from(json["topping"]!.map((x) => x)),
    sugar: json["sugar"] == null ? [] : List<String>.from(json["sugar"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "brief": brief,
    "image": image,
    "price": price,
    "cpusize": List<dynamic>.from(cpusize.map((x) => x)),
    "name": name,
    "ice": List<dynamic>.from(ice.map((x) => x)),
    "topping": List<dynamic>.from(topping.map((x) => x)),
    "sugar": List<dynamic>.from(sugar.map((x) => x)),
  };
}
