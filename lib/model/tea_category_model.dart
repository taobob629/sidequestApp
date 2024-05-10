import 'package:sq_hub_app/model/selector_item.dart';

class TeaCategoryModel extends SelectorItem{
  int? id;
  String? name;
  int? pid;
  String? iconUrl;
  String? picUrl;
  int? sortOrder;
  List<dynamic>? children;
  int? client;
  int? templateType;

  TeaCategoryModel({
    this.id,
    this.name,
    this.pid,
    this.iconUrl,
    this.picUrl,
    this.sortOrder,
    this.children,
    this.client,
    this.templateType,
  });

  factory TeaCategoryModel.fromJson(Map<String, dynamic> json) => TeaCategoryModel(
    id: json["id"],
    name: json["name"],
    pid: json["pid"],
    iconUrl: json["iconUrl"],
    picUrl: json["picUrl"],
    sortOrder: json["sortOrder"],
    children: json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
    client: json["client"],
    templateType: json["templateType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pid": pid,
    "iconUrl": iconUrl,
    "picUrl": picUrl,
    "sortOrder": sortOrder,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
    "client": client,
    "templateType": templateType,
  };

  @override
  String displayLabel() {
    return name ?? '';
  }

  @override
  bool selectable() {
    return true;
  }
}
