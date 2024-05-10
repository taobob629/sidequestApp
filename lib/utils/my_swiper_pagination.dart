import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySwiperPagination extends StatelessWidget {
  var _currentIndex;
  var lenght;

  MySwiperPagination(this._currentIndex, this.lenght);

  @override
  Widget build(BuildContext context) => Container(
        height: 10.w,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: _currentIndex == index ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          itemCount: 2,
          separatorBuilder: (context, index) => 10.horizontalSpace,
        ),
      );
}
