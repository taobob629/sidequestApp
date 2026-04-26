import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../image_utils.dart';
import '../../../../../model/integral_info_model.dart';
import '../../../../../model/integral_task_model.dart';
import '../../../../../utils/toast_utils.dart';
import '../../../../dialog/dialog_sign_success.dart';
import '../integral_detail_page.dart';
import '../integral_interests_page.dart';
import '../integral_redemption_page.dart';

class IntegralHomeCtr extends GetxController {
  static IntegralHomeCtr get find => Get.find();

  final ScrollController scrollController = ScrollController();
  final GlobalKey taskCenterKey = GlobalKey();

  var integralInfoModel =
      IntegralInfoModel(appSign: [], lvList: [], webSign: []).obs;
  var integralTaskList = <IntegralTaskModel>[].obs;
  var goods = [].obs;
  var isLoading = true.obs;

  // 签到点击的是app还是store
  var isAppTab = true.obs;

  // 当前日期的model
  Sign? todayModel;

  // 今天是否已经签到了
  bool isTodaySign = false;

  // 1：One-off,2:Daily,3:weekly,4:monthly
  int taskFrequency = 2;
  var taskCenterIndex = 0.obs;
  var showOrHideTaskCenter = false.obs;
  List<Map<String, dynamic>> taskCenterTab = [
    {"name": "Daily".tr, "value": 2},
    {"name": "Weekly".tr, "value": 3},
    {"name": "Monthly".tr, "value": 4},
    {"name": "One-Off".tr, "value": 1},
  ];

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  // 缓存积分等级配置数据
  static dynamic cachedLevelConfigData;

  void requestData() async {
    final responseList = await Future.wait([
      http.get('/app/point/info'),
      http.get('/app/point/task/list',
          queryParameters: {"taskFrequency": taskFrequency}),
      http.get('/app/point/pointGoods'),
      // 预加载积分等级配置数据，供IntegralInterestsPage使用
      http.get('/app/point/level/config'),
    ]);

    dismissLoading();
    integralInfoModel.value = IntegralInfoModel.fromJson(responseList[0].data);
    integralTaskList.value = responseList[1]
        .data
        .map<IntegralTaskModel>((item) => IntegralTaskModel.fromJson(item))
        .toList();
    Map<String, dynamic> goodsMap = responseList[2].data;
    final list = goodsMap.values.toList();
    if (list.isNotEmpty) {
      goods.value = list[0];
    }
    // 缓存积分等级配置数据
    cachedLevelConfigData = responseList[3].data;
    isLoading.value = false;
  }

  void jumpDetail(id) async {
    showLoading();
    try {
      // 关闭加载指示器
      dismissLoading();
      // 无动画导航，避免屏幕闪烁
      final result = await Get.to(() => IntegralDetailPage(), arguments: id, transition: Transition.noTransition);
      if (result != null) {
        requestData();
      }
    } catch (e) {
      print('Error navigating to detail page: $e');
      dismissLoading();
    } finally {
      requestData();
    }
  }

  void toRedemptionPage() async {
    showLoading();
    try {
      // 关闭加载指示器
      dismissLoading();
      // 无动画导航，避免屏幕闪烁
      await Get.to(() => IntegralRedemptionPage(), transition: Transition.noTransition);
    } catch (e) {
      print('Error navigating to redemption page: $e');
      dismissLoading();
    } finally {
      requestData();
    }
  }

  void toInterestsPage() async {
    showLoading();
    try {
      // 确保积分等级配置数据已缓存
      if (cachedLevelConfigData == null) {
        // 如果没有缓存，先加载数据
        final response = await http.get('/app/point/level/config');
        cachedLevelConfigData = response.data;
      }
      // 关闭加载指示器
      dismissLoading();
      // 无动画导航，避免屏幕闪烁
      final result = await Get.to(
        () => IntegralInterestsPage(),
        arguments: integralInfoModel.value.pointInfo?.expGrade,
        transition: Transition.noTransition,
      );
      if (result != null) {
        scrollToContainer();
      }
    } catch (e) {
      print('Error navigating to interests page: $e');
      dismissLoading();
    } finally {
      requestData();
    }
  }

