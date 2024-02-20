import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IntegralInterestsCtr extends GetxController {
  final ScrollController scrollController = ScrollController();

  var currentVIPIndex = 0.obs;

  void changeIndex(int index) {
    currentVIPIndex.value = index;
    double itemOffset = index * 80.w;

    // Scroll to the calculated offset with smooth animation
    scrollController.animateTo(
      itemOffset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
