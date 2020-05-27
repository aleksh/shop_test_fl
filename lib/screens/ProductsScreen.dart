import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_test_fl/bus/categories/categories_bloc.dart';
import 'package:shop_test_fl/bus/products/products_bloc.dart';
import 'package:shop_test_fl/widgets/ProductTile.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool _isNewPortionLoading = false;

  ProductsBloc _productsBloc;
  // CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _productsBloc = BlocProvider.of<ProductsBloc>(context);
    //   _categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    print("Init Products Screen");

    _productsBloc.add(ProductsFetch());
    //_categoriesBloc.add(CategoriesFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),

      /* body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesError) {
            return Center(
              child: Text("Error Categories Loaded"),
            );
          }

          if (state is CategoriesLoaded) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Categories'),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = state.categories[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue,
                        ),
                        child: Text(category.name),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),*/
/////////////////
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsError) {
            return Center(
              child: Text("Error Products Loaded"),
            );
          }

          if (state is ProductsLoaded) {
            _isNewPortionLoading = false;
            if (state.products.isEmpty) {
              return Center(
                child: Text('failed to fetch posts'),
              );
            }

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.products.length
                      ? state.products.length %2 == 0 ? BottomLoader() : null
                      : ProductTile(product: state.products[index]);
                },
                itemCount: state.hasReachedMax
                    ? state.products.length
                    : state.products.length + 1,
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      //////////////////////////////
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!_isNewPortionLoading) {
        print("_isNewPortionLoading $_isNewPortionLoading");
        _productsBloc.add(ProductsFetch());
        _isNewPortionLoading = true;
      }
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
