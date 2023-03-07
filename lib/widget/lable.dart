/*
  lable
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wy/res/styles.dart';

class LableWidget extends StatelessWidget {
  String label;

  LableWidget({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        label,
        style: PageStyle.labelStyle,
      ),
    );
  }
}
