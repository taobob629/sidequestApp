/**
    author:mac
    创建日期:2021/11/12
    描述:
 */

abstract class ListHttpRequest {
  Map<String, dynamic> buildParams();

  String buildUrl();

  buildMethodType();
}
