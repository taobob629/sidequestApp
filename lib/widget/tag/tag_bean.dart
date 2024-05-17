class TagBean {
  String name;
  String value;

  TagBean({
    required this.name,
    required this.value,
  });

  factory TagBean.fromJson(Map<String, dynamic> json) => TagBean(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };

  // 深拷贝构造函数
  TagBean.deepCopy(TagBean original)
      : this.name = original.name,
        this.value = original.value;

  bool equals(TagBean? tagBean) {
    return name == tagBean?.name && value == tagBean?.value;
  }
}
