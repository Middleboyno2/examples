
import 'package:ex1/page/home.dart';
import 'package:ex1/page/second_page.dart';
import 'package:ex1/page/setting.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<StatefulWidget> createState() => _FirstPagState();

}

class _FirstPagState extends State<FirstPage>{
  int _selectIndex = 0;


  void _navigateBottomBar(int index){
    setState ((){
      _selectIndex = index;
    });
  }

  final _listScreen = [
    Home(),
    SecondPage(),
    Setting()
  ] ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("1st"),
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple[200],
        child: Column(
          children: [
            const DrawerHeader(
              margin:EdgeInsets.only(bottom: 0.0),
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child:Icon(
                Icons.ac_unit,
                size: 40,
              ),

            ),
            // const SizedBox(height: 30),
            Divider(
              height: 100,
              color: Colors.deepPurple[200],
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("H O M E"),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("S E T T I N G S"),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            )
          ],
        ),
      ),
      body: _listScreen[_selectIndex],
      // body: Center(
      //   child: ElevatedButton(
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/second_page');
      //       },
      //       child: const Text("go to the Second Page")
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting",
            ),
          ]
      ),
    );
  }






}