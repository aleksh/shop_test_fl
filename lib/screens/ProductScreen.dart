import 'package:flutter/material.dart';
import 'package:shop_test_fl/models/models.dart';

class ProductScreen extends StatelessWidget {
  final Product product;

  static const routeName = "/product";

  ProductScreen({this.product});

  @override
  Widget build(BuildContext context) {
    //final Product product = ModalRoute.of(context).settings.arguments;    
   
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Text(product.description),
    );
  }
}
