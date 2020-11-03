import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/TravelTabDao.dart';
import 'package:flutter_trip/models/TravelItemModel.dart';
import 'package:flutter_trip/models/TravelTabModel.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget {



  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin{

  TabController _tabController;
  List<TraveTab> tabs = [];
  TravelTabModel travelTabModel;


  @override
  void initState() {
    _tabController= TabController(length: tabs?.length ,vsync: this);
   TravelTabDao.fetch().then((TravelTabModel model){
     //Controller's length property (0) does not match the number of tabs (10) present in TabBar's tabs property
     // https://juejin.im/post/6844903970532491271
     // 参考了这个博主的意见，解决方案：将其 SingleTickerProviderStateMixin 改成 TickerProviderStateMixin 即可
     // 同时也解决，界面空白的问题。
     _tabController = TabController(length: model.tabs?.length,vsync: this);
       setState(() {
         tabs = model.tabs;
         travelTabModel = model;
       });


   }).catchError((e){
     print("travel_page${e.toString()}");
   });

    super.initState();
  }

  @override
  void dispose() {
  _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            //这个是不要让tabbar，进入到状态栏中去了
            padding: EdgeInsets.only(top: 30),
            color: Colors.white,
            child: TabBar(
                controller:  _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff2fcfbb),width: 3),
                  insets:EdgeInsets.only(bottom: 10)
                ),

                tabs: tabs?.map<Tab>((TraveTab tab){
                  return Tab(
                    text: tab.labelName,
                  ) ;
                }).toList()),
          ),

          /// 报这个错误
          /// Horizontal viewport was given unbounded height.
          ///  添加 Expanded  或者使用Flexible
         Expanded(
             child: TabBarView(
                 controller: _tabController,
                 children: tabs.map((TraveTab tab){
                   return TravelTabPage(travelUrl: travelTabModel.url,groupChannelCode: tab.groupChannelCode,);
                 }).toList()))

        ],
      ),
    );
  }
}
