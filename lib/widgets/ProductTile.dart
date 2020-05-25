import "package:flutter/material.dart";
import "../models/models.dart";

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${product.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text('${product.name}'),
      isThreeLine: true,
      subtitle: Text(product.description),
      dense: true,
    );
  }
}
