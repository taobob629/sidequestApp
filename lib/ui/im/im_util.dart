import 'package:get/get.dart';

import '../../model/play_item_model.dart';

var actions = [
  AcitionModel('', 'Share to User'.tr, 0),
  AcitionModel('', 'Create Post'.tr, 1),
  // AcitionModel('', 'Join Room'.tr, 2),
];

var gidPrefix = 'SiqdequestGid';
RegExp exp = RegExp(r'SiqdequestGid=([^]*?)=');

buildShareGroupText(var content, var gid) {
  return '$content $gidPrefix=$gid=';
}

decodeGroupGid(var content) {
  RegExpMatch? match = exp.firstMatch(content);
  var gid = match?.group(1) ?? '';
  return gid;
}

buildShareQr(var gid) {}
