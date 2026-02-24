/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as dio;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/common/base_controller.dart';
import 'package:sq_hub_app/common/refresh_interface.dart';

import '../api/network_method.dart';
import '../api/wy_http.dart';
import 'http_interface.dart';
const int DEFAULT_PAGE = 1;
const int DEFAULT_PAGE_SIZE = 10;

abstract class RefreshListController<T> extends BasePageController implements ListHttpRequest, RefreshListener {
  int page = DEFAULT_PAGE;
  int pageSize = DEFAULT_PAGE_SIZE;
  bool isRefresh = false;
  RxList<T> mDatas = RxList<T>();
  bool _isRefresh = false;

  late RefreshController _refreshController;

  RefreshController get refreshController => _refreshController;

  set refreshController(RefreshController value) {
    _refreshController = value;
  }

  /**
   * 默认自动加载列表数据
   */
  needAutoLoadData() => true;

  @override
  void onInit() {
    super.onInit();
    if (!needAutoLoadData()) return;
    initData();
  }

  void initData() {
    _isRefresh = false;
    page = DEFAULT_PAGE;
    request();
  }

//是否需要分页
  bool paged();

  void loadFinish(result) {}

  void request() {

    var url = buildUrl();
    var method = buildMethodType();
    var params = buildParams();
    if (paged()) {
      params['pageNum'] = "$page";
      params['pageSize'] = '$pageSize';
      if (url.contains("?")) {
        url = '$url&pageNum=$page&pageSize=$pageSize';
      } else {
        url = '$url?pageNum=$page&pageSize=$pageSize';
      }
    }
    http
        .request(url,
            options: Options(method: NWMethodValues[method]),
            data: params,
            queryParameters: params)
        .then((res) {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
      if (_isRefresh) {
        mDatas.clear();
      }
      List<T> newList = [];
      if (res.data == null) return [];
      //  return response.data.map<GameUserModel>((item) => GameUserModel.fromJson(item)).toList();
      if (res.data != null) {
        newList = dealData(res);
        mDatas.addAll(newList);
      }
      loadFinish(res);
      if (mDatas.isBlank == true) {
        pageState = PageState.empty;
        return pageState;
      }
      pageState = PageState.sucess;
      if (paged()) {
        var hasMore = newList.length >= pageSize;
        if (!hasMore) {
          refreshController.loadNoData();
        }
      }
    }).catchError((e) {
      pageState = PageState.empty;
      buildEmpty();
    });
  }

  @override
  void onRefresh() {
    _isRefresh = true;
    page = DEFAULT_PAGE;
    if (page == 0) {
      refreshController.requestRefresh();
    }
    request();
  }

  @override
  void onLoadMore() {
    _isRefresh = false;
    page++;
    request();
  }

  List<T> dealData(dio.Response response);

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }
}
