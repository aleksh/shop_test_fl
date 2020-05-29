part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsFetch extends ProductsEvent {
  final int categoryId;

  ProductsFetch({this.categoryId = -1});

  @override
  List<Object> get props => [categoryId];
}