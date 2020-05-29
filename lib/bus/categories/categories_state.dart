part of 'categories_bloc.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final Category selectedCategory;

  CategoriesLoaded({
    this.categories = const [],
    this.selectedCategory,
  });

  @override
  List<Object> get props => [categories, selectedCategory];

  @override
  String toString() =>
      "Categories Loaded { length:${categories.length}} Selected $selectedCategory";
}

class CategoriesError extends CategoriesState {}
