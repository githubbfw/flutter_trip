import 'package:flutter/material.dart';
import 'package:flutter_trip/models/CommonModel.dart';
import 'package:flutter_trip/models/GridNavModel.dart';
import 'WebView.dart';


// 分为上中下3个部分  网格卡片
class GridNav extends StatelessWidget {

 final GridNavModel gridNavModel;

  const GridNav({Key key, this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Container(todo://这样去设置圆角是米有作用的  所有要用  physicallmodel这个控件去进行圆角的设置
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.all(Radius.circular(10))
//      ),
//      child: Column(
//        children:
//        _gridNavItems(context),
//      ),
//    );
  return PhysicalModel(
      color: Colors.transparent,// 透明色
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias, // 可以裁剪。
      child: Column(
        children:
        _gridNavItems(context),
      ),
  );


  }


  _gridNavItems(BuildContext context) {
   //这里要将上中下3个部分的widget都返回回去。
   List<Widget> items = [];
    if(gridNavModel == null){
     return items;
    }
    if(gridNavModel.hotel != null){
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
   if(gridNavModel.flight != null){
     items.add(_gridNavItem(context, gridNavModel.flight, false));
   }
   if(gridNavModel.travel != null){
     items.add(_gridNavItem(context, gridNavModel.travel, false));
   }

   return items;
  }


  _gridNavItem(BuildContext context,GridNavItem gridNavItem,bool first){
    List<Widget> items = [];
    items.add(_mainItem(context,gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

     // todo： 这个地方的设置，非常好，评分了布局占领空间。
    List<Widget>  expandeItems = [];
    items.forEach((item){
      expandeItems.add(Expanded(child: item,flex: 1,));
    });

    
    Color startColor = Color(int.parse('0xff'+gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff'+gridNavItem.endColor));

    return Container(
       height: 88,
       margin: EdgeInsets.only(top: 3),
       decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
             startColor,endColor
            ]
        ),
       ),
      child: Row(
        children: expandeItems,
      ),
    );
  }

  _mainItem(BuildContext context,CommonModel commonModel){
   return GestureDetector(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(
           builder: (context)=>
               WebView(url: commonModel.url,statusBarColor: commonModel.statusBarColor,
                hideAppBar:commonModel.hideAppBar,title: commonModel.title,)
       ),);
      },
    child: _wrapGesture(context, Stack(
      alignment: Alignment.topCenter, // 这个让text也居中。
     children: <Widget>[
      Image.network(commonModel.icon,fit: BoxFit.contain,
       height: 88,width: 121,alignment: AlignmentDirectional.bottomEnd,),
       Container(
         margin:  EdgeInsets.only(top: 11), // text距离顶部的距离，
         child:  Text(commonModel.title,style: TextStyle(fontSize: 14,color: Colors.white),),
       )
     ],
    ), commonModel)
   );
  }

  //  生成 中间的2个小的item
_doubleItem(BuildContext context,CommonModel topItem,CommonModel bottomItem){
   return  Column(
    children: <Widget>[
       Expanded(
           child:_item(context, topItem, true)
       ),
     Expanded(
         child:_item(context, bottomItem, false)
     )
    ],
   );

}

_item(BuildContext context,CommonModel item,bool first){
   BorderSide borderSide = BorderSide(width: 0.8,color: Colors.white);
   // 撑满父布局的宽度
   return  FractionallySizedBox(
     widthFactor: 1,
     child:
  Container(
     decoration: BoxDecoration(
      border: Border(
       left: borderSide,
       bottom: first?borderSide:BorderSide.none
      )
     ),
//     child: Center(
//      child: Text(item.title,
//      textAlign: TextAlign.center,
//      style: TextStyle(fontSize: 14,color: Colors.white)),
//     ),
    // todo:可以点击
     child:
     _wrapGesture(context, Center(
      child: Text(item.title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14,color: Colors.white)),
     ), item),
    )
   );
}

// 封装一个跳转的方法
_wrapGesture(BuildContext context,Widget widget ,CommonModel commonModel){
   return GestureDetector(
    onTap: (){
     Navigator.push(context, MaterialPageRoute(
         builder: (context)=>
             WebView(url: commonModel.url,statusBarColor: commonModel.statusBarColor,
              hideAppBar:commonModel.hideAppBar,title: commonModel.title,)
     ),);
    },
    child: widget,
   );
}



}






