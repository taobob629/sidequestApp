class TabNewsModel {
  List<TabNewsListElement> list;
  List<Headline> headline;

  TabNewsModel({
    required this.list,
    required this.headline,
  });

  factory TabNewsModel.fromJson(Map<String, dynamic> json) => TabNewsModel(
    list: json["list"] == null ? [] : List<TabNewsListElement>.from(json["list"]!.map((x) => TabNewsListElement.fromJson(x))),
    headline: json["headline"] == null ? [] : List<Headline>.from(json["headline"]!.map((x) => Headline.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "headline": List<dynamic>.from(headline.map((x) => x.toJson())),
  };
}

class Headline {
  int id;
  String? title;
  dynamic author;
  dynamic content;
  dynamic type;
  String? image;
  int? sort;
  dynamic isShow;
  String? createTime;
  int? isHeadline;
  String? appImage;
  String? appImageList;
  String? webBackground;
  String? brief;

  Headline({
    required this.id,
    this.title,
    this.author,
    this.content,
    this.type,
    this.image,
    this.sort,
    this.isShow,
    this.createTime,
    this.isHeadline,
    this.appImage,
    this.appImageList,
    this.webBackground,
    this.brief,
  });

  factory Headline.fromJson(Map<String, dynamic> json) => Headline(
    id: json["id"] ?? 0,
    title: json["title"],
    author: json["author"],
    content: json["content"],
    type: json["type"],
    image: json["image"],
    sort: json["sort"],
    isShow: json["isShow"],
    createTime: json["createTime"],
    isHeadline: json["isHeadline"],
    appImage: json["appImage"],
    appImageList: json["appImageList"],
    webBackground: json["webBackground"],
    brief: json["brief"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "content": content,
    "type": type,
    "image": image,
    "sort": sort,
    "isShow": isShow,
    "createTime": createTime,
    "isHeadline": isHeadline,
    "appImage": appImage,
    "appImageList": appImageList,
    "webBackground": webBackground,
    "brief": brief,
  };
}

class TabNewsListElement {
  int? addtime;
  int id;
  String? time;
  String? title;
  List<String> imageList;

  TabNewsListElement({
    this.addtime,
    required this.id,
    this.time,
    this.title,
    required this.imageList,
  });

  factory TabNewsListElement.fromJson(Map<String, dynamic> json) => TabNewsListElement(
    addtime: json["addtime"],
    id: json["id"] ?? 0,
    time: json["time"],
    title: json["title"],
    imageList: json["imageList"] == null ? [] : List<String>.from(json["imageList"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "addtime": addtime,
    "id": id,
    "time": time,
    "title": title,
    "imageList": List<dynamic>.from(imageList.map((x) => x)),
  };
}
