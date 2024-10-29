import 'package:ex3/data/clothes.dart';

import 'package:flutter/material.dart';


class Cart extends ChangeNotifier{
  List<Clothes> cart = [
    Clothes(name: 'Clothes1', price: '100000', imagePath: 'lib/img/img_1.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes2', price: '100000', imagePath: 'lib/img/img_2.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes3', price: '100000', imagePath: 'lib/img/img_3.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes4', price: '100000', imagePath: 'lib/img/img_4.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes5', price: '100000', imagePath: 'lib/img/img_5.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes6', price: '100000', imagePath: 'lib/img/img_6.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes7', price: '100000', imagePath: 'lib/img/img_7.webp',total: 100, description: 'abc'),
    Clothes(name: 'Clothes8', price: '100000', imagePath: 'lib/img/img_8.webp',total: 100, description: 'abc'),

  ];

  List<Clothes> userCart = [];

  List<Clothes> getClothesList() {
    return cart;
  }
  List<Clothes> getUserCart() {
    return userCart;
  }

  void addItemToCart(Clothes clothe) {
    userCart.add(clothe);
    notifyListeners();
  }
  void removeItemFormCart(Clothes clothe){
    userCart.remove(clothe);
    notifyListeners();
  }
}

