class TravelTabModel1 {

//   String url;
//   List<TravelTab> tabs;

 final String url;
 final List<TravelTab> tabs;

  TravelTabModel1({this.url,this.tabs});
  

  // TravelTabModel.fromJson(Map<String, dynamic> json){
  //     url =json['url'];
  //    (json['tabs'] as List).map((i) => TravelTab.fromJson(i));
  // }

  //  如果成员变量都是用final 修饰  就可以用工厂类进行处理
  // 如果 成员变量不是final 类型的，就可以不需要用工厂方法了


    factory  TravelTabModel1.fromJson(Map<String,dynamic> json){
    String url =json['url'];
    List<TravelTab> tabs = (json['tabs'] as List).map((i)=>TravelTab.fromJson(i)).toList();

      return TravelTabModel1(url: url,tabs: tabs );
    }



}

class TravelTab {
   
   String labelName;
   String groupChannelCode;

   TravelTab({this.labelName,this.groupChannelCode});

    TravelTab.fromJson(Map<String,dynamic> json){
      labelName =json['labelName'];
      groupChannelCode = json['groupChannelCode'];
    }

}
