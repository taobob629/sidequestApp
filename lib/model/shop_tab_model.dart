
class ShopTabModel {
  late int id;
  late String name;

  ShopTabModel();

  ShopTabModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

}