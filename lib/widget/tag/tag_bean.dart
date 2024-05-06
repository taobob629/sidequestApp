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
}
