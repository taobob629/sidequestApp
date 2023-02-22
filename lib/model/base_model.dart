/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
abstract class BaseModel {
  Map<String, dynamic> toJson();

  fromJson(Map<String, dynamic> json);
}
class A extends BaseModel{
  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}

