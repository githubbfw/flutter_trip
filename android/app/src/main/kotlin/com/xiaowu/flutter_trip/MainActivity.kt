package com.xiaowu.flutter_trip

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)



    // 注册自己的插件 
    registerSelfPlugin();


  }

  private fun registerSelfPlugin() {
    //包名+插件名
    AsrPlugin.registerWith(registrarFor("asr_plugin"))
  }


}
