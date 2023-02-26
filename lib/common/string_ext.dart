import 'package:date_format/date_format.dart';

extension StringExt on String {
  ///首字母大写
  String get toCapitalize {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }

  ///转换为正常时间
  String get toDateStr {
    try {
      return formatDate(DateTime.parse(this), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
    } catch (e) {
      return "";
    }
  }
}
