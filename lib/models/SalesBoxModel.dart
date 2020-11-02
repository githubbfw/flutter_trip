import 'package:flutter_trip/models/CommonModel.dart';

/**
 * 成员变量 ，不用final修饰，或者const修饰，他们都是只能赋值一次的
 *   这个是使用工厂模式，所以这地方的成员变量是可以使用final修饰的，并且没有初始化值。
 *
 *   这个是一个活动入口的模型
 *
 */

class SalesBoxModel {
  final String icon;
  final String moreUrl;
  final CommonModel bigCard1;
  final CommonModel bigCard2;
  final CommonModel smallCard1;
  final CommonModel smallCard2;
  final CommonModel smallCard3;
  final CommonModel smallCard4;

  SalesBoxModel(
      {this.icon,
      this.moreUrl,
      this.bigCard1,
      this.bigCard2,
      this.smallCard1,
      this.smallCard2,
      this.smallCard3,
      this.smallCard4});

  factory SalesBoxModel.fromJon(Map<String, dynamic> json) {
    return SalesBoxModel(
      icon: json['icon'],
      moreUrl: json['moreUrl'],
      bigCard1: CommonModel.fromJon(json['bigCard1']),
      bigCard2: CommonModel.fromJon(json['bigCard2']),
      smallCard1: CommonModel.fromJon(json['smallCard1']),
      smallCard2: CommonModel.fromJon(json['smallCard2']),
      smallCard3: CommonModel.fromJon(json['smallCard3']),
      smallCard4: CommonModel.fromJon(json['smallCard4']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['moreUrl'] = this.moreUrl;
    if (this.bigCard1 != null) {
      data['bigCard1'] = this.bigCard1.toJson();
    }
    if (this.bigCard2 != null) {
      data['bigCard2'] = this.bigCard2.toJson();
    }
    if (this.smallCard1 != null) {
      data['smallCard1'] = this.smallCard1.toJson();
    }
    if (this.smallCard2 != null) {
      data['smallCard2'] = this.smallCard2.toJson();
    }
    if (this.smallCard3 != null) {
      data['smallCard3'] = this.smallCard3.toJson();
    }
    if (this.smallCard4 != null) {
      data['smallCard4'] = this.smallCard4.toJson();
    }
    return data;
  }


}
