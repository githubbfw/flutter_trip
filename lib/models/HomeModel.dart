import 'package:flutter_trip/models/BannerModel.dart';
import 'package:flutter_trip/models/CommonModel.dart';
import 'package:flutter_trip/models/ConfigModel.dart';
import 'package:flutter_trip/models/GridNavModel.dart';
import 'package:flutter_trip/models/SalesBoxModel.dart';

/**
 * 字段名称：
 *  config      Object  NonNull
 *  bannerList  Array  NonNull
 *  localNavList Array NonNull
 *  gridNav   Object  NonNull
 *  subNavList   Array  NonNull
 *  salesBox   Object  NonNull
 */
class HomeModel {
  final ConfigModel config; // 按住alter键，可以提示构造方法。]
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;

  final SalesBoxModel salesBox;

  HomeModel(
      {this.config,
      this.bannerList,
      this.localNavList,
      this.subNavList,
      this.gridNav,
      this.salesBox});

  //注意这里的工厂方法的转换

  factory HomeModel.fromJson(Map<String, dynamic> json) {
//    var localNavList = json['localNavList'];
//    print("111111${localNavList.runtimeType.toString()}");

    var localNavJson = json['localNavList'] as List;
    print("2222222${localNavJson.runtimeType.toString()}");

    List<CommonModel> localNavListNew =
        localNavJson.map((i) => CommonModel.fromJon(i)).toList();

    // bannerList  里面的数据类型，跟其他的数据类型不一样，所有得重新写一个数据模型
    var bannerList = json['bannerList'] as List;
    List<CommonModel> bannerListNew =
        bannerList.map((i) => CommonModel.fromJon(i)).toList();

    var subNavList = json['subNavList'] as List;
    List<CommonModel> subNavListNew =
    subNavList.map((i) => CommonModel.fromJon(i)).toList();

    return HomeModel(
      bannerList: bannerListNew,
      localNavList: localNavListNew,
      subNavList: subNavListNew,
      config: ConfigModel.fromJon(json['config']),
      gridNav: GridNavModel.fromJon(json['gridNav']),
      salesBox: SalesBoxModel.fromJon(json['salesBox']),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    }
    if (this.localNavList != null) {
      data['localNavList'] = this.localNavList.map((v) => v.toJson()).toList();
    }
    if (this.gridNav != null) {
      data['gridNav'] = this.gridNav.toJson();
    }
    if (this.subNavList != null) {
      data['subNavList'] = this.subNavList.map((v) => v.toJson()).toList();
    }
    if (this.salesBox != null) {
      data['salesBox'] = this.salesBox.toJson();
    }
    return data;
  }



}
