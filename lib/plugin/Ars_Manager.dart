import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Ars_Manager{
  static const MethodChannel _channel = MethodChannel("asr_plugin");

  // 开始录音
  static Future<String> start({Map params})async{
    String result = '' ;
    try{
      var aa =   await _channel.invokeMethod('start',params ?? {});
      if(aa != null && aa.length>0){
        result = aa;
      }
    }catch(e){
      print("1111111"+e.toString());
    }


    return result;
  }

  // 停止录音
  static Future<String> stop() async{
    return await _channel.invokeMethod('stop');
  }

  // 取消录音
  static Future<String> cancel() async{
    return await _channel.invokeMethod('cancel');
  }

}
