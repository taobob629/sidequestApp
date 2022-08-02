
class StoreModel {
  late String image;
  late String name;
  late String openingTime;
  late String contact;
  late String address;

  StoreModel();

  StoreModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    openingTime = json['openingTime'];
    contact = json['contact'];
    image = json['image'];
    address = json['address'];
  }
}