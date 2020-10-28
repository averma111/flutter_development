import 'package:expenses/models/transaction.dart';
import 'package:expenses/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return this.transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTransaction: deleteTransaction))
                .toList());
  }
}
