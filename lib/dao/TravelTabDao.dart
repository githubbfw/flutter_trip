import 'package:flutter_trip/models/HomeModel.dart';
import 'package:flutter_trip/models/TravelItemModel.dart';
import 'package:flutter_trip/models/TravelTabModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; // 别名

//接口常量：
const  TravelUrl= "https://www.devio.org/io/flutter_app/json/travel_page.json";


// 旅拍类别接口
class TravelTabDao{
  static Future<TravelTabModel> fetch() async{
    final response = await http.get(TravelUrl);
    if(response.statusCode == 200){ // 请求成功
      //解决中文乱码的问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
        return TravelTabModel.fromJson(result);
    }else{
      throw Exception('Failed to load traveltab');
    }

}
}