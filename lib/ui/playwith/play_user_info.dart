import 'package:flutter/material.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/playwith/swiper_widget.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

class PlayUserInfo extends StatefulWidget {
  @override
  _PlayUserInfoState createState() => _PlayUserInfoState();
}

class _PlayUserInfoState extends State<PlayUserInfo> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          MyListView(
            isShuaxin: false,
            item: (i) => item[i],
            itemCount: item.length,
          ),
          PWidget.container(
            PWidget.column([
              PWidget.boxh(pmPadd.top),
              PWidget.container(
                PWidget.row([
                  GestureDetector(
                    onTap: () => close(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  PWidget.spacer(),
                  PWidget.text('Edit', [Colors.white, 16], {'pd': 4}),
                ]),
                [null, 48],
                {'pd': PFun.lg(0, 0, 8, 8)},
              ),
            ]),
          ),
        ],
      ),
    );
  }

  List<Widget> get item {
    return [
      SwiperWidget(
        imageList: ['', '', ''],
        height: 300,
      ),
    ];
  }
}
