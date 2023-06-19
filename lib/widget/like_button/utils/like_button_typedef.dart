import 'package:flutter/material.dart';

typedef LikeButtonTapCallback = Future<bool?> Function(bool isLiked);

typedef LikeWidgetBuilder = Widget? Function(bool isLiked);

typedef LikeCountWidgetBuilder = Widget? Function(
  int? likeCount,
  bool isLiked,
  String text,
);

enum LikeCountAnimationType {
  none,
  part,
  all,
}

enum CountPostion {
  left,
  right,
  top,
  bottom,
}

typedef CountDecoration = Widget? Function(
  Widget count,
  int? likeCount,
);
