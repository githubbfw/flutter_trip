package com.xiaowu.flutter_trip;

import android.app.Activity;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * author : Teddy
 * date   : 2020/10/24
 * desc   :
 */
class AsrPlugin2 implements MethodChannel.MethodCallHandler {

    private final static String TAG = "AsrPlugin";
    public  final Activity mActivity;
    private  ResultStateful  mResultStateful;



    // 创建一个方法 注册的方法。
    public  static  void registerWith(PluginRegistry.Registrar registrar){
        MethodChannel channel = new MethodChannel(registrar.messenger(),"asr_plugin");

        AsrPlugin2 instance = new AsrPlugin2(registrar);
        channel.setMethodCallHandler(instance);

    }

    public AsrPlugin2(PluginRegistry.Registrar registrar){
         this.mActivity = registrar.activity();
    }



    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method){
            case "start":
                result.success("上海");
//                mResultStateful = ResultStateful.of(result);
//                start(call,mResultStateful);
                break;
            case "stop":
                break;
            case "cancel":
                break;
            default:
                result.notImplemented();
                break;
        }

    }

    private void start(MethodCall call, ResultStateful resultStateful) {
          if (mActivity == null){
              Log.e(TAG,"ignored start,current activity is null .");
              resultStateful.error("ignored start,current activity is null .",null,null);
              return;
          }







    }
}
