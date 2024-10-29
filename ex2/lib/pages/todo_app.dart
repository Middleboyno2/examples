import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TodoAppState();

}

class TodoAppState extends State<TodoApp>{

  TextEditingController myController = TextEditingController();

  String message = "";

  void greetMessage(){
    setState(() {
      message = "Hello, ${myController.text}";
    });
    // print(myController.text);
    // myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // top, left, right, bottom đều cách 25 pixel
        padding: const EdgeInsets.all(25.0),
        child: Column(
          // căn giữa cho các phần tử trong column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: myController,
              decoration: InputDecoration(
                icon: Icon(Icons.ac_unit),
                border: OutlineInputBorder(),
                hintText: "nhập ở đây"
              ),
            ),

            // 1 cách để tạo khoảng trắng
            const SizedBox(height: 20),

            ElevatedButton(onPressed: greetMessage, child: const Text("Click")),

            const SizedBox(height: 30),

            Text(message,
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
          ],
        )
      ),
    );
  }

}