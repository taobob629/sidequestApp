import 'package:flutter/material.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/views.dart';

class FilterWidget extends StatefulWidget {
  final Function(List)? fun;
  final List list;
  final List seleList;
  final String title;

  const FilterWidget({Key? key, this.fun, this.list = const [], this.title = '', this.seleList = const []}) : super(key: key);
  @override
  _FilterWidgetState createState() => _FilterWidgetState();

  static Future<dynamic> show({String title = '', List list = const [], List seleList = const [], Function(List)? fun}) {
    return showSheet(builder: (_) {
      return FilterWidget(fun: fun, list: list, title: title, seleList: seleList);
    });
  }
}

class _FilterWidgetState extends State<FilterWidget> {
  var list = [];
  var seleValue = [];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    list.addAll(widget.list);
    seleValue.addAll(widget.seleList);
  }

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.column([
        PWidget.text(widget.title, [Colors.white, 20, true], {'ff': 'DIN'}),
        PWidget.boxh(16),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: List.generate(list.length, (i) {
            var data = list[i];
            var isDy = seleValue.contains(data);
            return PWidget.container(
              PWidget.text(data, [Colors.white, 16]),
              {
                if (isDy) 'gd': PFun.cl2crGd(Color(0xff841FC3), Color(0xffFC3C02)),
                'pd': PFun.lg(4, 4, 28, 28),
                'br': 56,
                'fun': () {
                  if (!isDy) {
                    seleValue.add(data);
                  } else {
                    seleValue.remove(data);
                  }
                  setState(() {});
                  widget.fun!(seleValue);
                },
                'bd': PFun.bdAllLg(Colors.white.withOpacity(isDy ? 0 : 1), 1),
              },
            );
          }),
        ),
      ], '000'),
      [null, null, Color(0xff3B3860)],
      {'pd': 16, 'br': PFun.lg(16, 16)},
    );
  }
}
