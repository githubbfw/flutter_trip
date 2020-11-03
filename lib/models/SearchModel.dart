// 搜索模型

class SearchModel{
  final List<SearchItem> data;
  String keywords;
  SearchModel({this.data});
  factory SearchModel.fromJson(Map<String, dynamic> json){
    var dataJson = json['data'] as List;

    List<SearchItem> data = dataJson.map((i)=>SearchItem.fromJon(i)).toList();
    return SearchModel(data: data);
  }


}



class SearchItem{
  final String word; // xx酒店
  final String type; // hotel
  final String price; //实时计价
  final String star;  // 豪华型
  final String zonename; // 虹桥
  final String districtName; // 上海
  final String url;

  SearchItem({this.word, this.type, this.price, this.star, this.zonename, this.districtName, this.url});

  factory SearchItem.fromJon(Map<String, dynamic> json) {
    return SearchItem(
      word: json['word'],
      type: json['type'],
      price: json['price'],
      star: json['star'],
      zonename: json['zonename'],
      districtName: json['districtName'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['price'] = this.price;
    data['star'] = this.star;
    data['zonename'] = this.zonename;
    data['districtName'] = this.districtName;
    data['url'] = this.url;
    return data;
  }



}