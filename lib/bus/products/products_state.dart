part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasReachedMax;
  final int categoryId;

  const ProductsLoaded({
    @required this.products,
    @required this.hasReachedMax,
    this.categoryId = -1,
  });

  ProductsLoaded copyWith({
    List<Product> products,
    bool hasReachedMax,
    int categoryId = -1,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax];

  @override
  String toString() =>
      'Products Loaded { products: ${products.length}, hasReachedMax: $hasReachedMax}';
}

class ProductsError extends ProductsState {}
