import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app_general_bloc/handel_android_app.dart';

class UrlWebViewPage extends StatefulWidget {
  UrlWebViewPage({super.key, required this.urlPage,required this.titleAppBer});

  String? urlPage;
  String? titleAppBer;

  @override
  State<UrlWebViewPage> createState() => _UrlWebViewPageState();
}

class _UrlWebViewPageState extends State<UrlWebViewPage> {
  late WebViewController controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              this.progress = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              this.progress = 1;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print(error.toString());
          },
        ),
      );
    loadUrl(widget.urlPage!);
  }

  void loadUrl(String url) {
    controller.loadRequest(Uri.parse(url));
  }
  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar:  appBarNormalWithIcon( text:  widget.titleAppBer.toString(),context: context,isShowBack: true),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            if (progress < 1)
              LinearProgressIndicator(
                value: progress, // استخدام قيمة _progress كقيمة LinearProgressIndicator
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            Expanded(
                flex: 3,
                child: WebViewWidget(controller: controller),),
          ],
        ),
      ),
    );

  }
}
