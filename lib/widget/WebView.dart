import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//携程的一些域名地址。
const CATCH_URLS = ['m.ctrip.com/','m.ctrip.com/html5/','m.ctrip.com/html5','https://m.ctrip.com/webapp/you/'];
//  这个地方，暂时还有跳转返回，返回携程的界面，这个暂时还没办法处理
// 由于  “美食林” 和 “当地攻略” 打开和返回的url有冲突，闲置是禁止了 当地攻略 url的打开。

class WebView extends StatefulWidget {
  // 设置的变量
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  const WebView(
      {Key key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  //这个是判断界面，是否重复打开。
  bool exiting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webviewReference.close();
    //监听url是否发生变化
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url) {});
    //监听改变状态
    _onStateChanged = webviewReference.onStateChanged
        .listen((WebViewStateChanged stateChanged) {
      switch (stateChanged.type) {
        case WebViewState.startLoad:
          if(_isToMain(stateChanged.url)&&!exiting){
            if(widget.backForbid){// 如果是禁止返回，就直接加载当前界面。
              webviewReference.launch(widget.url);
            }else{
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;

        case WebViewState.shouldStart:
          // TODO: Handle this case.
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
        default:
          break;
      }
    });
    // 如果打开错误
    _onHttpError=webviewReference.onHttpError.listen((WebViewHttpError error){
      print(error);
    });


  }

  // 判断当前界面的url值
  _isToMain(String url){
    bool contain = false;
    for(final value in CATCH_URLS){
      //添加一个url？的判断，放在url为空，
      if(url?.endsWith(value)??false){
        contain = true;
        break;
      }
    }
    return contain;
  }
  



  @override
  void dispose() {
    // TODO: implement dispose
    _onHttpError.cancel();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    webviewReference.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
     if(statusBarColorStr == 'ffffff'){//状态栏的颜色是白色
       backButtonColor = Colors.black;
     }else{
       backButtonColor = Colors.white;
     }


    return Scaffold(
      body: Column(
         children: <Widget>[
          _appBar(Color(int.parse('0xff'+statusBarColorStr)),backButtonColor),
           Expanded(
               child: WebviewScaffold(
                   url: widget.url,
                   withZoom: true,  //可以进行缩放，
                    withLocalStorage: true,
                    hidden: true,
                    //todo：如果设置了这个属性，，一定要设置一个center的属性，因为这个是铺满全屏幕的
                    //Center(child: Text('Waiting.....'),)
                    initialChild: Container(
                      color: Colors.white,
                      child: Center(child: Text('Waiting.....'),),
                    ),
               )
           ),
         ],
      ),
    );
  }

  _appBar(Color backgroundColor,Color backButtonColor){
    // 没有 Appbar
    if(widget.hideAppBar??false){
      return Container(
        color: backgroundColor,
        height: 20,
      );

    }
   // 有 Appbar
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(//撑满 宽度
        widthFactor: 1,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(Icons.close,color: backButtonColor,size: 26),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                        widget.title ?? '',
                      style: TextStyle(color: backButtonColor,fontSize: 20),
                    ),)
              ),
            ],
          ),
      ),
    );
  }


}
