import 'package:ex3/components/clothes_tile.dart';
import 'package:ex3/data/clothes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart.dart';


class Shop extends StatefulWidget{
  const Shop({super.key});

  @override
  State<StatefulWidget> createState() => ShopState();

}
class ShopState extends State<Shop>{
  // phần này để lấy ký tự nhập vào ô search
  TextEditingController myController = TextEditingController();


  void addShoeToCart(Clothes clothe) {
    Provider.of<Cart>(context, listen: false).addItemToCart(clothe);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Successfully added!'),
        content: Text('check your cart!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context, value, child) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200]
              ),

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Ẩn border của TextField
                          hintText: "Search...",
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.grey[600])
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hot Sale 🔥🔥🔥',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'See all',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Clothes clothes = value.getClothesList()[index];
                    return ClothesTile(
                      clothes: clothes,
                      onTap: () => addShoeToCart(clothes),
                    );
                  }
              ),
            ),
          ],
        ),
    );


  }



}