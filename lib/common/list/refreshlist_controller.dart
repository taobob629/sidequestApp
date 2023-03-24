/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/network_method.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/common/list/refresh_interface.dart';
import 'package:wy/utils/index.dart';
import 'http_interface.dart';
import 'package:wy/api/wy_http.dart';
import 'package:dio/src/response.dart' as dio;

const int DEFAULT_PAGE = 0;
const int DEFAULT_PAGE_SIZE = 10;

abstract class RefreshListController<T> extends BasePageController
    with ListHttpRequest, RefreshListener {
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
      url='$url&pageNum=$page&pageSize=$pageSize';
    }
    if (method == NWMethod.GET) {
      params = Map();
    }
    http
        .request(url,
            options: Options(method: NWMethodValues[method]), data: params, queryParameters: params)
        .then((res) {
        refreshController?.refreshCompleted();
        refreshController?.loadComplete();
      if (_isRefresh) {
        mDatas.clear();
      }
      List<T> newList=[];
      if (res.data == null) return [];
      //  return response.data.map<GameUserModel>((item) => GameUserModel.fromJson(item)).toList();
      if (res.data != null) {
        newList=dealData(res);
        mDatas.addAll(newList);
      }
      loadFinish(res);
      if (mDatas.isBlank == true) {
        pageState = PageState.empty;
        return pageState;
      }
      pageState = PageState.sucess;
      if (paged()) {
        var hasMore = newList.length >=pageSize;
        if (!hasMore) {
          refreshController?.loadNoData();
        }
      }
    }).catchError((e) {
      pageState=PageState.empty;
      buildEmpty();
    });
  }

  @override
  void onRefresh() {
    _isRefresh = true;
    page = DEFAULT_PAGE;
    if(page==0) {
      refreshController?.requestRefresh();
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
    refreshController?.dispose();
  }
}
