import 'package:flutter_trip/models/CommonModel.dart';

/**
 * 成员变量 ，不用final修饰，或者const修饰，他们都是只能赋值一次的
 *   这个是使用工厂模式，所以这地方的成员变量是可以使用final修饰的，并且没有初始化值。
 *
 *   这是 首页网格卡片模型
 *
 */

class GridNavModel {
  /**
   * 数据类型
   * GridNavItem  hotle   Object  NonNull
   * GridNavItem  flight   Object  NonNull
   * GridNavItem  travel   Object  NonNull
   */
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;


  GridNavModel(
      {this.hotel, this.flight, this.travel});

  factory GridNavModel.fromJon(Map<String, dynamic> json) {
    // 这判断一下json是不是为空
    return json !=null?
    GridNavModel(
      hotel: GridNavItem.fromJson(json['hotel']),
      flight: GridNavItem.fromJson(json['flight']),
      travel: GridNavItem.fromJson(json['travel']),
    ) :null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotel != null) {
      data['hotel'] = this.hotel.toJson();
    }
    if (this.flight != null) {
      data['flight'] = this.flight.toJson();
    }
    if (this.travel != null) {
      data['travel'] = this.travel.toJson();
    }
    return data;
  }


}

//里面的item的字段
class GridNavItem {
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItem({this.startColor, this.endColor, this.mainItem, this.item1, this.item2, this.item3, this.item4});


  factory GridNavItem.fromJson(Map<String,dynamic> json){
     return GridNavItem(
       startColor: json['startColor'],
       endColor: json['endColor'],
       //todo:这个地方，为什么不进行其他类型的转换。
//       mainItem: json['mainItem'],
       mainItem: CommonModel.fromJon(json['mainItem']),
       item1: CommonModel.fromJon(json['item1']),
       item2: CommonModel.fromJon(json['item2']),
       item3: CommonModel.fromJon(json['item3']),
       item4: CommonModel.fromJon(json['item4']),
     );



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startColor'] = this.startColor;
    data['endColor'] = this.endColor;
    if (this.mainItem != null) {
      data['mainItem'] = this.mainItem.toJson();
    }
    if (this.item1 != null) {
      data['item1'] = this.item1.toJson();
    }
    if (this.item2 != null) {
      data['item2'] = this.item2.toJson();
    }
    if (this.item3 != null) {
      data['item3'] = this.item3.toJson();
    }
    if (this.item4 != null) {
      data['item4'] = this.item4.toJson();
    }
    return data;
  }











}
