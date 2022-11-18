/*
  location_service
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/utils/utils.dart';

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

  LocationData? _locationData;
  Location location = Location();

  init() async {
    try {
      locationData = await location.getLocation();
    } catch (e) {
      flog('getLocation err--$e');
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      flog('onLocationChanged--$currentLocation');
    });
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        flog('_serviceEnabled--$_serviceEnabled');
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      flog('_permissionGranted--$_permissionGranted');
      if (_permissionGranted != PermissionStatus.granted) {
        ConfirmDialog.show(
            Get.context!,
            "Permission required",
            "Your Location is not available, please click the button below to change current setting."
                .tr);
        return;
      }
    }
    locationData = await location.getLocation();
    flog('locationData ${locationData?.longitude}');
  }

  LocationData? get locationData => _locationData;

  set locationData(LocationData? value) {
    _locationData = value;
  }
}
