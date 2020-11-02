/**
 * 成员变量 ，不用final修饰，或者const修饰，他们都是只能赋值一次的
 *   这个是使用工厂模式，所以这地方的成员变量是可以使用final修饰的，并且没有初始化值。
 *
 */

class ConfigModel {
  final String searchUrl;

  ConfigModel({this.searchUrl});

  factory ConfigModel.fromJon(Map<String, dynamic> json) {
    return ConfigModel(searchUrl: json['searchUrl']);
  }

  Map<String, dynamic> toJson(){
    return {
      searchUrl:searchUrl,
    };
  }


}
