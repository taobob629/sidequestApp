import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/web_page.dart';

const int TYPE_LOGIN = 0;
const int TYPE_ADD_GAME = 1;
const int TYPE_ADD_BANK = 2;

class PrivacyCheck extends StatelessWidget {
  final _controller = Get.put(_PrivacyCheckController());
  List<PrivacyInfo> privacyList = [];
  late final PrivacyCheckController controller;
  WrapAlignment wrapAlignment;

  PrivacyCheck(
      {required PrivacyCheckController controller,
      int type = TYPE_LOGIN,
      this.privacyList = const [],
      this.wrapAlignment = WrapAlignment.start}) {
    this.controller = controller;
    this.controller._c = _controller;
    switch (type) {
      case TYPE_LOGIN:
        privacyList = [
          PrivacyInfo('Terms and Conditions'.tr,
              'https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/WebsiteTeamsAndConditions-28.8.2021-final.pdf'),
          PrivacyInfo('', ''),
          PrivacyInfo('Privacy Policy'.tr,
              'https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/SideQuest-Privacy-Policy.pdf'),
          PrivacyInfo('', ''),
          PrivacyInfo('SideKick Policy'.tr,
              'https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/SideKick-Policies.pdf'),
        ];
        break;
      case TYPE_ADD_GAME:
        privacyList = [
          PrivacyInfo('User Agreement'.tr,
              'https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/User_Agreement.pdf'),
        ];
        break;
      case TYPE_ADD_BANK:
        privacyList = [
          PrivacyInfo('Seller Payment Terms'.tr,
              'https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/Seller_Payment_Terms.pdf'),
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.offsetAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_controller.offsetAnim.value, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: SizedBox(
                  width: 24,
                  child: Obx(() => Checkbox(
                      activeColor: AppColor.accent,
                      value: _controller.check.value,
                      onChanged: (v) => _controller.check.value = v!)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    alignment: wrapAlignment,
                    runSpacing: 5,
                    children: buildPrivacyItem(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildPrivacyItem() {
    List<Widget> items = [];
    items.add(Text(
      "By checking this means you agree to our".tr,
      style: TextStyle(color: Colors.white, fontSize: 14),
    ));
    var privacyItems = privacyList.map((item) {
      if (item.url.isEmpty) {
        return Text(
          " & ",
          style: TextStyle(color: Colors.white, fontSize: 14),
        );
      } else {
        return GestureDetector(
          onTap: () => Get.to(() => WebPage(
                title: item.title,
                url: item.url,
              )),
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF2856FF), fontSize: 14, decoration: TextDecoration.underline),
          ),
        );
      }
    }).toList();
    items.addAll(privacyItems);
    return items;
  }
}

class PrivacyInfo {
  String title;
  String url;

  PrivacyInfo(this.title, this.url);
}

class PrivacyCheckController {
  late _PrivacyCheckController? _c;

  bool check() {
    if (_c != null) {
      if (_c!.check.value == false) {
        _c?.shake();
      }
      return _c!.check.value;
    }
    return false;
  }

  void dispose() {
    _c = null;
  }
}

class _PrivacyCheckController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> offsetAnim;
  var check = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(duration: Duration(milliseconds: 250), vsync: this);

    offsetAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 3),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 4),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 6),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 7),
    ]).animate(animationController);

    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.reset();
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void shake() {
    animationController.forward();
  }
}
