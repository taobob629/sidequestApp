import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/simple_user_info_model.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
class HomePageController extends GetxListController<SimpleUserInfoModel> {
  List<String> games = [
    'https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1666015473587.jpg',
    'https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1666015473587.jpg',
    'https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1666015473587.jpg'
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<List<SimpleUserInfoModel>> loadData() async {
    // String key = controller.text;
    // if (key.isEmpty) {
    //   return [];
    // }
    // showLoading();
    // List<SimpleUserInfoModel> list = await UserApi.search(key);
    // dismissLoading();
    return list;
  }
}
