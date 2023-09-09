import 'dart:convert';

import 'package:get/get.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/model/participant_model.dart';
import 'package:wy/model/selector_item.dart';

const int TYPE_PRIZE = 6; //抽奖

class EventDetailModel {
  late int id = 0;
  late String image = "";
  late String constraint = "";
  late String formation = "";
  late int matchDiff = 0;
  late String checkinTime = "";
  late int checkin = 0;
  late int start = 0;
  late String title = "";
  late bool? team;
  late int totalMembers = 0;
  late String gameName = "";
  late List<EventPrizes> eventPrize = [];
  late String startTime = "";
  late bool canJoin = false;
  RxBool _canCancel = RxBool(false);
  late String generalInfo = "";
  late List<ParticipantModel> participants = [];
  late String rules = "";
  late String code = "";
  late String url = "";
  late String equipment = "";
  late List<LocationModel> location = [];
  late String listImage = "";
  late double fee = 0.0;
  late int participantNum = 0;
  int kopEndTime = 0;
  int kopStartTime = 0; //开始时间 结束时间
  int showCountdown = 0; //0不显示1显示
  bool get canCancel => _canCancel.value;
  RxString discount = RxString('0');
  var memberCouponId = '';

  showCounter() {
    return showCountdown == 1 &&
        DateTime.now().millisecondsSinceEpoch < kopStartTime * 1000; //已经过期了
  }

  participantes() {
    if (matchDiff == TYPE_PRIZE && participants.length == 0) {
      return '';
    }
    return '${participants.length}/${totalMembers}';
  }

  set canCancel(bool value) {
    _canCancel.value = value;
  }

  EventDetailModel() {
    this.team = null;
  }

  EventDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'] ?? 0;
    checkin = json['checkin'] ?? 0;

    checkinTime = json['checkinTime'] ?? '';
    constraint = json['constraint'] ?? '';
    formation = json['Formation'] ?? '';
    matchDiff = json['matchDiff'] ?? 0;
    showCountdown = json['showCountdown'] ?? 0;
    title = json['title'];
    team = json['team'];
    kopStartTime = json['kopStartTime'];
    kopEndTime = json['kopEndTime'];
    totalMembers = json['totalMembers'] ?? 0;
    participantNum = json['participantNum'] ?? 0;

    fee = json['fee'] == null ? 0.0 : json['fee'];
    gameName = json['gameName'] == null ? "No data" : json['gameName'];
    eventPrize = json['eventPrize'] == null
        ? []
        : json['eventPrize'].toString().contains('name')
            ? jsonDecode(json['eventPrize'])
                .map<EventPrizes>((item) => EventPrizes.fromJson(item))
                .toList()
            : [];
    startTime = json['startTime'] == null ? "No data" : json['startTime'];
    canJoin = json['canJoin'] ?? false;
    canCancel = json['canCancel'] ?? false;
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    listImage = json['listImage'] == null ? "" : json['listImage'];
    generalInfo = json['generalInfo'] == null ? "No data" : json['generalInfo'];
    rules = json['rules'] == null ? "No data" : json['rules'];
    code = json['code'] == null ? "" : json['code'];
    url = json['url'] == null ? "" : json['url'];
    equipment = json['equipment'] == null ? "-" : json['equipment'];
    participants = json['participants'] == null
        ? []
        : json['participants']
            .map<ParticipantModel>((item) => ParticipantModel.fromJson(item))
            .toList();
    location = json['location']
        .map<LocationModel>((item) => LocationModel.fromJson(item))
        .toList();
  }

  String getLocationList() {
    return location.join("\n");
  }
}

class EventPrizes {
  String name;
  String value;
  String avatar;
  String nickname;

  EventPrizes({
    required this.name,
    required this.value,
    required this.avatar,
    required this.nickname,
  });

  factory EventPrizes.fromJson(Map<String, dynamic> json) => EventPrizes(
        name: json['name'] ?? '',
        value: json['value'] ?? '',
        avatar: json['avatar'] ?? '',
        nickname: json['nickname'] ?? '',
      );
}

class LocationModel extends SelectorItem {
  late int id = 0;
  late int join = 0;
  late int total = 0;
  late String name = "";
  late bool full = false;

  LocationModel(this.id);

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
