import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_2_app/Models/transaction.dart';
import 'package:module_2_app/widgets/chart.dart';
import 'package:module_2_app/widgets/new_transaction.dart';
import 'package:module_2_app/widgets/transaction_list.dart';

class UserTransaction extends StatefulWidget {
  const UserTransaction({super.key});

  @override
  State<UserTransaction> createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  // Switch Button
  bool _showGraph = false;

  final List<Transaction> _transaction = [
    // Transaction(
    //   amount: 1200,
    //   date: DateTime.now(),
    //   id: "0",
    //   title: "New Shoes",
    // ),
    // Transaction(
    //   amount: 1200,
    //   date: DateTime.now(),
    //   id: "1",
    //   title: "Books",
    // ),
    // Transaction(
    //   amount: 1200,
    //   date: DateTime.now(),
    //   id: "1",
    //   title: "Books",
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableSize = (mediaQuery.size.height -
        _appBar(context).preferredSize.height -
        mediaQuery.padding.top);
    // screen protrate
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("Personal Expense"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _startAddNewTranscation(context),
                    child: const Icon(CupertinoIcons.add),
                  )
                ],
              ),
            ),
            child: SafeArea(
                child:
                    _pageBody(isLandscape, mediaQuery, context, availableSize)),
          )
        : Scaffold(
            // app bar
            appBar: _appBar(context),

            // Main Body
            body: _pageBody(isLandscape, mediaQuery, context, availableSize),

            // Floating button
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    onPressed: () => _startAddNewTranscation(context),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
          );
  }

  SingleChildScrollView _pageBody(bool isLandscape, MediaQueryData mediaQuery,
      BuildContext context, double availableSize) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Switch show only if in landscape mode
          if (isLandscape)
            // ignore: sized_box_for_whitespace
            Container(
              height: (mediaQuery.size.height -
                      _appBar(context).preferredSize.height -
                      mediaQuery.padding.top) *
                  0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Text
                  const Text('Show chart'),
                  // switch
                  Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: _showGraph,
                      onChanged: (value) {
                        setState(() {
                          _showGraph = value;
                        });
                      })
                ],
              ),
            ),

          // show this if it has protrate mode
          if (!isLandscape)
            _graphContainer(context, isLandscape, availableSize),
          if (!isLandscape) _listContainer(context, isLandscape, availableSize),

          // Chart if in landscape mode show only if in landscape mode
          if (isLandscape)
            _showGraph
                // ignore: sized_box_for_whitespace
                ? _graphContainer(context, isLandscape, availableSize)
                :
                // Transaction list
                // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
                _listContainer(context, isLandscape, availableSize),
        ],
      ),
    );
  }

// List container
  Container _listContainer(
      BuildContext context, bool isLandscape, double availableSize) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: isLandscape ? availableSize * 0.85 : availableSize * 0.75,
      child: TransactionList(
        transaction: _transaction,
        deleteTransaction: _deleteTransaction,
      ),
    );
  }

// Graph container
  Container _graphContainer(
      BuildContext context, bool isLandscape, double availableSize) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: isLandscape ? availableSize * 0.7 : availableSize * 0.25,
      child: Chart(recentTransaction: _recentTransactions),
    );
  }

// app bar
  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Personal Expanse",
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTranscation(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

// Reecent transaction
  List<Transaction> get _recentTransactions {
    return _transaction.where((element) {
      return element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

// adding transaction to model
  _addNewTransaction(String title, int amount, DateTime date) {
    final newTx = Transaction(
        amount: amount,
        date: date,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title);

    setState(() {
      _transaction.add(newTx);
    });
  }

  // Delete transaction
  _deleteTransaction(String id) {
    setState(() {
      _transaction.removeWhere(
        (element) {
          return element.id == id;
        },
      );
    });
  }

// Model for add transaction
  _startAddNewTranscation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return NewTransaction(handleAddTx: _addNewTransaction);
      },
    );
  }
}
