/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/network_method.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/model/game_section.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:wy/utils/utils.dart';
import 'package:dio/src/response.dart' as dio;

class ActivityListController extends RefreshListController<GameUserModel> {
  @override
  buildMethodType() {
    return NWMethod.GET;
  }

  @override
  Map<String, dynamic> buildParams() => {};

  @override
  String buildUrl() {
    return '/peiwan/app/new/superlist?pageNum=$page&pageSize=$pageSize';
  }

  @override
  bool paged() => true;

  @override
  List<GameUserModel> dealData(dio.Response<dynamic> response) {
    return response.data.map<GameUserModel>((item) => GameUserModel.fromJson(item)).toList();
  }

  @override
  needAutoLoadData() => true;
}
