import 'dart:convert';

import 'package:arc/arc_request.dart';
import 'package:billist/data/bill_list_get_vo.dart';
import 'package:billist/presentation/screen/home_mixin.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';

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
         console.log(item);
         try{
           var title = item[0].children[1].children[0].children[1].children[2].children[0].children[4].children[0].innerText.replace('TITLE ','');
           console.log(title);
           var artist = item[0].children[1].children[0].children[1].children[2].children[0].children[4].children[1].innerText;
           console.log(artist);
         
           var result = title + ' - ' + artist;
           console.log(result);
         
           window.flutter_inappwebview.callHandler('geniesearch', result);
         } catch (error){
           window.flutter_inappwebview.callHandler('geniesearch', ' ');
         }
       } 
       
       getResult();
    ''';

    webViewController.addJavaScriptHandler(
        handlerName: 'geniesearch',
        callback: (args) {
          addAndCheckSearchFinished(args.first);
        });

    webViewController.addUserScript(
        userScript: UserScript(
            source: crawling,
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END));
  }

  @override
  runJavaScript(String script) {
    webViewController.evaluateJavascript(source: script);
  }

  @override
  searchKeyword() async {
    RegExp regex = RegExp(r"\([^)]+\)");
    String song = dataList[progress].name ?? '';
    song = song.replaceAll(regex, '');

    String artist = dataList[progress].artist ?? '';
    artist = artist.replaceAll(regex, '');
    List<String> artistTemp = artist.split(' ');
    if (artistTemp.length > 1) {
      artist = artistTemp[0] + ' ' + artistTemp[1];
    } else {
      artist = artistTemp[0];
    }
    String keyword = '$song - $artist';
    print(keyword);
    String baseUrl = 'https://www.genie.co.kr/search/searchMain?query=';
    String url = Uri.encodeFull(baseUrl + keyword);
    print(url);

    setWebView();

    webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
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
