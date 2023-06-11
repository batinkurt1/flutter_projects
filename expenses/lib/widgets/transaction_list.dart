import "package:flutter/material.dart";
import "../models/transactionclass.dart";
import "./transaction_item.dart";

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deletetx;
  TransactionList(this.transactions, this.deletetx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(
                  height: constraints.maxHeight * 0.2,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    "No Transactions added yet!",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                //SizedBox(height: constraints.maxHeight * 0.05),
                Container(
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset("assets/images/waiting.png",
                        fit: BoxFit.cover)),
              ],
            );
          })
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      deletetx: deletetx,
                      transaction: tx,
                    ))
                .toList(),
          );
    //.format() method returns a string representation of the date object.
    //everytime the state changes, Uniquekey changes as well, so flutter creates new states with different keys for the widgets and also keeps the old states.
    //ValueKey does not recalculate a different key everytime, it wraps the value we have entered with a non-changing identifier.
    //Listview.builder is buggy.
  }
}
