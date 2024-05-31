import 'dart:convert';

import 'package:arc/arc_request.dart';
import 'package:billist/data/bill_list_get_vo.dart';
import 'package:billist/presentation/screen/home_mixin.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeLogic with HomeMixin {
  @override
  getBillList() async {
    try {
      Response res = await AHttp.request(
        method: HttpMethod.GET,
        url:
            'https://raw.githubusercontent.com/KoreanThinker/billboard-json/main/billboard-hot-100/recent.json',
        param: {},
      );
      var responseModel = BillListGetVO.fromJson(json.decode(res.body));
      makeSearchKeyword(responseModel);
    } catch (error) {
      if (error is AHttpException) {
        text.val = error.toString();
      }
    }
  }

  @override
  makeSearchKeyword(BillListGetVO responseModel) async {
    dataList = responseModel.data ?? [];
    totalSize = dataList.length;

    searchKeyword();
  }

  @override
  setWebView() {
    String crawling = '''
       function getResult(){
         var item = document.getElementsByClassName("search_song");
         print.postMessage(item);
         var title = item[0].children[1].children[0].children[1].children[2].children[0].children[4].children[0].innerText.replace('TITLE ','');
         print.postMessage(title);
         var artist = item[0].children[1].children[0].children[1].children[2].children[0].children[4].children[1].innerText;
         print.postMessage(artist);
         
         var result = title + ' - ' + artist;
         print.postMessage(result);
         
         //geniesearch.postMessage(result);
       } 
       
       getResult();
    ''';

    webViewController.addJavaScriptChannel(
      'geniesearch',
      onMessageReceived: (JavaScriptMessage message) {
        addAndCheckSearchFinished(message.message);
      },
    );
    webViewController.addJavaScriptChannel(
      'print',
      onMessageReceived: (JavaScriptMessage message) {
        print(message.message);
      },
    );
    webViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          print(crawling);
          webViewController.runJavaScriptReturningResult(crawling);
        },
      ),
    );
  }

  @override
  searchKeyword() async {
    String artist = dataList[progress].artist ?? '';
    List<String> artistTemp = artist.split(' ');
    if (artistTemp.length > 1) {
      artist = artistTemp[0] + ' ' + artistTemp[1];
    } else {
      artist = artistTemp[0];
    }
    String keyword = '${dataList[progress].name} - $artist';
    print(keyword);
    String baseUrl = 'https://www.genie.co.kr/search/searchMain?query=';
    String url = Uri.encodeFull(baseUrl + keyword);
    print(url);
    Uri uri = Uri.parse(url);

    setWebView();

    webViewController.loadRequest(uri);
  }

  @override
  addAndCheckSearchFinished(String searchResult) {
    resultList.add(searchResult.trim());

    if (resultList.length == totalSize) {
      makeResultText();
    } else {
      progress++;
      searchKeyword();
    }
  }

  @override
  makeResultText() {
    String resultStr = '';
    for (var element in resultList) {
      resultStr = '$resultStr$element\n';
    }
    text.val = resultStr;
  }
}
