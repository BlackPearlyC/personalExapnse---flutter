import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:module_2_app/Models/transaction.dart';
import 'package:module_2_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.recentTransaction});

  final List<Transaction> recentTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransaction.map((e) {
            return Expanded(
              child: ChartBar(
                  label: e['day'].toString(),
                  spendingAmount: (e['amount'] as int),
                  spendingPcOfTotal: totalSpending == 0
                      ? 0
                      : (e['amount'] as int) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<Map<String, Object>> get groupTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      // total expanse of the day
      int totalSum = 0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.month == weekDay.month) {
          totalSum = totalSum + recentTransaction[i].amount;
        }
      }
      // debugPrint(totalSum.toString());

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  int get totalSpending {
    return groupTransaction.fold(0, (previousValue, element) {
      return previousValue + (element['amount'] as int);
    });
  }
}
