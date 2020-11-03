import 'package:flutter/material.dart';

// 加载页面的精度条
class Loading_Container extends StatelessWidget {

  final Widget child; //如果loading消失，要显示的内容
  final bool  isLoading;//loading的判断字段
  final bool cover;//loading是否要盖在child上面

  const Loading_Container({Key key, @required this.isLoading, this.cover=false, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return !cover ? !isLoading ? child:_loadingView
        :Stack(
         children: <Widget>[
           child,
           isLoading?_loadingView:null
         ],
    );
  }

  Widget get _loadingView{
    return Center(
      child: CircularProgressIndicator(),
    );
  }


}
