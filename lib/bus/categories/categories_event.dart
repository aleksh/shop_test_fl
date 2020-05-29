part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class CategoriesFetch extends CategoriesEvent {}

class CategorySelected extends CategoriesEvent {
  final Category selectedCategory;

  const CategorySelected({this.selectedCategory});

  @override
  List<Object> get props => [selectedCategory];

  @override
  String toString() => "CategorySelected ${selectedCategory.name}";
}
