import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../utils/toast_utils.dart';
import 'action_button.dart';
import 'base_scaffold.dart';

class WebPage extends StatelessWidget {
  final String? title;
  final String? url;
  late final WebPageController webPageController;

  WebPage({required this.title, required this.url}){
    webPageController = Get.put(WebPageController(url: url));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "$title",
      actions: [
        ActionButton(
          icon: Icon(Icons.refresh,color: Colors.white,),
          onTap: (){
            dismissLoading();
            showLoading();
            webPageController.webViewController.reload();
            },
        )
      ],
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          webPageController.setWebViewController(webViewController);
        },
        onPageStarted: (url){
          dismissLoading();
        },
        onPageFinished: (url) {
          dismissLoading();
          String cookie = '''
            document.cookie = 'X-Wanyoo-Token=${StorageManager.getToken()}';
          ''';
          webPageController.webViewController.runJavascript(cookie);
        },
        onWebResourceError: (error){
          dismissLoading();
        },
      ),
    );
  }
}

class WebPageController extends GetxController{
  final String? url;
  late WebViewController webViewController;
  WebPageController({required this.url});

  void setWebViewController(WebViewController webViewController){
    this.webViewController = webViewController;
  }

  @override
  void onReady() {
    super.onReady();
    showLoading();
  }
}
