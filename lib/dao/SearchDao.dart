import 'package:flutter/material.dart';
import 'package:flutter_trip/models/HomeModel.dart';
import 'package:flutter_trip/models/SearchModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; // 别名

//接口常量：



// 搜索接口
class SearchDao{
  static Future<SearchModel> fetch(String url,String keyword) async{
    final response = await http.get(url);
    if(response.statusCode == 200){ // 请求成功
      //解决中文乱码的问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
       // 这个地方，我们把请求的text，加入到返回我们的model中，
      SearchModel searchModel = SearchModel.fromJson(result);
      searchModel.keywords = keyword;
        return searchModel;
    }else{
      throw Exception('Failed to load search_page.json');
    }
}
}