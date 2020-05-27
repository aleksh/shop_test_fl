part of 'categories_bloc.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  CategoriesLoaded({this.categories});

  @override
  List<Object> get props => [categories];

  @override
  String toString() => "Categories Loaded { length:${categories.length}}";
}

class CategoriesError extends CategoriesState {}
