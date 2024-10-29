import 'package:ex3/data/cart.dart';
import 'package:ex3/data/clothes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cartItem.dart';

class CartPage extends StatelessWidget{
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => Column(
        children: [
          Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: value.getUserCart().length,
              itemBuilder: (context, index) {
                Clothes clothe = value.getUserCart()[index];

                return CartItem(clothe: clothe);
              },
            ),
          ),
        ],
      ),
    );
  }

}