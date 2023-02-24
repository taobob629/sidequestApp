import 'package:wy/model/safe_convert.dart';

class ActivityListModel {
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/Fight night app and website.jpg
  final String image;

  // 16
  final int totalMembers;

  // Fighting Games
  final String game;
  final List<LocationNameItem> locationName;

  // <p>N/A</p>
  final String bonus;

  // Sidequest Hub Coventry
  final String location;

  // 185
  final int id;

  // 24-02-2023 12:00(Fri)
  final String time;

  // FightNight Monday
  final String title;

  ActivityListModel({
    this.image = "",
    this.totalMembers = 0,
    this.game = "",
    required this.locationName,
    this.bonus = "",
    this.location = "",
    this.id = 0,
    this.time = "",
    this.title = "",
  });

  factory ActivityListModel.fromJson(Map<String, dynamic>? json) => ActivityListModel(
        image: asT<String>(json, 'image'),
        totalMembers: asT<int>(json, 'totalMembers'),
        game: asT<String>(json, 'game'),
        locationName:
            asT<List>(json, 'locationName').map((e) => LocationNameItem.fromJson(e)).toList(),
        bonus: asT<String>(json, 'bonus'),
        location: asT<String>(json, 'location'),
        id: asT<int>(json, 'id'),
        time: asT<String>(json, 'time'),
        title: asT<String>(json, 'title'),
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'totalMembers': totalMembers,
        'game': game,
        'locationName': locationName.map((e) => e.toJson()).toList(),
        'bonus': bonus,
        'location': location,
        'id': id,
        'time': time,
        'title': title,
      };
}

class LocationNameItem {
  // Sidequest Hub Coventry
  final String name;

  // 4
  final int id;

  LocationNameItem({
    this.name = "",
    this.id = 0,
  });

  factory LocationNameItem.fromJson(Map<String, dynamic>? json) => LocationNameItem(
        name: asT<String>(json, 'name'),
        id: asT<int>(json, 'id'),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
