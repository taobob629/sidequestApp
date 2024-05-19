import 'package:equatable/equatable.dart';

class TagBean extends Equatable{
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

  @override
  List<Object?> get props => [name, value];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TagBean &&
        other.name == name &&
        other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
