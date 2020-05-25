part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

//class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasReachedMax;

  const ProductsLoaded({
    @required this.products,
    @required this.hasReachedMax,
  });

  ProductsLoaded copyWith({
    List<Product> products,
    bool hasReachedMax,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax];

  @override
  String toString() =>
      'Products Loaded { products: ${products.length}, hasReachedMax: $hasReachedMax}';
}

class ProductsError extends ProductsState {}
