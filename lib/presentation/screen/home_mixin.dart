import 'package:arc/arc_subject.dart';
import 'package:billist/data/bill_list_get_vo.dart';
import 'package:webview_flutter/webview_flutter.dart';

mixin HomeMixin {
  var text = ''.sbj;

  List<String> resultList = [];
  int totalSize = 0;
  int progress = 0;
  late List<Data> dataList;

  late WebViewController webViewController;

  getBillList() {}

  makeSearchKeyword(BillListGetVO responseModel) {}

  setWebView() {}

  searchKeyword() async {}

  addAndCheckSearchFinished(String searchResult) {}

  makeResultText() {}
}
