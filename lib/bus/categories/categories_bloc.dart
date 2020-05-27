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

  CategoriesBloc({this.httpClient});

  @override
  CategoriesState get initialState => CategoriesInitial();

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is CategoriesFetch) {
      print("Fetch CategoriesFetch");

      try {
        final categories = await _fetchCategories();
        print(categories);
        yield CategoriesLoaded(categories: categories);

      } catch (error) {
        print(error);
        yield CategoriesError();
      }

    }
  }



  Future<List<Category>> _fetchCategories() async {
     final response = await httpClient.get('https://backendapi.turing.com/categories');

      if (response.statusCode == 200) {
      final List data = json.decode(response.body)['rows'] as List;

      return data
          .map(
            (rawProduct) => Category(
              id: rawProduct['category_id'],
              name: rawProduct['name'],
              description: rawProduct['description'],
              departmentId: rawProduct['department_id'],
            ),
          )
          .toList();
    } else {
      throw Exception('Error fetching products');
    }
  }


}

