import 'package:arc/arc.dart';
import 'package:billist/presentation/screen/home_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeScreen extends StatefulWidget {
  HomeMixin logic;

  HomeScreen(this.logic, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeMixin logic;

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      useWideViewPort: true,
      userAgent:
          'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0',
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  @override
  void initState() {
    logic = widget.logic;

    Arc();
    // Arc.useProxy = true;
    // Arc.proxyAddress = '172.20.31.150:8888';

    super.initState();
    logic.getBillList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 500,
                child: InAppWebView(
                  key: webViewKey,
                  // webViewEnvironment: webViewEnvironment,
                  initialUrlRequest:
                      URLRequest(url: WebUri('https://flutter.dev')),
                  // initialUrlRequest:
                  // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
                  // initialFile: "assets/index.html",
                  // initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialSettings: settings,
                  // contextMenu: contextMenu,
                  // pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                    logic.webViewController = controller;
                  },
                  onLoadStart: (controller, url) async {},
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {},
                  onReceivedError: (controller, request, error) {},
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {}
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {},
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
              ),
              Container(height: 20),
              logic.text.ui(builder: (context, json) {
                return Text(
                  '${json.data}',
                  style: const TextStyle(fontSize: 5),
                );
              }),
              Container(height: 20),
              // InkWell(
              //     onTap: () {
              //       logic.runJavaScript('print.postMessage("hello");');
              //       logic.runJavaScript('getResult();');
              //     },
              //     child: Container(
              //       width: double.infinity,
              //       height: 40,
              //       child: Center(child: Text('run')),
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
