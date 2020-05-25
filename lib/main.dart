import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_test_fl/bus/products/products_bloc.dart';
import 'package:shop_test_fl/screens/ProductsScreen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final http.Client httpClient = http.Client();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProductsBloc>.value(
            value: ProductsBloc(httpClient: httpClient),
          ),
        ],
        child: ProductsScreen(),
      ),
    );
  }
}
