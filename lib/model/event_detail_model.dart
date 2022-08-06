import 'package:wy/config/app_config.dart';
import 'package:wy/model/participant_model.dart';
import 'package:wy/model/selector_item.dart';

class EventDetailModel {
  late int id = 0;
  late String image = "";
  late String constraint = "";
  late String formation = "";
  late String checkinTime = "";
  late String title = "";
  late bool? team;
  late int totalMembers = 0;
  late String gameName = "";
  late String prizes = "";
  late String startTime = "";
  late bool canJoin = false;
  late String generalInfo = "";
  late List<ParticipantModel> participants = [];
  late String rules = "";
  late String equipment = "";
  late List<LocationModel> location = [];
  late String listImage = "";
  late double fee = 0.0;

  EventDetailModel() {
    this.team = null;
  }

  EventDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkinTime = json['checkinTime'] ?? '';
    constraint = json['constraint'] ?? '';
    formation = json['Formation'] ?? '';
    title = json['title'];
    team = json['team'];
    totalMembers = json['totalMembers'] ?? 0;
    fee = json['fee'] == null ? 0.0 : json['fee'];
    gameName = json['gameName'] == null ? "No data" : json['gameName'];
    prizes = json['prizes'] == null ? "No data" : json['prizes'];
    startTime = json['startTime'] == null ? "No data" : json['startTime'];
    canJoin = json['canJoin'];
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    listImage = json['listImage'] == null ? "" : json['listImage'];
    generalInfo = json['generalInfo'] == null ? "No data" : json['generalInfo'];
    rules = json['rules'] == null ? "No data" : json['rules'];
    equipment = json['equipment'] == null ? "-" : json['equipment'];
    participants = json['participants'] == null ? [] : json['participants'].map<ParticipantModel>((item) => ParticipantModel.fromJson(item)).toList();
    location = json['location'].map<LocationModel>((item) => LocationModel.fromJson(item)).toList();
  }

  String getLocationList() {
    return location.join("\n");
  }
}

class LocationModel extends SelectorItem {
  late int id = 0;
  late int join = 0;
  late int total = 0;
  late String name = "";
  late bool full = false;

  LocationModel();

  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    join = json['join'] ?? 0;
    total = json['total'] ?? 0;
    name = json['name'];
    full = json['full'];
  }

  @override
  String displayLabel() {
    return name;
  }

  @override
  bool selectable() {
    return !full;
  }

  @override
  String toString() {
    return name;
  }
}
