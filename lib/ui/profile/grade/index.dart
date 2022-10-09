/*
  index
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:wy/ui/profile/grade/controller.dart';
import 'package:wy/widget/arc_progressbar_widget.dart';
import 'package:wy/widget/paixs_widget.dart';

class GradePage extends GetView<GradeController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Medal', style: TextStyle(fontSize: 18)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 230,
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                scale: 1.6,
                                fit: BoxFit.scaleDown,
                                image: AssetImage(
                                    'assets/images/grade/baron.webp'),
                              ),
                            ),
                            width: 212,
                            child: ArcProgressBar(
                              progress: 80,
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Spacer(),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/grade/v_grade1.webp'),
                                    height: 32,
                                  ),
                                  Spacer(),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/grade/v_grade2.webp'),
                                    height: 32,
                                  ),
                                  Spacer()
                                ],
                              )),
                          Positioned(
                              left: 10,
                              right: 10,
                              bottom: 25,
                              child: Center(
                                child: PWidget.text('LEVEL',
                                    [Colors.white, 18, true], {'ff': 'DIN'}),
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            PWidget.boxh(40),
            PWidget.text(
                'Current level', [Colors.white, 18, true], {'ff': 'DIN'}),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildScoreItem('recharge'),
                buildScoreItem('consumption')
              ],
            ),
            nextLevelButton(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildScoreItem('recharge'),
                buildScoreItem('consumption')
              ],
            )
          ],
        ),
      );

  buildScoreItem(var title) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PWidget.boxh(16),
        PWidget.text(
            'Monthly $title', [Color.fromRGBO(255, 255, 255, 0.65), 14, true]),
        PWidget.boxh(8),
        PWidget.text('£ 5000', [Colors.white, 30, true], {'ff': 'DIN'}),
        PWidget.boxh(10),
      ],
    ));
  }

  nextLevelButton() {
    return Column(
      children: [
        Image(
          image: AssetImage('assets/images/grade/arrow_down.webp'),
          height: 22,
        ),
        PWidget.boxh(22),
        PWidget.text('Next Level', [Colors.white, 18, true], {'ff': 'DIN'})
      ],
    );
  }
}
