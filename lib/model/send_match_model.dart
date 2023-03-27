class SendMatchModel {
  SendMatchModel({
    required this.rejects,
    required this.unit,
    required this.types,
    required this.gid,
    required this.category,
    required this.game,
    required this.createTime,
    required this.minPrice,
    required this.language,
    required this.id,
    required this.maxPrice,
    required this.pids,
  });

  List<dynamic> rejects;
  String unit;
  String types;
  int gid;
  String category;
  String game;
  String createTime;
  int minPrice;
  String language;
  int id;
  int maxPrice;
  List<dynamic> pids;

  factory SendMatchModel.fromJson(Map<String, dynamic> json) => SendMatchModel(
    rejects: List<dynamic>.from(json["rejects"].map((x) => x)),
    unit: json["unit"],
    types: json["types"],
    gid: json["gid"],
    category: json["Category"],
    game: json["Game"],
    createTime: json["createTime"],
    minPrice: json["minPrice"],
    language: json["language"],
    id: json["id"],
    maxPrice: json["maxPrice"],
    pids: List<dynamic>.from(json["pids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "rejects": List<dynamic>.from(rejects.map((x) => x)),
    "unit": unit,
    "types": types,
    "gid": gid,
    "Category": category,
    "Game": game,
    "createTime": createTime,
    "minPrice": minPrice,
    "language": language,
    "id": id,
    "maxPrice": maxPrice,
    "pids": List<dynamic>.from(pids.map((x) => x)),
  };
}
