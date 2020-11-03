import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/HomeDao.dart';
import 'package:flutter_trip/models/BannerModel.dart';
import 'package:flutter_trip/models/CommonModel.dart';
import 'package:flutter_trip/models/GridNavModel.dart';
import 'package:flutter_trip/models/HomeModel.dart';
import 'package:flutter_trip/models/SalesBoxModel.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/speak_Page.dart';
import 'package:flutter_trip/widget/GridNav.dart';
import 'package:flutter_trip/widget/Loading_Container.dart';
import 'package:flutter_trip/widget/SalesBox.dart';
import 'package:flutter_trip/widget/SearchBar.dart';
import 'package:flutter_trip/widget/TenHomeNav.dart';
import 'package:flutter_trip/widget/WebView.dart';
import '../widget/Home_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  final _imageUrls = [
//    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
//    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
//    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
//  ];

  double appBarAlpha = 0;
  bool isLoading = true; // 显示进度条

  //首页的5个导航按钮
 List<CommonModel> homeNavList;
 GridNavModel gridNavModel;
 List<CommonModel> subNavList;
 SalesBoxModel salesBoxModel;

  List<CommonModel> bannerList;


  _jkll(){
    return "aa";
  }


  @override
  void initState() {
    super.initState();
    _handleRefresh();
    print(_jkll());
    print(_jkll);
    print(_jumpToSpeak);
  }

  //滚动的监听
  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }

  //接口调用方法
 Future<Null> _handleRefresh() async {
    //第一种方式
//    HomeDao.fetch().then((result){
//      setState(() {
//        resultString= json.encode(result);
//      });
//    }).catchError((e){ // 如果请求失败了
//      setState(() {
//        resultString= e.toString();
//      });
//    });

  //第二种方式：
  // 如果请求失败，结合 try catch

    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        //todo:json.encode(model) ，这个地方，在转换的时候，因为已经转换的一遍了，就不能直接用  json.encode,要在模型数据中写自己的 toJson()方法。
        homeNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        bannerList=  model.bannerList;
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }

  return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
        body: Loading_Container(
                isLoading: isLoading,
                child: Stack(
                  children: <Widget>[
                    MediaQuery.removePadding(   //去掉头部的预留的padding
                       removeTop:true,
                        context: context,
                        child: RefreshIndicator(
                            onRefresh:_handleRefresh,
                            child: NotificationListener(
                              // ignore: missing_return
                              onNotification: (scrollNotification) {
                                if (scrollNotification is ScrollNotification &&
                                    scrollNotification.depth == 0) {
                                  // scrollNotification.depth == 0  就是去判断是判断listview的滚动
                                  //找到第0个元素 就是listview
                                  //滚动且是列表滚动的时候，
                                  _onScroll(scrollNotification.metrics.pixels);
                                }
                              },
                              child: _listView
                            )),),
                    _appBar,


              ],
            )));
  }

  Widget get _listView{
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            _banner,
            Padding(
                padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                child: Home_nav(homeNavList: homeNavList,)),
            Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: GridNav(gridNavModel: gridNavModel,),),
            Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: TenHomeNav(subNavList: subNavList,),),
            Padding(padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: SalesBox(salesBoxModel: salesBoxModel,),),
          ],
        ),
// 测试使用
//        Container(
//          height: 800,
//          child: ListTile(
//            title: Text("resultString"),
//          ),
//        )
      ],
    );
  }
// 另外一种样式
    Widget get _appBar{
//      print("11111"+_jumpToSpeak());
//      print("22222"+_jumpToSpeak);

    return  Column(
      children: <Widget>[
             Container(
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   //appbar的渐变罩背景
                     colors: [Color(0x66000000),Colors.transparent],
                   begin: Alignment.topCenter,
                   end:  Alignment.bottomCenter,
                 )
               ),
               child: Container(
                 padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                 height: 80,
                 decoration: BoxDecoration(
                   color: Color.fromARGB((appBarAlpha*255).toInt(), 255, 255, 255)
                 ),
                 child: SearchBar(
                   searchType: appBarAlpha > 0.2
                       ? SearchBarType.homeLight
                       :SearchBarType.home,
                   inputBoxClick: _jumpTosearch,

                 // todo：这个2中写法是一个意思。
//                   speakClick: (){
//                     return _jumpToSpeak();
//                   },
                   speakClick: _jumpToSpeak,


                   defaultText: SEARCH_BAR_DEFAULT_TEXT,
                   leftButtonClick: (){},
                 ),
               ),
             ),
        // 在searchBar下面放一个阴影。
        Container(
          height: appBarAlpha > 0.2?0.5:0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 0.5)]
          ),
        )


      ],
    );



  }
// 跳转到 -- 搜索界面
  _jumpTosearch(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchPage(hint:SEARCH_BAR_DEFAULT_TEXT);
    }));
  }

  //跳转到语言界面
  _jumpToSpeak(){
     Navigator.push(context, MaterialPageRoute(builder: (context){
       return SpeakPage();
     }));
  }




//  Widget get _appBar{
//    return  Opacity(
//      //透明度
//      opacity: appBarAlpha,
//      child: Container(
//        decoration: BoxDecoration(color: Colors.white),
//        height: 80,
//        child: Center(
//          child: Padding(
//            padding: EdgeInsets.only(top: 20),
//            child: Text(
//              "首页",
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  // banner
Widget get _banner{
return  Container(
    height: 160,
    child: Swiper(
      pagination: SwiperPagination(), //指示器
     // itemCount: bannerList!=null ? bannerList.length:0, // 这个地方，bannerList的长度进行判断一下  或者是使用?? 这种形式去改变。
      itemCount: bannerList?.length ?? 0,
      autoplay: true,
      itemBuilder: (BuildContext contenxt, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              CommonModel model =   bannerList[index];
              return  WebView(url: model.url,statusBarColor: model.statusBarColor,
                hideAppBar:model.hideAppBar,title: model.title,);
            }
            ),);
          },
          child: Image.network(
            bannerList[index].icon,
            fit: BoxFit.fill,
          ),
        );
      },
    ),
  );
}

}
