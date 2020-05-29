import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:shop_test_fl/screens/ProductScreen.dart';
import 'package:shop_test_fl/widgets/Price.dart';
import "../models/models.dart";

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductScreen.routeName, arguments: product);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                width: 115.0,
                height: 115.0,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://backendapi.turing.com/images/products/${product.thumbnail}',
                  placeholder: (context, url) => const Center(
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Price(
                      price: '${product.price}',
                      isOldPrice: product.discountedPrice > 0,
                    ),
                    if (product.discountedPrice > 0)
                      Price(price: '${product.discountedPrice}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
