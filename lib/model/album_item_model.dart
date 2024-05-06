class AlbumItemModel {
  String id = "";
  int uid = 0;
  String thumb = "";
  int status = 0;
  int addtime = 0;
  int background = 0;

  AlbumItemModel({
    this.id = "",
    this.uid = 0,
    this.thumb = "",
    this.status = 0,
    this.addtime = 0,
    this.background = 0,
  });

  AlbumItemModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    uid = json["uid"] ?? 0;
    thumb = json["thumb"] ?? "";
    status = json["status"] ?? 0;
    addtime = json["addtime"] ?? 0;
    background = json["background"] ?? 0;
  }
}
