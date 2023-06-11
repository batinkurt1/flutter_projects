import "package:flutter/material.dart";

import "../models/meal.dart";
import "../widgets/meal_item.dart";

class FavoritesScreen extends StatelessWidget {
  final List<Meal> _favoritedMeals;
  FavoritesScreen(this._favoritedMeals);

  @override
  Widget build(BuildContext context) {
    if (_favoritedMeals.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "No favorited meals found. Try adding some!",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),
          ),
        ),
      );
    } else {
      return ListView.builder(
          itemBuilder: (ctx, index) {
            return MealItem(
              id: _favoritedMeals[index].id,
              title: _favoritedMeals[index].title,
              complexity: _favoritedMeals[index].complexity,
              imageUrl: _favoritedMeals[index].imageUrl,
              affordability: _favoritedMeals[index].affordability,
              duration: _favoritedMeals[index].duration,
            );
          },
          itemCount: _favoritedMeals.length,
        );
    }
  }
}
