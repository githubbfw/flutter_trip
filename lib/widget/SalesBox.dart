import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/models/CommonModel.dart';
import 'package:flutter_trip/models/GridNavModel.dart';
import 'package:flutter_trip/models/SalesBoxModel.dart';
import 'WebView.dart';

// 第一部分是个导航的，第二部分是2张大卡片，第三部分是2张小卡片
class SalesBox extends StatelessWidget {

  final SalesBoxModel salesBoxModel;

  const SalesBox({Key key, this.salesBoxModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6)
      ),
      child: _items(context)
    );


  }

  _items(BuildContext context) {
    if (salesBoxModel == null) {
      return Center(
        child: Text('salesBoxModel is null'),
      );
    }

    // todo:先把需要的widget都加载到集合中
    List<Widget> items = [];
    items.add(_doubleItem(context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, true, false));
    items.add(_doubleItem(context, salesBoxModel.smallCard1, salesBoxModel.smallCard2, false, false));
    items.add(_doubleItem(context, salesBoxModel.smallCard3, salesBoxModel.smallCard4, false, true));

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 44,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1,color: Color(0xfff2f2f2)))
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(salesBoxModel.icon,
              height: 15,
              fit: BoxFit.fill),
              Container(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xffff4e63),Color(0xffff6cc9)
                      ],begin: Alignment.centerLeft,end:Alignment.centerRight)
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>
                        //todo:
                            WebView(url: salesBoxModel.moreUrl,title: "更多活动",)
                    ),);
                  },
                  child: Text('获取更多福利 >',style: TextStyle(color: Colors.white,fontSize: 12),),
                ),
              ),
              // 添加卡片

            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0,1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1,2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2,3),
        ),


      ],
    );
  }

  Widget _doubleItem(BuildContext context, CommonModel leftCommonModel,CommonModel rightCommonModel,bool big,bool last ){ // 是否是大卡片，是否是最后一个
           return Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               _item(context, leftCommonModel,big,true,last),
               _item(context, rightCommonModel,big,false,last)
             ],
           );
  }









  Widget _item(BuildContext context, CommonModel model,bool big,bool left,bool last) {
    //todo:这个地方是为了，上下2层对其，使用Expanded 进行均分，然后使上下对其。
    //但是，这个地方由于上面的一次是row，会把一种错误，
    //报错The method '>' was called on null. Receiver: null Tried calling: >(1e-10)
    //解决方案就是把expanded去掉了
    BorderSide borderSide = BorderSide(width: 0.8,color: Color(0xfff2f2f2));
    return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>
                    WebView(url: model.url,statusBarColor: model.statusBarColor,
                      hideAppBar:model.hideAppBar,title: model.title,)
            ),);
          },
          child:  Container(
            decoration: BoxDecoration(
              border: Border(
                 right: left?borderSide:BorderSide.none,
                 bottom: last?BorderSide.none:borderSide
              )
            ),
            child: Image.network(
              model.icon,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width/2-10,
              height: big?180:80,
            ),
          )

    );
  }








}






