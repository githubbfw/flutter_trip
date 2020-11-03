import 'package:flutter/material.dart';
import 'package:flutter_trip/models/CommonModel.dart';
import 'package:flutter_trip/widget/WebView.dart';

class Home_nav extends StatelessWidget {
  //在StatelessWidget 中，所有的属性，所有的属性，都是final的，因为StatelessWidget 本身就是final的
  final List<CommonModel> homeNavList;

  const Home_nav({Key key, this.homeNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (homeNavList == null) {
      return Center(
        child: Text('homeNavList is null'),
      );
    }

    List<Widget> items = [];
    homeNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );

  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>
                WebView(url: model.url,statusBarColor: model.statusBarColor,
                hideAppBar:model.hideAppBar,title: model.title,)
        ),);
      },
      child: Column(
        children: <Widget>[
          Image.network(model.icon,width: 32,height: 32,),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
