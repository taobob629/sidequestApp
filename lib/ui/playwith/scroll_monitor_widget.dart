import 'package:flutter/material.dart';

class ScrollMonitorWidget extends StatefulWidget {
  final Widget Function(double)? builder;
  final ScrollController? controller;

  const ScrollMonitorWidget({Key? key, this.builder, this.controller}) : super(key: key);
  @override
  _ScrollMonitorWidgetState createState() => _ScrollMonitorWidgetState();
}

class _ScrollMonitorWidgetState extends State<ScrollMonitorWidget> {
  double offset = 0.0;

  @override
  void initState() {
    widget.controller!.addListener(() => setState(() => offset = widget.controller!.offset));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(offset);
  }
}
