import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {


  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
   String _phoneStr;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 2 / 3,
      alignment: Alignment.center,
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          //这行代码是关键，设置这个之后，居中
            contentPadding: EdgeInsets.all(2),
            hintText: '请输入手机号',
            prefixIcon: Icon(Icons.phone_android),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]),
              borderRadius: BorderRadius.circular(5),
            )),
        style: new TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        maxLines: 1,
        textAlign: TextAlign.left,
        onChanged: (text) {
          //内容改变的回调
          _phoneStr = text;
          print('change $_phoneStr');
        },
        onSubmitted: (text) {
          //内容提交(按回车)的回调
          print('submit $text');
        },
      ),
    );
  }
}
