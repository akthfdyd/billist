import 'package:arc/arc.dart';
import 'package:billist/presentation/screen/home_mixin.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeMixin logic;

  HomeScreen(this.logic, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeMixin logic;

  WebViewController webviewController = WebViewController();

  @override
  void initState() {
    logic = widget.logic;
    Arc();
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
                height: 100,
                child: WebViewWidget(
                  controller: webviewController,
                ),
              ),
              logic.text.ui(builder: (context, json) {
                return Text(
                  '${json.data}',
                  style: const TextStyle(fontSize: 5),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
