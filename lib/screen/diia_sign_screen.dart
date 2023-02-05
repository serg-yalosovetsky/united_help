import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../services/debug_print.dart';

class WebViewDiia extends StatefulWidget {
  const WebViewDiia({super.key});

  @override
  State<WebViewDiia> createState() => _WebViewDiiaState();
}

launch (String url) async {
  dPrint('url launcher $url start');
  await launchUrl(Uri.parse(url));
  if (await canLaunchUrl(Uri.parse(url))) {
    dPrint('url launcher $url can');
    await launch(url);
    dPrint('url launcher $url finish');
  }
  dPrint('url launcher $url finally');
}

class _WebViewDiiaState extends State<WebViewDiia> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    //   ..loadRequest(Uri.parse('https://google.com'))
      ..loadRequest(Uri.parse('https://ca.diia.gov.ua/sign'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://m.youtube')) {
            // if (request.url.startsWith('https://diia.app/')) {
            //   launch(request.url);
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}