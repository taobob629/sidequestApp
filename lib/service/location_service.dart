/*
  location_service
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
// 工厂方法构造函数 - 通过UserModel()获取对象1
  factory LocationService() => _getInstance();

  // instance的getter方法 - 通过UserModel.instance获取对象2
  static LocationService get instance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static LocationService? _instance;

  // 获取唯一对象
  static LocationService _getInstance() {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  //初始化...
  LocationService._internal() {}
  Position? position;
  StreamSubscription<Position>? positionStream;

  init() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition();
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? pos) {
      position = pos;
    });
 //   flog('position${position}');
  }

  dispose() {
    positionStream?.cancel();
  }
}
