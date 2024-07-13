import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class NewsText extends StatelessWidget {
  final String content;

  NewsText(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
      child: Platform.isAndroid
          ? Html(
              data: content,
              style: {"body": Style()},
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, dom.Element? element) async {
                if (url != null) {
                  await launchUrl(Uri.parse(url));
                }
              },
            )
          : HtmlWidget(
              content,
              onTapUrl: (url) async => await launchUrl(Uri.parse(url)),
            ),
    );
  }
}
