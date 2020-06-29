import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_test_fl/bus/categories/categories_bloc.dart';
import 'package:shop_test_fl/bus/products/products_bloc.dart';
import 'package:shop_test_fl/widgets/Categories.dart';
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

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _productsBloc = BlocProvider.of<ProductsBloc>(context);
    print("Init Products Screen");

    _productsBloc.add(ProductsFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Column(
        children: <Widget>[
          Categories(),
          Expanded(
            child: BlocBuilder<ProductsBloc, ProductsState>(
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
                      child: Text('No Posts posts'),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.products.length
                          ? state.products.length % 2 != 0
                              ? BottomLoader()
                              : null
                          : ProductTile(
                              product: state.products[index],
                              key: ValueKey(state.products[index].id),
                            );
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
          ),

//_isNewPortionLoading

        ],
      ),
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
         setState(() {
          _isNewPortionLoading = true;
        });

        final catState = BlocProvider.of<CategoriesBloc>(context).state;

        int categoryId =
            (catState is CategoriesLoaded) ? catState.selectedCategory.id : -1;
        _productsBloc.add(ProductsFetch(categoryId: categoryId));
       
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
