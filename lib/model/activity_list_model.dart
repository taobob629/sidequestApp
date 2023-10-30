import 'package:wy/model/safe_convert.dart';

class ActivityListModel {
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/IMG_20230123_103239_582.jpg
  final String image;
  final String company;

  // 0302@2179
  final String unique;
  final String label;

  // 731
  final int id;

  // 12:00 11-03-2023
  final String time;
  final int datetime;
  final int showCountdown;
  final int matchDiff;

  showCounter() {
    return showCountdown == 1 &&
        DateTime.now().millisecondsSinceEpoch < datetime * 1000; //已经过期了
  }

  // Photocard Trading Event
  final String title;
  final List<ParticipantsItem> participants;

  ActivityListModel({
    this.image = "",
    this.company = "",
    this.unique = "",
    this.label = "",
    this.id = 0,
    this.time = "",
    this.title = "",
    this.datetime = 0,
    this.showCountdown = 0, //0不显示 1显示倒计时
    this.matchDiff = 0,
    required this.participants,
  });

  List<ParticipantsItem> showParticipants() {
    if (participants.isEmpty) return [];
    if (participants.length <= 3) return participants;
    return participants.sublist(0, 3);
  }

  factory ActivityListModel.fromJson(Map<String, dynamic>? json) =>
      ActivityListModel(
        image: asT<String>(json, 'image'),
        company: asT<String>(json, 'company'),
        unique: asT<String>(json, 'unique'),
        label: asT<String>(json, 'label'),
        id: asT<int>(json, 'id'),
        showCountdown: asT<int>(json, 'showCountdown'),
        matchDiff: asT<int>(json, 'matchDiff'),
        time: asT<String>(json, 'time'),
        title: asT<String>(json, 'title'),
        datetime: asT<int>(json, 'datetime'),
        participants: asT<List>(json, 'participants')
            .map((e) => ParticipantsItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'company': company,
        'unique': unique,
        'label': label,
        'id': id,
        'datetime': datetime,
        'time': time,
        'showCountdown': showCountdown,
        'matchDiff': matchDiff,
        'title': title,
        'participants': participants.map((e) => e.toJson()).toList(),
      };
}

class ParticipantsItem {
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/MemberAvatar/members/5.jpg
  final String photo;

  ParticipantsItem({
    this.photo = "",
  });

  factory ParticipantsItem.fromJson(Map<String, dynamic>? json) =>
      ParticipantsItem(
        photo: asT<String>(json, 'photo'),
      );

  Map<String, dynamic> toJson() => {
        'photo': photo,
      };
}
