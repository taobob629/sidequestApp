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
            Stack(children: [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      ArcProgressBar(
                        progress: 50,
                        width: 200,
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Icon(Icons.access_alarm,size: 132,)),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image(image: AssetImage('assets/images/grade/grade1.webp'),height: 32,),
                              Image(image: AssetImage('assets/images/grade/v_grade1.webp'),height: 32,),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            )],),
            PWidget.boxh(40),
            PWidget.text('Current level',[Colors.white, 18, true], {'ff': 'DIN'})
          ],
        ),
      );
}
