import 'dart:convert';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/wy_http.dart';
import '../../image_utils.dart';
import '../../model/cybercafe_detail_model.dart';
import '../../utils/toast_utils.dart';

class BookingDetailCtr extends GetxController {
  CyberCafeDetailModel? model;

  @override
  void onInit() {
    super.onInit();

    _requestData();
  }

  void _requestData() async {
    showLoading();
    var response = await http.get('/app/store/cybercafe/booking/stores/info',
        queryParameters: ({
          'id': Get.arguments as int,
        }));
    model = CyberCafeDetailModel.fromJson(response.data);
    dismissLoading();
    update();
  }

  void jumpPhoneOrMap(bool ifToPhone) async {
    if (ifToPhone) {
      Uri uri = Uri.parse('tel:${model?.telephone}');

      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
      return;
    }

    Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=37.7749,-122.4194');
    // Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  String getIconRes(String? areaName) {
    if (areaName?.toLowerCase().contains('duo') == true) {
      return ImageUtils.icon_duo_room;
    }
    if (areaName?.toLowerCase().contains('squad') == true) {
      return ImageUtils.icon_squad_room;
    }
    if (areaName?.toLowerCase().contains('battle') == true) {
      return ImageUtils.icon_battle_room;
    }
    if (areaName?.toLowerCase().contains('ps') == true) {
      return ImageUtils.icon_ps;
    }

    return ImageUtils.icon_public_area;
  }

  List<String> dealTime() {
    if (model == null) {
      return [];
    }

    List<String> timeList = jsonDecode(model!.openTime)
        .toString()
        .replaceAll(RegExp(r'[{}]'), '')
        .split(',');

    return timeList;
  }
}
