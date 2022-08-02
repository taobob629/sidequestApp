
import 'selector_item.dart';

class Shire implements SelectorItem{
  late String countryCode;
  late String name;

  @override
  String displayLabel(){
    return name;
  }

  @override
  bool selectable(){
    return true;
  }

  @override
  String displayInfo(){
    return "";
  }

  Shire.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    data['name'] = this.name;
    return data;
  }
}