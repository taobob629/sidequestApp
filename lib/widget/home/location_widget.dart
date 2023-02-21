/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationWidget extends StatelessWidget {
  var distance;

  LocationWidget(this.distance);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on,
          color: Colors.yellow,
          size: 10,
        ),
        3.horizontalSpace,
        Container(
          constraints: BoxConstraints(maxWidth: 100),
          child: Text(
            '${distance == 0 ? '<100' : distance}km',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
