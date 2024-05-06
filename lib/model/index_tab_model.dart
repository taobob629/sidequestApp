class IndexTabModel {
  late String name;
  late int sort;

  IndexTabModel();

  IndexTabModel.fromJson(Map<String, dynamic> json) {
    name = json["name"] ?? "";
    sort = json["sort"] ?? 1;
  }
}
