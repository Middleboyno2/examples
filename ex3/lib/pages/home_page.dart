import 'package:ex3/components/bottom_nav_bar.dart';
import 'package:ex3/pages/cart_page.dart';
import 'package:ex3/pages/shop.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();

}

class HomePageState extends State<HomePage>{
  int _selected = 0;
  void navigateBottomBar (int index){
    setState(() {
      _selected = index;
      print(_selected);
    });
  }

  final List<Widget> _pages = [
    const Shop(),
    CartPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: (){
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu)
          ),
        ),
      ),

      // // Phần FloatingActionButton nằm chính giữa
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Xử lý khi ấn vào nút nổi
      //   },
      //   backgroundColor: Colors.redAccent,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/img/unique.png',width: 150),
                      // const SizedBox(height: 10),
                      // const Text('U n i q l o', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),

                const SizedBox(height: 20),


                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 25, right: 10),
                    child: Icon(Icons.home, color: Colors.white,),
                  ),
                  title: const Text('H O M E', style: TextStyle(fontSize: 17, color: Colors.white)),
                  onTap: () => {},

                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 25, right: 10),
                    child: Icon(Icons.info, color: Colors.white,),
                  ),
                  title: const Text('A B O U T', style: TextStyle(fontSize: 17, color: Colors.white)),
                  onTap: () => {},
                ),


              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 25, right: 10),
                  child: Icon(Icons.logout, color: Colors.white,),
                ),
                title: const Text('L O G O U T', style: TextStyle(fontSize: 17, color: Colors.white)),
                onTap: () => {},
              ),
            ),

          ],
        ),
      ),


      body: _pages[_selected],
      bottomNavigationBar: CustomBottomAppBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }

}