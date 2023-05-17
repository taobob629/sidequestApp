import 'package:wy/model/cybercafe_detail_model.dart';
import 'package:wy/model/selector_item.dart';

class BookingModel {
  late int id = 0;
  late int storeId = 0;
  late String store = "";
  late int areaId = 0;
  late String area = "";
  late int people = 0;
  late int duration = 0;
  late int time = 0;
  late bool done = false;
  late String phone = "";
  late String timeString = "";

  BookingModel();

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['storeId'] == null ? 0 : json['storeId'];
    areaId = json['areaId'] == null ? 0 : json['areaId'];
    store = json['store'] == null ? "" : json['store'];
    area = json['area'] == null ? "" : json['area'];
    phone = json['phone'] == null ? "" : json['phone'];
    people = json['people'] == null ? 0 : json['people'];
    duration = json['duration'] == null ? 0 : json['duration'];
    time = json['time'] == null ? 0 : json['time'];
    done = json['done'] == null ? false : json['done'];
    timeString = json['timeString'] == null ? "" : json['timeString'];
  }
}

class StoreModel {
  late int id = 0;
  late String name = "";
  late String address = "";
  late String telephone = "";
  late String openTime = "";

  StoreModel();

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
    address = json['address'] == null ? "" : json['address'];
    telephone = json['telephone'] == null ? "" : json['telephone'];
    openTime = json['openTime'] == null ? "" : json['openTime'];
  }

  DateTime getStart() {
    List<String> times = openTime.trim().split("-");
    if (times.length > 0) {
      String startTime = times[0].trim();
      return DateTime.parse("1970-01-01 $startTime:00");
    }
    return DateTime.parse("1970-01-01 00:00:00");
  }

  DateTime getEnd() {
    List<String> times = openTime.trim().split("-");
    if (times.length == 2) {
      String endTime = times[1].trim();
      return DateTime.parse("1970-01-01 $endTime:00");
    }
    return DateTime.parse("1970-01-01 23:59:59");
  }
}

class StoreAreaModel {
  late int id = 0;
  late String areaName = "";
  late double bookingPrice = 0.0;

  StoreAreaModel();

  StoreAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['areaName'] == null ? "" : json['areaName'];
    bookingPrice = json['bookingPrice'] == null ? 0.0 : json['bookingPrice'];
  }
}

class BookingSelectModel extends SelectorItem {
  late int id = 0;
  late String name = "";

  dynamic model;

  BookingSelectModel();

  @override
  String displayLabel() {
    return name;
  }

  @override
  String displayInfo() {
    if (model != null) {
      if (model is StoreModel) {
        StoreModel storeModel = model as StoreModel;
        return "Location: ${storeModel.address}\nBusiness Hours: ${storeModel.openTime}";
      } else if (model is StoreAreaModel) {
        StoreAreaModel areaModel = model as StoreAreaModel;
        return "Booking Deposit: £ ${areaModel.bookingPrice.toStringAsFixed(2)}";
      } else if (model is AreaVoList) {
        AreaVoList areaModel = model as AreaVoList;
        return "Booking Deposit: £ ${areaModel.bookingPrice.toStringAsFixed(2)}";
      }
    }
    return "";
  }

  @override
  bool selectable() {
    return true;
  }

  @override
  String toString() {
    return name;
  }
}
