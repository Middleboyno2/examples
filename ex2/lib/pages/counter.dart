import 'package:flutter/material.dart';

class Count extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CountState();
}

class _CountState extends State<Count>{
  int _count = 0;

  void _incrementCounter(){

    setState(() {
      _count++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("tổng số lần nhấn :"),
            Text(
              _count.toString(),
              style: const TextStyle(
                  fontFamily: 'Time New Roman',
                  fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
            ElevatedButton(onPressed: _incrementCounter, child: Text("Click")),
          ],
        ),
      ),
    );
  }

}