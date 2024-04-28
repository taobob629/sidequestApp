import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import 'badges_widget.dart';
import 'my_profile_page.dart';

class MyDashboardPage extends StatelessWidget {
  MyDashboardPage({Key? key}) : super(key: key);

  final t = ProfileController.find;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            /// Trophies
            ...UserController.find.userProfile.badges
                .map((badge) => BadgesWidget(badge))
                .toList(),
          ],
        ));
  }
}
