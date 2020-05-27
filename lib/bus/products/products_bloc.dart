import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shop_test_fl/models/models.dart';

import 'package:http/http.dart' as http;

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final http.Client httpClient;
  final int itemsPerPage = 10;

  ProductsBloc({@required this.httpClient});

  @override
  ProductsState get initialState => ProductsInitial();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    final currentState = state;
    if (event is ProductsFetch && !_hasReachedMax(currentState)) {
      print('ProductsFetch');

      try {
        if (currentState is ProductsInitial) {
          print('ProductsInitial');
          final products = await _fetchProducts(1, itemsPerPage);
          yield ProductsLoaded(products: products, hasReachedMax: false);
          return;
        }

        if (currentState is ProductsLoaded) {
          print('ProductsLoaded');
          final page = ((currentState.products.length / itemsPerPage) + 1).ceil();
          print('Page $page');

          final products = await _fetchProducts(page, itemsPerPage);

          yield products.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ProductsLoaded(
                  products: currentState.products + products,
                  hasReachedMax: false,
                );
        }
      } catch (error) {
        print(error.toString());
        yield ProductsError();
      }
    }
  }

  bool _hasReachedMax(ProductsState state) =>
      state is ProductsLoaded && state.hasReachedMax;

  Future<List<Product>> _fetchProducts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://backendapi.turing.com/products?page=$startIndex&limit=$limit');

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['rows'] as List;

      return data
          .map(
            (rawProduct) => Product(
              id: rawProduct['product_id'].toString(),
              name: rawProduct['name'],
              thumbnail: rawProduct['thumbnail'],
              description: rawProduct['description'],
              price: double.parse(rawProduct['price']),
              discountedPrice: double.parse(rawProduct['discounted_price']),
            ),
          )
          .toList();
    } else {
      throw Exception('Error fetching products');
    }
  }
}
