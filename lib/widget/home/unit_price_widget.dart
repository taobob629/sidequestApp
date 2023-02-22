import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/utils/index.dart';

/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
class UnitPriceWidget extends StatelessWidget {
  var price;

  UnitPriceWidget({@required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageUtil.assetImage('ic_balance_money', width: 15.w, height: 15.w),
        5.horizontalSpace,
        Text(
          '$price',
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
