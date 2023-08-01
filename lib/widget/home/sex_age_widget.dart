/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/model/game_user_model.dart';

class SexAndAgeWidget extends StatelessWidget {
  var sex;
  var age;

  SexAndAgeWidget({this.sex, this.age});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [];
    var icon;
    var text;
    switch (sex) {
      case MAN:
        colors = [Color(0xFF1F84C9), Color(0xFF7CB9D5)];
        icon = Icons.female_rounded;
        text='男';
        break;
      case WOMAN:
        colors = [Color(0xFFF351BD), Color(0xFFFF1549)];
        icon = Icons.male_rounded;
        text='女';
        break;
      default:
        colors = [Color(0xffc5c7cd), Color(0xffa1a4ab)];
        icon = Icons.question_mark;
        text='未知';
        break;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(5,2,5,2).r,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.all(Radius.circular(5).r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 8.h,
            color: Colors.white,
          ),
          3.horizontalSpace,
          Text(
            '$age',
            style: TextStyle(color: Colors.white, fontSize: 9.sp),
          )
        ],
      ),
    );
  }
}
