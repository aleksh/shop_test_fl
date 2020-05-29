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
  int prevCategoryId = -1;

  ProductsBloc({@required this.httpClient});

  @override
  ProductsState get initialState => ProductsInitial();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    final currentState = state;
    if (event is ProductsFetch) {
      if (prevCategoryId != event.categoryId) {
        prevCategoryId = event.categoryId;
        yield ProductsInitial();

        try {
          final products =
              await _fetchProducts(1, itemsPerPage, event.categoryId);
          yield ProductsLoaded(products: products, hasReachedMax: false);
          return;
        } catch (error) {
          yield ProductsError();
        }
      } else {
        if (!_hasReachedMax(currentState)) {
          try {
            if (currentState is ProductsInitial) {
              print('ProductsInitial');
              final products =
                  await _fetchProducts(1, itemsPerPage, event.categoryId);
              yield ProductsLoaded(products: products, hasReachedMax: false);
              return;
            }

            if (currentState is ProductsLoaded) {
              final page =
                  ((currentState.products.length / itemsPerPage) + 1).ceil();

              final products =
                  await _fetchProducts(page, itemsPerPage, event.categoryId);

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
    }
  }

  bool _hasReachedMax(ProductsState state) =>
      state is ProductsLoaded && state.hasReachedMax;

  Future<List<Product>> _fetchProducts(
      int startIndex, int limit, int categoryId) async {
    String reqUrl = categoryId != -1
        ? 'https://backendapi.turing.com/products/inCategory/$categoryId?page=$startIndex&limit=$limit'
        : 'https://backendapi.turing.com/products?page=$startIndex&limit=$limit';

    final response = await httpClient.get(reqUrl);

    if (response.statusCode == 200 || response.statusCode == 201) {
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