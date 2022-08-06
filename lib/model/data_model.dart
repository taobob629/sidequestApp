// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:dio/dio.dart';

import '../utils/utils.dart';

class DataModel<T> {
  ///数据与页面交互的标记
  ///
  ///0：初始化
  ///
  ///1：出现异常
  ///
  ///2：数据集是空
  ///
  ///其他：成功拿到数据
  int flag;

  ///异常的错误信息
  String msg;

  ///数据分页
  int page;

  ///是否有下一页
  bool hasNext;

  ///页面上的各类值的集合
  List<dynamic> value = <dynamic>[];

  ///列表的数据集
  List<T> list = <T>[];

  ///对象
  T? object;

  bool isRef;

  ///错误状态处理
  void toError([String v = 'Please check the network settings', bool isLine = true]) {
    this.flag = this.list.isEmpty ? 1 : -1;
    if (isLine) {
      this.msg = v;
    } else {
      this.msg = v + '\n';
    }
  }

  ///刷新
  void setTime() => this.flag = DateTime.now().millisecondsSinceEpoch;

  ///初始化数据模型
  void init([v]) {
    this.page = 1;
    this.list.clear();
    // this.object = v ?? {};
    this.hasNext = false;
    this.flag = 0;
  }

  ///添加list集合数据
  void addListModel(dynamic data, bool isRef) {
    if (isRef) this.page = 1;
    if (isRef) this.list.clear();
    list.addAll(data['result']['data']);
    this.msg = 'Request succeeded';
    this.addPage(data['result']['totalRows']);
  }

  ///添加list集合数据
  void addList(dynamic data, bool isRef, total) {
    if (isRef) this.page = 1;
    if (isRef) this.list.clear();
    list.addAll(data);
    this.msg = 'Request succeeded';
    this.addPage(total);
  }

  ///分页状态处理
  void addPage([dynamic data]) {
    try {
      this.hasNext = this.page * 10 < data;
      this.flag = this.list.isEmpty ? (this.page == 1 ? 2 : -2) : DateTime.now().millisecondsSinceEpoch;
      if (this.hasNext) this.page++;
    } catch (e) {}
  }

  ///添加Objiect数据
  void addObject(data) {
    this.object = data;
    this.setTime();
  }

  ///打印数据
  void toLog() => flog(json.encode(this.toJson()));

  DataModel({
    this.isRef = false,
    this.flag = 0,
    this.value = const <dynamic>[0],
    this.msg = 'Request succeeded',
    this.page = 1,
    this.hasNext = true,
    this.object,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["flag"] = flag;
    data["msg"] = msg;
    data["page"] = page;
    data["hasNext"] = hasNext;
    if (value != null) {
      var v = value;
      var arr0 = [];
      v.forEach((v) => arr0.add(v));
      data["value"] = arr0;
    }
    if (list != null) {
      var v = list;
      var arr0 = [];
      v.forEach((v) => arr0.add(v));
      data["list"] = arr0;
    }
    data["object"] = object;
    return data;
  }
}
