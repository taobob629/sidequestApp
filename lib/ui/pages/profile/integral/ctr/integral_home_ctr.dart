import 'package:csslib/parser.dart';
import 'package:date_format/date_format.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../image_utils.dart';
import '../../../../../model/integral_checkin_model.dart';
import '../../../../../model/integral_info_model.dart';
import '../../../../../model/integral_task_model.dart';
import '../../../../../utils/toast_utils.dart';
import '../../../../../utils/utils.dart';

class IntegralHomeCtr extends GetxController {
  var integralInfoModel =
      IntegralInfoModel(appSign: [], lvList: [], webSign: []).obs;
  var integralTaskList = <IntegralTaskModel>[].obs;
  var goods = [].obs;
  var isLoading = true.obs;

  // 签到点击的是app还是store
  var isAppTab = true.obs;

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

  void requestData() async {
    showLoading();
    final responseList = await Future.wait([
      http.get('/app/point/info'),
      http.get('/app/point/task/list',
          queryParameters: {"taskFrequency": taskFrequency}),
      http.get('/app/point/pointGoods'),
    ]);

    dismissLoading();
    isLoading.value = false;
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
    showLoading();
    final response = await http.post('/app/point/sign',
        data: {"signType": isAppTab.value ? "1" : "2"});
    dismissLoading();
    requestData();
    flog("zengchao = ${response.data}");
    if (response.data == true) {
      showToast('Sign in successfully');
    }
  }

  String getCheckInIcon(Sign? model) {
    if (model?.day == null) return "";

    // 解析 "dd/MM" 格式的日期字符串
    List<String> parts = model!.day.split('/');
    int dayOfMonth = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    DateTime givenDate = DateTime(DateTime.now().year, month, dayOfMonth);

    // 0未签到 1已签到 2待签到
    int chaDay = DateTime.now().difference(givenDate).inHours;

    if (model.state == 1) {
      // 已经签到的用绿色
      return ImageUtils.integral_checkin_green_icon;
    } else if (model.state == 0 && chaDay > 0) {
      // 过期未签到的用灰色
      return ImageUtils.integral_checkin_grey_icon;
    }
    return ImageUtils.integral_checkin_icon;
  }

  bool isSameDay(String dateString) {
    // 获取今天的日期
    DateTime today = DateTime.now();
    String todayFormatted = formatDate(today, [dd, '/', mm]);

    return dateString == todayFormatted;
  }
}
