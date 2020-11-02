import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/models/TravelItemModel.dart';
import 'package:http/http.dart' as http; // 别名

//接口常量：
const  TravelUrl= "https://www.devio.org/io/flutter_app/json/travel_page.json";


// 旅拍页接口 --- post请求的

// 固定参数。
var Params = {
  "districtId":-1,
  "groupChannelCode":"RX-OMF",
  "type":null,
  "lat":-180,
  "lon":-180,
  "locatedDistrictId":0,
  "pagePara":{
    "pageIndex":1,
    "pageSize":10,
    "sortType":9,
    "sortDirection":0
  },
  "imageCutType":1,
  "head":{},
  "contentType":"json"
};




class TravelDao{
  static Future<TravelItemModel> fetch(String url,String groupChannelCode,int pageIndex,int pageSize) async{
    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;


    final response = await http.post(url,body: json.encode(Params));
    if(response.statusCode == 200){ // 请求成功
      //解决中文乱码的问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
        return TravelItemModel.fromJson(result);
    }else{
      throw Exception('Failed to load travel');
    }

}
}