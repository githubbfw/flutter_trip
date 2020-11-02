import 'package:flutter/material.dart';
import 'package:flutter_trip/models/CommonModel.dart';
import 'package:flutter_trip/widget/WebView.dart';

class TenHomeNav extends StatelessWidget {
  //在StatelessWidget 中，所有的属性，所有的属性，都是final的，因为StatelessWidget 本身就是final的
  final List<CommonModel> subNavList;

  const TenHomeNav({Key key, this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6)
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) {
      return Center(
        child: Text('homeNavList is null'),
      );
    }

    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });
    //计算出第一行显示的数量，，这个讲double转换成int值
    int separate = ((subNavList.length)/2+0.5).toInt();


    return Column(
      children: <Widget>[
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0,separate),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.sublist(separate,subNavList.length),
            ),
        ),


      ],
    );

  }

  Widget _item(BuildContext context, CommonModel model) {
    //todo:这个地方是为了，上下2层对其，使用Expanded 进行均分，然后使上下对其。
    return  Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>
                    WebView(url: model.url,statusBarColor: model.statusBarColor,
                      hideAppBar:model.hideAppBar,title: model.title,)
            ),);
          },
          child: Column(
            children: <Widget>[
              Image.network(model.icon,width: 18,height: 18,),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  model.title,
                  style: TextStyle(fontSize: 12),
                ),)
            ],
          ),
        )
    );
  }
}
