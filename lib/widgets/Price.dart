import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  final String price;
  final bool isOldPrice;

  const Price({
    this.price,
    this.isOldPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isOldPrice ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        child: Text(
          '\$ $price',
          style: TextStyle(
            decoration:
                isOldPrice ? TextDecoration.lineThrough : TextDecoration.none,
            decorationThickness: 2,
            height: 1,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
