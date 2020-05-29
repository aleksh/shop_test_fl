import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_test_fl/bus/categories/categories_bloc.dart';
import 'package:shop_test_fl/models/category.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();

    _categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    print("Init Categories Widget");

    _categoriesBloc.add(CategoriesFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Categories"),
        Container(
          height: 36,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.brown,
          ),
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length ,
                  itemBuilder: (BuildContext context, int index) {
                    return CategoryItem(
                      key: ValueKey(state.categories[index].id),
                      category: state.categories[index],
                      selectCategory: _selectCategory,
                      selected: state.categories[index].id == state.selectedCategories.id,
                    );
                  },
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectCategory(Category category) {
    print(category);
    _categoriesBloc.add(CategorySelected(selectedCategory: category));
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool selected;
  final Function(Category category) selectCategory;

  const CategoryItem({
    Key key,
    @required this.category,
    @required this.selectCategory,
    @required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          selectCategory(category);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: selected ? Colors.blue : Colors.white,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(category.name),
          ),
        ),
      ),
    );
  }
}
