import 'package:flutter/material.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/views.dart';

class FilterWidget extends StatefulWidget {
  final Function(Map)? fun;

  const FilterWidget({Key? key, this.fun}) : super(key: key);
  @override
  _FilterWidgetState createState() => _FilterWidgetState();

  static Future<dynamic> show({Function(Map)? fun}) {
    return showSheet(builder: (_) {
      return FilterWidget(fun: fun);
    });
  }
}

class _FilterWidgetState extends State<FilterWidget> {
  var list = [
    'Gender',
    'Platform',
    'Game LV',
    'Position',
    'Number of orders received',
    'Number of fans',
    'Score',
  ];

  var seleValue;

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.column([
        PWidget.text('Screen', [Colors.white, 20, true], {'ff': 'DIN'}),
        PWidget.boxh(8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: List.generate(list.length, (i) {
            var data = list[i];
            var isDy = seleValue == data;
            return PWidget.container(
              PWidget.text(data, [Colors.white, 16]),
              {
                if (isDy) 'gd': PFun.cl2crGd(Color(0xff841FC3), Color(0xffFC3C02)),
                'pd': PFun.lg(4, 4, 28, 28),
                'br': 56,
                'fun': () {
                  setState(() {
                    seleValue = data;
                    widget.fun!({'value': seleValue});
                  });
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
