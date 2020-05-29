part of 'categories_bloc.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final Category selectedCategories;

  CategoriesLoaded({
    this.categories = const [],
    this.selectedCategories,
  });

  @override
  List<Object> get props => [categories, selectedCategories];

  @override
  String toString() =>
      "Categories Loaded { length:${categories.length}} Selected $selectedCategories";
}

class CategoriesError extends CategoriesState {}
