import 'package:flutter/material.dart';
import 'package:wy/config/icon_font.dart';

class EmptyView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(IconFonts.empty, size: 100, color: Colors.white10,),
    );
  }
}