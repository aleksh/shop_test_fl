import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String thumbnail;
  final String description;
  final double price;
  final double discountedPrice;

  Product({
    @required this.id,
    @required this.name,
    @required this.thumbnail,
    @required this.description,
    @required this.price,
    @required this.discountedPrice,
  });

  Product copyWith({
    String id,
    String name,
    String thumbnail,
    String description,
    String price,
    String discountedPrice,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
    );
  }

  @override
  List<Object> get props => [id, name, thumbnail, description, price, discountedPrice];

  @override
  String toString() =>
      'Product { id:$id, name:$name, thumbnail:$thumbnail, description:$description }';
}
