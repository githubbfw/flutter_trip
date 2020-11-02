import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/plugin/Ars_Manager.dart';
// 语言识别
class SpeakPage extends StatefulWidget {



  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<SpeakPage> with SingleTickerProviderStateMixin{
  static  String speakTips = '长按说话';
  String speakResult = '';
  Animation<double> animation;
  AnimationController controller;

   String _phoneStr;

   @override
  void initState() {
     // 这2个是一体的，相互作用的
     controller = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
     animation = CurvedAnimation(parent: controller, curve:Curves.easeIn )
     ..addStatusListener((status){
      if(status == AnimationStatus.completed){ // 动画完成之后
        controller.reverse();// 循环执行
      }else if(status ==  AnimationStatus.dismissed){ // 动画停止的时候
         controller.forward();// 开始运行次动画。
      }
     });
     
    super.initState();
  }

  @override
  void dispose() {
     // 销毁掉，controller.
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            //todo这个地方要设置排列方式，不然就连接在一起了
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _topItem(),
              _bottomItem(),
            ],
          ),
        ),
      ),
    );
  }
  //顶部布局
  _topItem(){
     return Column(
       children: <Widget>[
         Padding(
             padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
               child: Text('你可以这样说',
                 style: TextStyle(fontSize: 16,color:Colors.black54 ),),),
         Text('故宫门票\n北京一日游\n迪士尼乐园',
             textAlign: TextAlign.center,
         style: TextStyle(fontSize: 15,color: Colors.grey),),
         // 语言识别的结果
         Padding(
             padding: EdgeInsets.all(20),
         child: Text(speakResult,style: TextStyle(color: Colors.blue),),
         ),
       ],
     );

  }





  // 底部的按钮
  _bottomItem(){
    // 整理使用百分比布局
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            // 按下的时候
            onTapDown: (e){
              _speakStart();
            },
            // 手指松开的时候
            onTapUp: (e){
              _speakStop();
            },
            // 长按划过的时候
            onTapCancel: (){
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                  child: Text(speakTips,style: TextStyle(color: Colors.blue,fontSize: 12),),
                  ),
                 Stack(
                   children: <Widget>[
                     // 这个主要是站一个位置，避免上面的文字位置变化
                     Center(
                       child:  Container(
                         alignment: Alignment.center,
                         // 占坑，避免动画执行过程中导致父布局大小变化
                         height: MIC_SIZE,
                         width: MIC_SIZE,
                         color:Colors.grey,
                       ),
                     ),

                     Center(
                       child: AnimaterMic(
                         animation: animation,
                       ),
                     )
                   ],
                 )
                ],
              ),
            ),
          ),

          // 右边的 x 按钮
          Positioned(
              right: 0,
              bottom: 20,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,size: 30,color: Colors.grey,
                ),
              ),
          )

        ],



      )

    );

  }
  _speakStart(){
    controller.forward();

    setState(() {
      speakTips = '- 识别中 -';
    });

    // 调用方法，与原生进行交互。
    Ars_Manager.start().then((text){
       if(text!=null && text.length>0){
         setState(() {
           speakResult = text;
         });
         // 先关闭当前界面，在进行语音识别。
         Navigator.pop(context);
         Navigator.push(context,MaterialPageRoute(builder: (context)=>
             SearchPage(keyword: speakResult),
         ));


       }
    }).catchError(( Object  e){
       print(e.toString());
    });
  }

  _speakStop(){
     setState(() {
       speakTips = '长按说话';
     });

    controller.reverse();
    controller.stop();
    Ars_Manager.start();
  }
//_speakCancel(){
//
//}
}




const double MIC_SIZE = 80;
// 首选去实现 动画
class  AnimaterMic extends AnimatedWidget{
  // 透明度改变的动画
  static final _opacityTween = Tween<double>(begin: 1,end:0.5 );
  // 大小改变的动画
  static final _sizeTween = Tween<double>(begin: MIC_SIZE,end:MIC_SIZE-20);


  AnimaterMic({Key key,Animation<double> animation})
      : super(key:key,listenable:animation);



  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
        opacity: _opacityTween.evaluate(animation), // 计算当前animation给定的值。
        child:  Container(
          height: _sizeTween.evaluate(animation), // 计算动画的高度值。
          width: _sizeTween.evaluate(animation),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE/2),
          ),
          child: Icon(Icons.mic,color: Colors.white,size: 30,),
        ),
    );
  }


}



