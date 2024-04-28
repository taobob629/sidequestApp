/**
    author:mac
    创建日期:2023/2/24
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/views.dart';
import 'base_controller.dart';
import 'empty_view.dart';

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
