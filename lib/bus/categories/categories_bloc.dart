import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_test_fl/models/models.dart';

import 'package:http/http.dart' as http;

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final http.Client httpClient;
  final Category allCategories = Category(id: -1, name: "All");

  CategoriesBloc({this.httpClient});

  @override
  CategoriesState get initialState => CategoriesInitial();

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is CategoriesFetch) {
      yield* _mapCategoriesFetchToState(event);
    } else if (event is CategorySelected) {
      yield* _mapCategorySelectedToState(event);
    }
  }

  Stream<CategoriesState> _mapCategorySelectedToState(
      CategorySelected event) async* {
    if (state is CategoriesLoaded) {
      print("_mapCategorySelectedToState");
      print(event.selectedCategory);
      yield CategoriesLoaded(
        categories: (state as CategoriesLoaded).categories,
        selectedCategories: event.selectedCategory,
      );
    }
  }

  Stream<CategoriesState> _mapCategoriesFetchToState(
      CategoriesFetch event) async* {
    print("Fetch CategoriesFetch");

    try {
      final categories = await _fetchCategories();
      print(categories);
      yield CategoriesLoaded(
        categories: categories,
        selectedCategories: allCategories,
      );
    } catch (error) {
      print(error);
      yield CategoriesError();
    }
  }

  Future<List<Category>> _fetchCategories() async {
    final response =
        await httpClient.get('https://backendapi.turing.com/categories');

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['rows'] as List;

      List<Category> categories = data
          .map(
            (rawProduct) => Category(
              id: rawProduct['category_id'],
              name: rawProduct['name'],
              description: rawProduct['description'],
              departmentId: rawProduct['department_id'],
            ),
          )
          .toList();

      categories.insert(0, allCategories);

      return categories;
    } else {
      throw Exception('Error fetching products');
    }
  }
}
