package com.xiaowu.flutter_trip;

import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

/**
 * author : Teddy
 * date   : 2020/10/24
 * desc   : // 实现返回接口的接口
 */
class ResultStateful implements MethodChannel.Result {
    private final static String TAG = "ResultStateful";
    private  MethodChannel.Result mResult;

    // result 只能调用一次，不能重复调用
    private  boolean called;

    // 外界只能通过of这个方法，来获取这个实例
    public  static ResultStateful of(MethodChannel.Result result){
        return  new ResultStateful(result);
    }

    private   ResultStateful(MethodChannel.Result result){
        this.mResult = result;
    }

    @Override
    public void success(Object result) {
        if (called){
            printError();
            return;
        }
      called = true;
      mResult.success(result);
    }

    @Override
    public void error(String errorCode, String errorMessage, Object errorDetails) {
        if (called){
            printError();
            return;
        }
        called = true;
        mResult.error(errorCode,errorMessage,errorDetails);
    }

    @Override
    public void notImplemented() {
        if (called){
            printError();
            return;
        }
        called = true;
        mResult.notImplemented();
    }


    // 错误的log 打印
    private  void  printError(){
        Log.i(TAG,"error:result called");
    }
}
