/**
 * 成员变量 ，不用final修饰，或者const修饰，他们都是只能赋值一次的
 *   这个是使用工厂模式，所以这地方的成员变量是可以使用final修饰的，并且没有初始化值。
 *
 *   这个是一个banner类
 *
 */

class BannerModel {
  final String icon;
  final String url;


  BannerModel(
      {this.icon,this.url});

  factory BannerModel.fromJon(Map<String, dynamic> json) {
    return BannerModel(
      icon: json['icon'],
      url: json['url'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }

}
