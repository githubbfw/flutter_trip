import 'package:flutter/material.dart';

enum SearchBarType { home ,normal ,homeLight} // searchbar 的类型
class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;// 是否有返回< 图标。icon
  final  SearchBarType searchType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar({Key key, this.enabled= true, this.hideLeft, this.searchType = SearchBarType.normal, this.hint, this.defaultText, this.leftButtonClick, this.rightButtonClick, this.speakClick, this.inputBoxClick, this.onChanged}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;// 是否显示清除按钮x
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.defaultText != null){ // todo：等会测试一下这个功能
      setState(() {
        _controller.text = widget.defaultText;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchType == SearchBarType.normal?
    _genNormalSearch():_genHomeSearch();

  }

  _genNormalSearch(){ //他的样式，就是底部导航栏-- 搜索 中的样式
  return Container(
    child: Row(
      children: <Widget>[
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget?.hideLeft ?? false ?null:Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: 26,
              ),
            ),
            widget.leftButtonClick),
        // 中间部分是输入框
        Expanded(
          flex: 1,
            child: _inputBox()
        ),
        // 搜索 -文字
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                '搜索',
                style: TextStyle(color: Colors.blue,fontSize: 17),
              ),
            ),
            widget.rightButtonClick),


      ],
    ),
  );


  }
// 首页顶部的输入框
  _genHomeSearch(){
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child:Row(
                  children: <Widget>[
                    Text(
                      '上海',
                      style: TextStyle(color:_homeFontColor(),fontSize: 14),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: _homeFontColor(),
                      size: 22,
                    ),

                  ],
                ),
              ),
              widget.leftButtonClick),
          // 中间部分是输入框
          Expanded(
              flex: 1,
              child: _inputBox()
          ),
          // 搜索 -文字
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                    Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.rightButtonClick),


        ],
      ),
    );
  }
  //输入框部分的内容
  _inputBox(){
    // 输入框的颜色
    Color inputBoxColor;
    if(widget.searchType == SearchBarType.home){ // 如果是home页的就是白色的
      inputBoxColor = Colors.white;
    }else{
      inputBoxColor = Color(int.parse('0xffEDEDED'));
//      inputBoxColor = Colors.blue;
    }
   return Container(
     height: 30,
     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
     decoration: BoxDecoration(
       color: inputBoxColor,
       borderRadius: BorderRadius.circular(
           widget.searchType == SearchBarType.normal?5:15)
     ),
     child: Row(
       children: <Widget>[
         Icon(Icons.search,size: 20,
         color: widget.searchType == SearchBarType.normal?Color(0xffA9A9A9):Colors.blue),
         // 输入框内容
         Expanded(
           flex: 1,
           child:widget.searchType == SearchBarType.normal
         ? TextField(
           cursorColor: Colors.red,
           controller:  _controller,
           onChanged:  _onChanged,
           autofocus:  true,
           style: TextStyle(
             fontSize: 18,
             color: Colors.black,
             fontWeight: FontWeight.w300
           ),
           decoration: InputDecoration(
             contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
             //todo: 一定要添加isDense 这个属性，如果没有添加，输入框的光标，不居中，在整个布局中
             isDense: true,
             border: InputBorder.none,
             hintText: widget.hint??'',
             hintStyle: TextStyle(fontSize: 15)
           ),
         ):_wrapTap(
             Container(
               child: Text(
                 widget.defaultText,
                 style: TextStyle(color: Colors.grey,fontSize: 13),
               ),
             ), widget.inputBoxClick)),
         !showClear?
             _wrapTap(
                 Icon(Icons.mic,
                   size: 22,
                   color:widget.searchType == SearchBarType.normal ?Colors.blue:Colors.grey ,),
                 widget.speakClick)
             :_wrapTap(
             Icon(Icons.clear,
             size: 22,
             color: Colors.grey,), 
             (){
               setState(() {
                 _controller.clear();
               });
               _onChanged('');
             }
         ),
             
       ],
     ),
   );

  }
  // 获取首页的输入框颜色
  _homeFontColor(){
    return widget.searchType  == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }


  // 输入框内容的回调
  _onChanged(String text){
    if(text.length>0){
      setState(() {
        showClear = true;
      });
    }else{
      setState(() {
        showClear = false;
      });
    }
    if(widget.onChanged != null){
      widget.onChanged(text);
    }
  }


  // 封装的一个方法，child的可以点击回调
_wrapTap(Widget child,void Function() callback){
    return GestureDetector(
      onTap: (){
        if(callback != null){
          callback();
        }
      },
      child: child,
    );
}

}
