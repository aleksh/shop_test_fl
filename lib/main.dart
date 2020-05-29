import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_test_fl/bus/categories/categories_bloc.dart';
import 'package:shop_test_fl/bus/products/products_bloc.dart';
import 'package:shop_test_fl/screens/ProductScreen.dart';
import 'package:shop_test_fl/screens/ProductsScreen.dart';
import 'package:http/http.dart' as http;

void main() {
  final http.Client httpClient = http.Client();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CategoriesBloc>.value(
          value: CategoriesBloc(httpClient: httpClient),
        ),
        BlocProvider<ProductsBloc>.value(
          value: ProductsBloc(httpClient: httpClient),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          ProductScreen.routeName: (ctx) =>
              ProductScreen(product: settings.arguments),
          ProductsScreen.routeName: (ctx) => ProductsScreen(),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
      initialRoute: ProductsScreen.routeName,
    );
  }
}
