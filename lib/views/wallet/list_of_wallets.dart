import 'dart:convert';

import 'package:app/models/category.dart';
import 'package:app/models/entry.dart';
import 'package:app/models/entry_type.dart';
import 'package:app/models/priority.dart';
import 'package:app/models/wallet.dart';
import 'package:app/views/entry/add_new_entry.dart';
import 'package:app/views/wallet/add_new_wallet.dart';
import 'package:app/services/api.dart';
import 'package:app/views/entry/list_of_entries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListOfWallets extends StatefulWidget {
  const ListOfWallets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListOfWalletsState();
  }
}

class _ListOfWalletsState extends State {
  List<Wallet> wallets = <Wallet>[];
  List<Category> categories = <Category>[];

  _getWallets() {
    API.getWallets().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        wallets = list.map<Wallet>((model) => Wallet.fromJson(model)).toList();
      });
    });
  }

  _getCategories() {
    API.getCategories().then((res) {
      //
      Iterable list = json.decode(res.body);
      setState(() {
        categories =
            list.map<Category>((model) => Category.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getWallets();
    _getCategories();
  }

  _getSummarizedPriorityBalance(PriorityEnum priority) {
    var sum = 0.0;
    for (var wallet in wallets) {
      for (Entry entry in wallet.entries ?? []) {
        if (entry.priority == priority) {
          if (entry.entryType == entryTypeEnum.income) {
            sum += entry.amount;
          } else {
            sum -= entry.amount;
          }
        }
      }
    }
    return sum;
  }

  _getSummarizedCategoryBalance(Category category) {
    var sum = 0.0;
    for (var wallet in wallets) {
      for (Entry entry in wallet.entries ?? []) {
        if (entry.categoryId == category.id) {
          if (entry.entryType == entryTypeEnum.income) {
            sum += entry.amount;
          } else {
            sum -= entry.amount;
          }
        }
      }
    }
    return sum;
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Column(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text("Wallets", style: TextStyle(fontSize: 24))),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: wallets.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(wallets[index].name),
                enableFeedback: true,
                subtitle: Text(
                    "Balance: ${wallets[index].totalBalance().toStringAsFixed(2)} PLN"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListOfEntriesPage(
                              walletId: wallets[index].id))).then((value) {
                    setState(() {
                      _getWallets();
                    });
                  });
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete"),
                          content: const Text("Delete this wallet?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  await API.deleteWallet(wallets[index].id);
                                  _getWallets();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Delete"))
                          ],
                        );
                      });
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Total spending by priority",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              ListTile(
                title: const Text("Low priority"),
                subtitle: Text(
                    "Balance: ${_getSummarizedPriorityBalance(PriorityEnum.low).toStringAsFixed(2)} PLN"),
              ),
              ListTile(
                title: const Text("Medium priority"),
                subtitle: Text(
                    "Balance: ${_getSummarizedPriorityBalance(PriorityEnum.medium).toStringAsFixed(2)} PLN"),
              ),
              ListTile(
                title: const Text("High priority"),
                subtitle: Text(
                    "Balance: ${_getSummarizedPriorityBalance(PriorityEnum.high).toStringAsFixed(2)} PLN"),
              ),
            ],
          )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Total spending by category",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(categories[index].name),
                enableFeedback: true,
                subtitle: Text(
                    "Balance: ${_getSummarizedCategoryBalance(categories[index]).toStringAsFixed(2)} PLN"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: PopupMenuButton<int>(
          onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNewWalletPage())).then((value) {
                setState(() {
                  _getWallets();
                });
              });
            } else {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewEntryPage()))
                  .then((value) {
                setState(() {
                  _getWallets();
                });
              });
            }
          },
          itemBuilder: (context) => [
                const PopupMenuItem(child: Text("Add wallet"), value: 0),
                const PopupMenuItem(child: Text("Add record"), value: 1)
              ],
          iconSize: 50,
          icon: Container(
              child: const Icon(Icons.add, color: Colors.white),
              decoration: const BoxDecoration(
                  color: Colors.blue, shape: BoxShape.circle))),
    );
  }
}
