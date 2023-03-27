import 'package:get/get.dart';

class SideKickMatchSucController extends GetxController {
  var sideKickTypes = [
    'Lengends',
    'Male',
    'Male',
    'Male',
    'Male',
  ];

  var showOrHide = false.obs;

  var selectItemList = <int>[].obs;

  void showOrHideWidget() {
    showOrHide.value = !showOrHide.value;
  }

  void selectItem(int i) {
    if (selectItemList.contains(i)) {
      selectItemList.remove(i);
    } else {
      selectItemList.add(i);
    }
  }
}
