import 'package:flutter/material.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

class SuccessPage extends StatefulWidget {
  final String? title;
  final List<String> content;
  final Widget? child;

  const SuccessPage({Key? key, this.title, this.content = const [], this.child}) : super(key: key);
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text(widget.title!, style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.only(top: 56),
      ),
    );
  }

  List<Widget> get item {
    return [
      PWidget.image(
        'assets/images/play/cg.png',
        [pmSize.width / 2.5, pmSize.width / 2.5],
      ),
      PWidget.boxh(20),
      PWidget.text(widget.content[0], [Colors.white, 24, true], {'ct': true, 'ff': 'DIN'}),
      PWidget.boxh(16),
      PWidget.text(widget.content[1], [Color(0xffcccccc)], {'ct': true, 'ali': 2}),
      PWidget.boxh(16),
      if (widget.child != null) widget.child!,
    ];
  }
}
