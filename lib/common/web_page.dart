import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/toast_utils.dart';
import '../utils/storage_manager.dart';

class WebPage extends StatefulWidget {
  final String? title;
  final String? url;
  
  WebPage({required this.title, required this.url});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            String cookie = '''
              document.cookie = 'X-Wanyoo-Token=${StorageManager.getToken()};samesite=None; secure=true;language=${Get.locale?.languageCode}';
            ''';
            _controller.runJavaScript(cookie);
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse("${widget.url}?X-Wanyoo-Token=${StorageManager.getToken()}&samesite=None&secure=true&language=${Get.locale?.languageCode}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.back(),
              child: Container(
                width: 30.w,
                height: 30.w,
                margin: EdgeInsets.only(left: 15.w),
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: const OvalBorder(),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WebPageController extends GetxController {
  late WebViewController webViewController;
  
  WebPageController({required String? url}) {
    if (url != null) {
      webViewController = WebViewController();
    }
  }
  
  void setWebViewController(WebViewController controller) {
    webViewController = controller;
  }
  
  void dismissLoading() {
    // Placeholder for dismiss loading logic
  }
}