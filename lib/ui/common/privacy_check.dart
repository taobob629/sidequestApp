import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/web_page.dart';

class PrivacyCheck extends StatelessWidget {

  final _controller = Get.put(_PrivacyCheckController());

  late final PrivacyCheckController controller;
  PrivacyCheck({required PrivacyCheckController controller}){
    this.controller = controller;
    this.controller._c = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.offsetAnim,
      builder: (context, child){
        return Transform.translate(
          offset: Offset(_controller.offsetAnim.value, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    child: Obx(()=>Checkbox(
                      activeColor: AppColor.accent,
                      value: _controller.check.value,
                      onChanged: (v)=> _controller.check.value = v!
                    )),
                  ),
                  Text("By checking this means you agree to our",style: TextStyle(color: Colors.white,fontSize: 14),)
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 50,),
                  GestureDetector(
                    onTap: ()=> Get.to(()=>WebPage(
                      title: "Terms and Conditions",
                      url: "https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/WebsiteTeamsAndConditions-28.8.2021-final.pdf",
                    )),
                    child: Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        color: Color(0xFF2856FF),
                        fontSize: 14,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                  Text(" & ",style: TextStyle(color: Colors.white,fontSize: 14),),
                  GestureDetector(
                    onTap: ()=> Get.to(()=>WebPage(
                      title: "Privacy Policy",
                      url: "https://sidequesthub.com/static/pdfjs/web/viewer.html?file=/static/policy/SideQuest-Privacy-Policy.pdf",
                    )),
                    child: Text("Privacy Policy",
                      style: TextStyle(
                        color: Color(0xFF2856FF),
                        fontSize: 14,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class PrivacyCheckController {
  late _PrivacyCheckController? _c;

  bool check(){
    if(_c != null) {
      if (_c!.check.value == false) {
        _c?.shake();
      }
      return _c!.check.value;
    }
    return false;
  }

  void dispose(){
    _c = null;
  }
}

class _PrivacyCheckController extends GetxController with GetSingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<double> offsetAnim;
  var check = false.obs;

  @override
  void onInit(){
    super.onInit();
    animationController = AnimationController(duration: Duration(milliseconds: 250),vsync: this);

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
      if(animationController.isCompleted){
        animationController.reset();
      }
    });
  }

  @override
  void onClose(){
    animationController.dispose();
    super.onClose();
  }

  void shake(){
    animationController.forward();
  }
}