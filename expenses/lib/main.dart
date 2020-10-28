import 'dart:io';

import 'package:expenses/widgets/chart.dart';
import 'package:expenses/widgets/new_transaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage() {
    initializeDateFormatting('en_US', null);
    Intl.defaultLocale= 'en_US';
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', amount: 69.99, timestamp: DateTime.now(), title: "New Shoes"),
    // Transaction(
    //     id: 't2', amount: 18.55, timestamp: DateTime.now(), title: "Groceries"),
    // Transaction(
    //     id: 't3', amount: 21.11, timestamp: DateTime.now(), title: "Battery"),
  ];

  bool _showChart = false;

  //View App State =====================
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  // ===================================

  List<Transaction> get _recentTransaction {
    return this._userTransactions.where((t) {
      return t.timestamp.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime pickedDate) {
    setState(() {
      this._userTransactions.add(Transaction(
            title: title,
            timestamp: pickedDate,
            amount: amount,
            id: DateTime.now().toString(),
          ));
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bContext) {
          return NewTransaction(this._addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      this._userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('My Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => this._startAddNewTransaction(context),
        )
      ],
    );
  }

  Widget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text('My Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => this._startAddNewTransaction(context),
          )
        ],
      ),
    );
  }

  Widget _buildLandscapeContent(MediaQueryData mediaQuery, AppBar appBar,
      Container transactionListWidget) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Show Chart', style: Theme.of(context).textTheme.subtitle2),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: this._showChart,
              onChanged: (val) {
                setState(() {
                  this._showChart = val;
                });
              },
            ),
          ],
        ),
        this._showChart
            ? Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: Chart(this._recentTransaction))
            : transactionListWidget,
      ],
    );
  }

  Widget _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar,
      Container transactionListWidget) {
    return Column(
      children: <Widget>[
        Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.3,
            child: Chart(this._recentTransaction)),
        transactionListWidget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? this._buildCupertinoNavigationBar()
        : this._buildAppBar();

    final transactionListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child:
            TransactionList(this._userTransactions, this._deleteTransaction));

    var children2 = <Widget>[
      // ignore: sdk_version_ui_as_code
      if (isLandscape)
        this._buildLandscapeContent(mediaQuery, appBar, transactionListWidget),
      // ignore: sdk_version_ui_as_code
      if (!isLandscape)
        this._buildPortraitContent(mediaQuery, appBar, transactionListWidget),
    ];
    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children2,
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => this._startAddNewTransaction(context),
            ),
          );
  }
}
