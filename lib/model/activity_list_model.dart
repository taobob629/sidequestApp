import 'package:wy/model/safe_convert.dart';

class ActivityListModel {
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/IMG_20230123_103239_582.jpg
  final String image;

  // 0302@2179
  final String unique;

  // 731
  final int id;

  // 12:00 11-03-2023
  final String time;

  // Photocard Trading Event
  final String title;
  final List<ParticipantsItem> participants;

  ActivityListModel({
    this.image = "",
    this.unique = "",
    this.id = 0,
    this.time = "",
    this.title = "",
    required this.participants,
  });

  List<ParticipantsItem> showParticipants() {
    if (participants.isEmpty) return [];
    if (participants.length <= 3) return participants;
    return participants.sublist(0, 3);
  }

  factory ActivityListModel.fromJson(Map<String, dynamic>? json) => ActivityListModel(
        image: asT<String>(json, 'image'),
        unique: asT<String>(json, 'unique'),
        id: asT<int>(json, 'id'),
        time: asT<String>(json, 'time'),
        title: asT<String>(json, 'title'),
        participants:
            asT<List>(json, 'participants').map((e) => ParticipantsItem.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'unique': unique,
        'id': id,
        'time': time,
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

  factory ParticipantsItem.fromJson(Map<String, dynamic>? json) => ParticipantsItem(
        photo: asT<String>(json, 'photo'),
      );

  Map<String, dynamic> toJson() => {
        'photo': photo,
      };
}
