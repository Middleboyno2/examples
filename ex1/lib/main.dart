import 'package:ex1/page/first_page.dart';
import 'package:ex1/page/home.dart';
import 'package:ex1/page/second_page.dart';
import 'package:ex1/page/setting.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      routes: {
        '/first_page': (context) => FirstPage(),
        '/second_page': (context) => SecondPage(),
        '/home': (context) => Home(),
        '/setting': (context) => Setting()

      },
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     backgroundColor: Colors.deepPurple[200],
    //     // appBar: AppBar(
    //     //   title: const Text("Example flutter beginner"),
    //     //   backgroundColor: Colors.deepPurple,
    //     //   elevation: 0,
    //     //   leading: const Icon(Icons.menu),
    //     //   actions: [
    //     //     IconButton(
    //     //         onPressed: () {},
    //     //         icon: const Icon(Icons.logout)
    //     //     ),
    //     //   ],
    //     // ),
    //     // body: GridView.builder(
    //     //   itemCount: 64,
    //     //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
    //     //   itemBuilder: (context, index) => Container(
    //     //     color: Colors.deepPurple,
    //     //     margin: EdgeInsets.all(5),
    //     //   )
    //     // )
    //     body: Center(
    //       child: GestureDetector(
    //         onTap: () {
    //           print("Don't Click");
    //         },
    //         child: Container(
    //           height: 300,
    //           width: 300,
    //           decoration: BoxDecoration(
    //               color: Colors.green,
    //               borderRadius: BorderRadius.circular(20)
    //           ),
    //           padding: const EdgeInsets.symmetric(horizontal: 25),
    //           child: const Center(
    //             child: Icon(
    //               Icons.favorite,
    //               color: Colors.white,
    //               size: 60,
    //             ),
    //             // child: Text(
    //             //   "Welcome to the Zoo!",
    //             //   style: TextStyle(
    //             //     color: Colors.white,
    //             //     fontSize: 20,
    //             //     fontWeight: FontWeight.bold
    //             //   ),
    //             // ),
    //
    //           ),
    //         ),
    //       ),
    //
    //     ),
    //   ),
    //
    // );
  }
}


