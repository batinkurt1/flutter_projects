import "dart:io";

import "package:flutter/material.dart";
//import "package:flutter/services.dart";

import "widgets/add_transaction.dart";
import "models/transactionclass.dart";
import "widgets/transaction_list.dart";
import "widgets/chart.dart";

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "expenses",
      //the name you see when the app is on the background mode.
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          //copy with overwriting these new values I gave you.
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                    fontSize: 18),
                button: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: "Quicksand"),
    );
    //primarySwatch takes the color you define and the shades of that color. Flutter needs these shades to design your app and if you only provide a primaryColor, Flutter will pick the default value of shades ;thus, your app will look worse.
    //styling your widgets manually will overwrite the theme on that widget.
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    //Transaction(
    //id: "t1", title: "New Shoes", amount: 69.99, date: DateTime.now()),
    //Transaction(
    //id: "t2",
    //title: "Weekly Groceries",
    //amount: 16.53,
    //date: DateTime.now())
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txtitle, double txamount, DateTime txdate) {
    final newTx = Transaction(
        title: txtitle,
        amount: txamount,
        date: txdate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String txid) {
    setState(() {
      // removes all elements who satisfies the test.(elements which return true.)
      _userTransactions.removeWhere((tx) => tx.id == txid);
    });
  }

  void _startNewAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              //due to the gesture detector and onTap and behavior arguments, the modalbottomsheet doesn't close when we tap on it.
              child: NewTransaction(_addNewTransaction));
        });
  }

  bool _showChart = false;

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txlistwidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Show Chart", style: Theme.of(context).textTheme.headline6),
          Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.65,
              child: Chart(_recentTransactions))
          : txlistwidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txlistwidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txlistwidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    //isLandscape and mediaquery is reassigned everytime the build method executes, so if you change the orientation the build method will be executed again;thus, isLandscape and mediaquery will be recalculated.
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        "expenses",
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startNewAddTransaction(context))
      ],
    );
    final txlistwidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //if statements inside lists(inline condition rendering).curly brackets are not being used here. if(bool) widget. or if(bool) <Widget>[list of widgets].(Not sure about the last one.)
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txlistwidget),
            if (!isLandscape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txlistwidget,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _startNewAddTransaction(context),
          child: Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
