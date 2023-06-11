import "package:flutter/material.dart";

import "../dummy_data.dart";

class MealDetailScreen extends StatelessWidget {
  final Function _toggleFavorite;
  final Function _isMealFavorite;
  MealDetailScreen(this._toggleFavorite, this._isMealFavorite);
  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      child: child,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 150,
      width: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => mealId == meal.id);
    return Scaffold(
      appBar: AppBar(title: Text(selectedMeal.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8.0),
              child: Image.network(selectedMeal.imageUrl, fit: BoxFit.cover),
            ),
            buildSectionTitle(context, "Ingredients"),
            buildContainer(
              ListView.builder(
                  itemCount: selectedMeal.ingredients.length,
                  itemBuilder: (ctx, index) => Card(
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(selectedMeal.ingredients[index]),
                      ))),
            ),
            buildSectionTitle(context, "Steps"),
            buildContainer(ListView.builder(
              itemCount: selectedMeal.steps.length,
              itemBuilder: (ctx, index) => Column(
                children: [
                  ListTile(
                      leading: CircleAvatar(child: Text("# ${index + 1}")),
                      title: Text(selectedMeal.steps[index])),
                  Divider(color: Colors.black54)
                ],
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _toggleFavorite(mealId);
          },
          child: _isMealFavorite(mealId) ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
    );
  }
}
