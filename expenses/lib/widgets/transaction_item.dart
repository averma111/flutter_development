import 'dart:math';

import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.blue,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: this._bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\$${this.widget.transaction.amount}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        title: Text(
          this.widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(this.widget.transaction.timestamp),
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? FlatButton.icon(
                textColor: Theme.of(context).errorColor,
                onPressed: () =>
                    this.widget.deleteTransaction(this.widget.transaction.id),
                icon: Icon(Icons.delete),
                label: const Text('Delete'),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () =>
                    this.widget.deleteTransaction(this.widget.transaction.id),
              ),
      ),
    );
  }
}
