class TopFoodModel {
  String? image;
  String? name;
  String? desc;
  dynamic trend;
  int? id;
  int? storeId;
  String? retailPrice;

  TopFoodModel({
    this.image,
    this.name,
    this.desc,
    this.trend,
    this.id,
    this.storeId,
    this.retailPrice,
  });

  factory TopFoodModel.fromJson(Map<String, dynamic> json) => TopFoodModel(
        image: json["image"],
        name: json["name"],
        desc: json["desc"],
        trend: json["trend"],
        id: json["id"],
        storeId: json["storeId"],
        retailPrice: json["retailPrice"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "desc": desc,
        "trend": trend,
        "id": id,
        "storeId": storeId,
        "retailPrice": retailPrice,
      };
}
