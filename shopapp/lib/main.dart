import "package:flutter/material.dart";
import './screens/product_detail_screen.dart';
import "./screens/products_overview_screen.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "MyShop",
        theme: ThemeData(
            fontFamily: "Lato",
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange),
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => ProductsOverviewScreen(),
          "/product-detail": (context) => ProductDetailScreen()
        });
  }
}
