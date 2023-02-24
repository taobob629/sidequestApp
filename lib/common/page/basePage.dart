/**
    author:mac
    创建日期:2023/2/24
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/common/page/empty_view.dart';
import 'package:wy/widget/views.dart';

abstract class BasePage extends StatelessWidget {
  BasePageController pageController();

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int pageState = pageController().pageState;
      switch (pageState) {
        case PageState.empty:
          return EmptyView();
        case PageState.sucess:
          return buildBody(context);
        case PageState.initialing:
        default:
          return buildLoad();
      }
    });
  }
}
