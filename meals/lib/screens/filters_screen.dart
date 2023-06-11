import "package:flutter/material.dart";

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  final Function _setFilters;
  final Map<String, bool> _currentfilters;
  FiltersScreen(this._setFilters, this._currentfilters);
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Widget _switchBuilder(
      bool value, String title, String description, Function updateValue) {
    return SwitchListTile(
        title: Text(title),
        subtitle: Text(description),
        value: value,
        onChanged: updateValue);
  }

  bool _glutenfree;
  bool _vegetarian;
  bool _lactosefree;
  bool _vegan;

  @override
  void initState() {
    _glutenfree = widget._currentfilters["gluten"];
    _vegetarian = widget._currentfilters["vegetarian"];
    _vegan = widget._currentfilters["vegan"];
    _lactosefree = widget._currentfilters["lactose"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Your Filters"),
        actions: [
          IconButton(
              onPressed: () {
                widget._setFilters({
                  "gluten": _glutenfree,
                  "lactose": _lactosefree,
                  "vegan": _vegan,
                  "vegetarian": _vegetarian
                });
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Column(
        children: [
          Container(
              child: Text("adjust your meal selection",
                  style: Theme.of(context).textTheme.headline6),
              padding: EdgeInsets.all(20)),
          Expanded(
              child: ListView(children: [
            _switchBuilder(_glutenfree, "Gluten-free", "Gluten-free",
                (newValue) {
              setState(() {
                _glutenfree = newValue;
              });
            }),
            _switchBuilder(_lactosefree, "Lactose-free", "Lactose-free",
                (newValue) {
              setState(() {
                _lactosefree = newValue;
              });
            }),
            _switchBuilder(_vegetarian, "Vegetarian", "Vegetarian", (newValue) {
              setState(() {
                _vegetarian = newValue;
              });
            }),
            _switchBuilder(_vegan, "Vegan", "Vegan", (newValue) {
              setState(() {
                _vegan = newValue;
              });
            })
          ]))
        ],
      ),
    );
  }
}