  void scrollToContainer() {
    // 确保 taskCenterKey 已关联到 widget 树中的 RenderObject
    if (taskCenterKey.currentContext == null) return;

    // 获取 RenderBox 并检查是否为非空
    final RenderBox? renderBox =
        taskCenterKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      // 滚动到目标位置 使用 Scrollable.ensureVisible 将指定的 widget 滚动入视图
      Scrollable.ensureVisible(
        taskCenterKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectTaskCenterTab(int i) {
    showOrHideTaskCenter.value = false;
    taskCenterIndex.value = i;
    taskFrequency = taskCenterTab[i]["value"];
    requestTaskList();
  }

  void requestTaskList() async {
    showLoading();
    final response = await http.get('/app/point/task/list',
        queryParameters: {"taskFrequency": taskFrequency});
    dismissLoading();
    integralTaskList.value = response.data
        .map<IntegralTaskModel>((item) => IntegralTaskModel.fromJson(item))
        .toList();
  }

  void checkIn() async {
    if (isTodaySign) return;
    showLoading();
    final response = await http.post('/app/point/sign',
        data: {"signType": isAppTab.value ? "1" : "2"});
    dismissLoading();
    requestData();
    if (response.data == true) {
      showCustom(SignSuccessDialog(points: "${todayModel?.point} points."));
    }
  }

  String getCheckInIcon(Sign? model) {
    if (model?.day == null) return ImageUtils.integral_checkin_icon;

    // 获取当前日期
    DateTime now = DateTime.now();

    List<String> parts = model!.day.split('/');
    if (parts.length != 2) return ImageUtils.integral_checkin_icon;

    // 转换为整数
    int dayPart = int.tryParse(parts[0]) ?? 0;
    int monthPart = int.tryParse(parts[1]) ?? 0;
    if (dayPart == 0 || monthPart == 0) return ImageUtils.integral_checkin_icon;

    // 构造 DateTime 对象
    // DateTime inputDate;

    // 如果输入的月和日大于当前月和日，则认为是上一年的日期
    // if (monthPart > now.month ||
    //     (monthPart == now.month && dayPart > now.day)) {
    //   inputDate = DateTime(now.year - 1, monthPart, dayPart);
    // } else {
    //   inputDate = DateTime(now.year, monthPart, dayPart);
    // }

    // 0未签到 1已签到 2待签到
    if (model.state == 1) {
      // 已经签到的用黄色
      return ImageUtils.integral_checkin_icon;
    }
    /*else if (model.state == 0) {
      // 过期未签到的用灰色， 判断是否是今天或今天之后
      if (inputDate.isBefore(DateTime(now.year, now.month, now.day))) {
        return ImageUtils.integral_checkin_grey_icon;
      }
      return ImageUtils.integral_checkin_icon;
    }*/
    return ImageUtils.integral_checkin_grey_icon;
  }

  bool isToday(Sign model) {
    // 获取今天的日期
    DateTime today = DateTime.now();
    String todayFormatted = formatDate(today, [dd, '/', mm]);

    bool isToday = model.day == todayFormatted;
    if (isToday) {
      todayModel = model;
      if (model.state == 1) {
        isTodaySign = true;
      }
    }
    return isToday;
  }

  void upgrade() async {
    showLoading();
    final response = await http.post('/app/point/up/grade');
    dismissLoading();
    if (response.data == true) {
      showCustom(
        SignSuccessDialog(
          points: "",
          title: 'Upgrade successfully!'.tr,
          congratulations:
              'Congratulations,you have upgrade to LV.${(integralInfoModel.value.pointInfo?.expGrade ?? 0) + 1}',
        ),
      );

      requestData();
    }
  }
}
