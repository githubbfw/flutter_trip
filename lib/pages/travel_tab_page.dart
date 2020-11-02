import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_trip/dao/TravelDao.dart';
import 'package:flutter_trip/dao/TravelTabDao.dart';
import 'package:flutter_trip/models/TravelItemModel.dart';
import 'package:flutter_trip/models/TravelTabModel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/widget/WebView.dart';

const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
const PAGE_SIZE= 20 ;
class TravelTabPage extends StatefulWidget {

  final String travelUrl;
  final String groupChannelCode;

  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode}) : super(key: key);


  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin{ // 为了页面空白，注意内存消耗。

  List<TravelItem> travelItems;
  int pageIndex = 1 ;



  @override
  void initState() {
  // 初始化数据
      _loadData();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: travelItems?.length??0,
        itemBuilder: (BuildContext context, int index) => _travelItem(travelItem:travelItems[index],index: index ,),
        staggeredTileBuilder: (int index) =>
        //这个地方有多种模式
//        new StaggeredTile.count(2, index.isEven ? 2 : 1),
       new StaggeredTile.fit(2),
      ),
    );
  }




  void _loadData() {
    TravelDao.fetch(widget.travelUrl?? TRAVEL_URL, widget.groupChannelCode, pageIndex, PAGE_SIZE)
        .then((TravelItemModel model){
          setState(() {
            // 对数据进行筛选
            List<TravelItem> items = _filterItems(model.resultList);
              if(travelItems != null){
                travelItems.addAll(items);
              }else{
                travelItems = items;
              }
          });
    }).catchError((e){
      print("travel_tab_page${e.toString()}");
    });
  }


  // 对数据进行筛选
  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if(resultList == null){
      return [];
    }
    List<TravelItem> filterItems = [];
     resultList.forEach((item){
       // 移除article 为空的模型
       if(item.article != null){
         filterItems.add(item);
       }
     });
   return filterItems;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

 class _travelItem extends StatelessWidget {
  final TravelItem travelItem;
  final int index;

  const _travelItem({Key key, this.travelItem, this.index}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: (){
         if(travelItem.article.urls != null &&travelItem.article.urls.length >0 ){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>
               WebView(url: travelItem.article.urls[0].h5Url,title: '详情',)));
         }
       },
       // 由于要实现上下的那种圆角效果，组合，就使用了 PhysicalModel 这个
       child: Card(
         child: PhysicalModel(
           color: Colors.transparent,
           clipBehavior: Clip.antiAlias,
           borderRadius: BorderRadius.circular(5),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               _itemImage(),
               Container(
                 padding: EdgeInsets.all(4),
                 child: Text(
                   travelItem.article.articleTitle,
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(fontSize: 14,color: Colors.black87),
                 ),
               ),
               _infoText(),

             ],
           ),
         ),
       ),
     );
   }

  _itemImage() {
     return Stack(
       children: <Widget>[
         Image.network(travelItem.article.images[0]?.dynamicUrl),
         Positioned(
           bottom: 8,
             left: 8,
             child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
               decoration: BoxDecoration(
                 color: Colors.black54,
                 borderRadius: BorderRadius.circular(10),
               ),
               child: Row(
                 children: <Widget>[
                   Padding(
                       padding: EdgeInsets.only(left: 3),
                   child: Icon(Icons.location_on,color:Colors.white,size: 12,),),
                   // 这个组件是限制大小的
                   LimitedBox(
                     maxWidth: 130,
                     child: Text(
                       travelItem.article.pois == null || travelItem.article.pois.length == 0 ? '未知':
                       travelItem.article.pois[0]?.poiName ?? '未知',
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(color: Colors.white,fontSize: 12),
                     ),
                   )
                 ],
               ),
             )
         )
       ],
     );
  }

  _infoText() {
   return Container(
     padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: <Widget>[
         Row(
           children: <Widget>[
             PhysicalModel(
               color: Colors.transparent,
               clipBehavior: Clip.antiAlias,
               borderRadius: BorderRadius.circular(12),
               child: Image.network(
                 travelItem.article.author?.coverImage?.dynamicUrl,
                 width: 24,
                 height: 24,
               ),),
             Container(
               padding: EdgeInsets.all(5),
               width: 90,
               child: Text(travelItem.article.author?.nickName,
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(fontSize: 12,),),
             )
           ],
         ),
         Row(
           children: <Widget>[
             Icon(Icons.thumb_up,size: 14,color: Colors.grey,),
             Padding(
               padding: EdgeInsets.only(left: 3),
               child: Text(travelItem.article.likeCount.toString(),style: TextStyle(fontSize: 10),),),

           ],
         )

       ],
     ),
   );

  }


 }



