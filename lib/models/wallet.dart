import 'package:app/models/entry_type.dart';

import 'entry.dart';

class Wallet {
  String id;
  String name;
  String userId;
  List<Entry>? entries;

  Wallet(
      {required this.id,
      required this.name,
      required this.userId,
      required this.entries});

  factory Wallet.fromJson(Map<String, dynamic> _) {
    var entries =
        _['entries'].map<Entry>((model) => Entry.fromJson(model)).toList();
    return Wallet(
        id: _['id'] ?? '',
        name: _['name'] ?? '',
        userId: _['userId'],
        entries: entries);
  }

  double totalBalance() {
    double balance = 0;
    entries?.forEach((element) {
      if (element.entryType == entryTypeEnum.income) {
        balance += element.amount;
      } else {
        balance -= element.amount;
      }
    });
    return balance;
  }
}
