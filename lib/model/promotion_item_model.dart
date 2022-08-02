
class PromotionItemModel {
  late int id;
  late String title;
  late String image;
  late String content;

  PromotionItemModel();

  PromotionItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    content = json['content'];
  }
}