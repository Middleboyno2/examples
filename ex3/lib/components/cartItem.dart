
 import 'package:ex3/data/cart.dart';
import 'package:ex3/data/clothes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  Clothes clothe;
  CartItem({super.key, required this.clothe});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void removeItemFromCart(){
    Provider.of<Cart>(context, listen: false).removeItemFormCart(widget.clothe);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12)
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.asset(widget.clothe.imagePath),
        title: Text(widget.clothe.name),
        subtitle: Text('total: ${widget.clothe.total}'),
        trailing: IconButton(
          onPressed: removeItemFromCart, 
          icon:Icon(Icons.delete)
        ),
      ),
    );
    
  }
}
