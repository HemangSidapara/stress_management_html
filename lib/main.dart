import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/WebViewService':
            return GetPageRoute(
              page: () => const WebViewService(),
            );

          default:
            return GetPageRoute(
              page: () => Scaffold(
                body: Center(
                  child: Text('No path for ${settings.name}'),
                ),
              ),
            );
        }
      },
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              await Get.toNamed('/WebViewService');
            },
            child: const Text('Open WebView'),
          ),
        ),
      ),
    );
  }
}

class WebViewService extends StatefulWidget {
  const WebViewService({Key? key}) : super(key: key);

  @override
  State<WebViewService> createState() => _WebViewServiceState();
}

class _WebViewServiceState extends State<WebViewService> {

  WebViewPlusController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WebPage View'),
        backgroundColor: Colors.black,
      ),
      body: Builder(builder: (BuildContext context) {
        return WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'assets/Stress_Management/story.html',
          onWebViewCreated: (controller) async {
            this.controller = controller;
            // controller.loadUrl('assets/Stress_Management/story.html');
            // loadLocalHtml();
          },
          userAgent: 'text/Application',
          debuggingEnabled: true,
          gestureNavigationEnabled: true,
          onPageStarted: (url) {
            print('PageUrl :::: $url');
          },
        );
      }),
    );
  }

  void loadLocalHtml() async {
    final html = await rootBundle.loadString('assets/Stress_Management/story.html');

    final url = Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    controller?.loadUrl(url);
  }
}
