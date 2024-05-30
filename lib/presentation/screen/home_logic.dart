import 'dart:convert';

import 'package:arc/arc_request.dart';
import 'package:billist/data/bill_list_get_vo.dart';
import 'package:billist/presentation/screen/home_mixin.dart';
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
      makeText(responseModel);
    } catch (error) {
      if (error is AHttpException) {
        text.val = error.toString();
      }
    }
  }

  @override
  makeText(BillListGetVO responseModel) {
    String result = '';
    List<Data> listData = responseModel.data ?? [];
    for (var element in listData) {
      String? artist;
      if (element.artist!.contains(',')) {
        artist = element.artist?.substring(0, element.artist!.indexOf(','));
      } else if (element.artist!.contains('&')) {
        artist = element.artist?.substring(0, element.artist!.indexOf('&'));
      } else {
        artist = element.artist ?? '';
      }
      String lineStr = '${element.name} - $artist\n';
      result += lineStr;
    }
    text.val = result;
  }
}
