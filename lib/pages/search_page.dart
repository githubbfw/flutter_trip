import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/SearchDao.dart';
import 'package:flutter_trip/models/SearchModel.dart';
import 'package:flutter_trip/pages/speak_Page.dart';
import 'package:flutter_trip/widget/SearchBar.dart';
import 'package:flutter_trip/widget/WebView.dart';
// 图片类型
 const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgrop'
];

class SearchPage extends StatefulWidget {
static  const  SearchUrl= "https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=autocomplete&contentType=json&keyword=";




  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.searchUrl=SearchUrl, this.keyword, this.hint}) : super(key: key);



  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  SearchModel searchModel;
  String keyword;

  @override
  void initState() {
    // 这个是用于，语音界面带过来的keyword的直接，就行搜索。
  if (widget.keyword != null){
    _onTextChange(widget.keyword);
  }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
     // 由于报了这个错误，我们就有了expanded 修改了一层
       // 去掉listview的padding值
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                  child: ListView.builder(
                      itemCount: searchModel?.data?.length??0,
                      itemBuilder: (context,int position ){
                        return _item(position);
                      })))
        ],
      )
    );
  }
  // 输入框内容发生改变了
  // todo: 这里做一个优化， 比如你输入的内容变化太快，就listview的item内容得不到及时的更新，就会出现内容错乱的问题
  _onTextChange(String text){
    keyword = text;
    if(text.length==0){
      setState(() {
        searchModel = null;
      });
    }
    String url = widget.searchUrl+ keyword;
    // 进行网络请求 --- 请求里面多传入一个text 作为验证--- 其实这个验证可以叫后台，返回我们请求的keyword
    SearchDao.fetch(url,text).then((SearchModel model){
      // 只有当当前输入内容和服务器返回的数据一致时，才就渲染。
      if(model.keywords == keyword){
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((Object e){
      /**
       * 如果异常，是这样写的  catchError((Exception e) ---- 就会抛出这样的异常
       *
       * Invalid argument (onError): Error handler must accept one Object or one Object and a StackTrace as arguments,
       * and return a a valid result: Closure: (Exception) => String
       *
       * 网上的解决是将  Exception   改为  Object
       * 原因 ： You can't limit to Exception here. Dart can throw all kinds of values.
       *
       *
       */

      print("11111${e.toString()}");

    });
  }

  _item(int position){
    if(searchModel == null || searchModel.data == null ){
      return null;
    }
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context){
          return  WebView(url: item.url,
          title: '详情',
          );
        }) );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom:BorderSide(width:0.3,color: Colors.grey) )
        ),
        child: Row(
          children: <Widget>[
            // 这里是应该有个图片的 icon
//            Container(
//              margin: EdgeInsets.all(1),
//             // Image.asset(),  这个也是添加本地图片的方法。
//              child:Image(
//                height: 26,
//                  width: 26,
//                  // 根据类型去加载图片
//                  image: AssetImage(_typeImage(item.type)))
//            ),
            
            Column(
              children: <Widget>[
                Container(
                  width: 300,
//                  child: Text('${item.word??''} ${item.districtName??''} ${item.zonename??''}'),
                  child: _title(item),
                ),
                Container(
                  // 实现富文本 Text('${item.price??''} ${item.type??''} ${item.star??''}')
                  width: 300,
                  child:RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: item.price ??'',
                            style:TextStyle(fontSize: 16,color:Colors.orange ),
                          ),
                          TextSpan(
                            text: item.star ??'',
                            style:TextStyle(fontSize: 12,color:Colors.grey ),
                          ),
                        ]
                      ),

                  ) ,
                ),
              ],
            )

          ],
        ),
      ),
    );

  }
  // 富文本操作
  _title(SearchItem item){
  if(item == null){
    return null;
  }
  List<TextSpan> spans = [];
  spans.addAll(_keywordTextSpans(item.word,searchModel.keywords));

  spans.add(
      TextSpan(
        text: ' '+(item.districtName ?? '')+ ' '+(item.zonename ?? ''),
       style: TextStyle(fontSize: 16,color: Colors.grey)
  ));
  return RichText(text: TextSpan(children: spans));
  }

  // keyword进行title的拆分。
  _keywordTextSpans(String word ,String keyword){
    List<TextSpan> spans = [];
    if(word == null || word.length == 0){
      return spans;
    }
    //word： 试试看桂林米粉  keyword  -- 试试。
    //分解以后，长2部分 0:   “” 和   1 :   “看桂林米粉”
    List<String> arr = word.split(keyword); // 根据keyword 进行切割
    TextStyle normalStyle = TextStyle(fontSize: 16,color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16,color: Colors.orange);
    // todo: 这个地方没弄懂。
    for(int i = 0;i<arr.length;i++){
      if((i+1)%2 == 0){
        spans.add(TextSpan(text: keyword,style: keywordStyle));
      }
      String value = arr[i];
      if(value!= null &&value.length>0){
        spans.add(TextSpan(text: value,style: normalStyle));
      }

    }
   return spans;

  }



  // 自定义根据类型加载图片
  _typeImage(String type){
   if(type == null ){
     return "image/type_travelgroup.png"; // 显示默认图片
   }
   String path = 'travelgroup';
   for(final value in TYPES){
     if(type.contains(value)){
       path = value;
       break;
     }
   }
   return 'images/type_${path}.png';

  }



// 自定义的appbar
  _appBar(){
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0x66000000),Colors.transparent],
              begin: Alignment.topCenter,
              end:  Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,

              speakClick: _jumpToSpeak,
              leftButtonClick: (){
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),

        )
      ],
    );

  }

  _jumpToSpeak(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SpeakPage();
    }));
  }



}