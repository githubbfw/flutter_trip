import 'package:flutter_trip/models/HomeModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; // 别名

//接口常量：
const  HomeUrl= "https://www.devio.org/io/flutter_app/json/home_page.json";


// 首页大接口
class HomeDao{
  static Future<HomeModel> fetch() async{
    final response = await http.get(HomeUrl);
    if(response.statusCode == 200){ // 请求成功
      //解决中文乱码的问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
        return HomeModel.fromJson(result);
    }else{
      throw Exception('Failed to load home_page.json');
    }

}
}