// ignore_for_file: deprecated_member_use, unnecessary_null_comparison
import 'dart:convert';
import 'dart:developer' as f;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';
import 'package:wy/config/app_config.dart';

/// 调起拨号页
void launchTelURL(phone) async {
  String url = 'tel:' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    EasyLoading.showToast("Dialing failed!");
    // showToast('拨号失败！', position: StyledToastPosition.center);
  }
}

///退出当前路由栈
close([map]) async {
  return Navigator.pop(context!, map);
}

// /// 调起系统
// void lunTelURL(String type, {String msg: '分享失败！'}) async {
//   if (await canLaunch(type)) {
//     await launch(type);
//   } else {
//     showToast(msg);
//   }
// }

///去除滑动水波纹
bool handleGlowNotification(OverscrollIndicatorNotification notification) {
  if ((notification.leading && true) || (!notification.leading && true)) {
    notification.disallowIndicator();
    return true;
  }
  return false;
}

// md5 加密
String generateMd5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

///时间转换
String toTime(date, [bool isParse = true]) {
  DateTime old;
  if (isParse)
    old = DateTime.parse(date);
  else
    old = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (old == null) return '-';
  var minute = 1000 * 60; //把分，时，天，周，半个月，一个月用毫秒表示
  var hour = minute * 60;
  var day = hour * 24;
  var week = day * 7;
  var month = day * 30;
  var now = DateTime.now().millisecondsSinceEpoch; //获取当前时间毫秒
  var diffValue = now - old.millisecondsSinceEpoch; //时间差
  if (diffValue < 0) return "刚刚";
  var result = '';
  var minC = diffValue ~/ minute; //计算时间差的分，时，天，周，月
  var hourC = diffValue ~/ hour;

  // ignore: unused_local_variable
  var dayC = diffValue ~/ day;
  // ignore: unused_local_variable
  var weekC = diffValue ~/ week;
  // ignore: unused_local_variable
  var monthC = diffValue ~/ month;
  // if (monthC >= 1 && monthC <= 3) {
  //   result = "${monthC.toInt()}月前";
  // } else if (weekC >= 1 && weekC <= 4) {
  //   result = "${weekC.toInt()}周前";
  // } else if (dayC >= 1 && dayC <= 6) {
  //   result = "${dayC.toInt()}天前";
  // } else
  if (hourC >= 1 && hourC <= 23) {
    result = "${hourC.toInt()}小时前";
  } else if (minC >= 1 && minC <= 59) {
    result = "${minC.toInt()}分钟前";
  } else if (diffValue >= 0 && diffValue <= minute) {
    result = "刚刚";
  } else {
    var y = old.year.toString().padLeft(4, '0');
    var m = old.month.toString().padLeft(2, '0');
    var d = old.day.toString().padLeft(2, '0');

    var s = old.hour.toString().padLeft(2, '0');
    var f = old.minute.toString().padLeft(2, '0');

    result = '$y-$m-$d\t$s:$f';
  }
  return result;
}

///获取当前时间戳
int getTime() => DateTime.now().millisecondsSinceEpoch;

// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
var context = AppConfig.navigatorKey.currentState?.overlay?.context;

///间隔日
int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
  if (ignoreTime) {
    int v = a.millisecondsSinceEpoch ~/ 86400000 - b.millisecondsSinceEpoch ~/ 86400000;
    if (v < 0) return -v;
    return v;
  } else {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ 86400000;
  }
}

void flog(v, [String? name]) => f.log(v.toString(), name: name ?? 'flog');

///是否移动端
bool get isMobile {
  if (kIsWeb) {
    if (MediaQuery.of(context!).size.aspectRatio <= 1 || MediaQuery.of(context!).size.width <= 500) {
      return true;
    } else {
      return false;
    }
  } else if (Platform.isAndroid || Platform.isIOS) {
    return true;
    // } else if (MediaQuery.of(context).size.aspectRatio <= 1 || MediaQuery.of(context).size.width <= 500) {
    //   return true;
  } else {
    return false;
  }
}

///是否深色模式
bool get isDark => (MediaQuery.platformBrightnessOf(context!) == Brightness.dark);

int get isDarkIndex => isDark ? 0 : 1;

void mapFlog(data, i, {bool isSort = true}) {
  // return;
  // ignore: dead_code
  var map = data as Map;
  List<dynamic> keys = map.keys.toList();
  if (isSort) {
    keys.sort((a, b) {
      List<int> al = a.codeUnits;
      List<int> bl = b.codeUnits;
      for (int i = 0; i < al.length; i++) {
        if (bl.length <= i) return 1;
        if (al[i] > bl[i]) {
          return 1;
        } else if (al[i] < bl[i]) return -1;
      }
      return 0;
    });
  }
  var treeMap = Map();
  flog('map排序并输出===========================================');
  flog('{', '$i');
  keys.forEach((element) => treeMap[element] = map[element]);
  treeMap.forEach((f, v) => flog(' $f : $v,', '$i'));
  flog('}', '$i');
  flog('======================================================');
}
