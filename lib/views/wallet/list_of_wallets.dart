import 'dart:convert';

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

  _getWallets() {
    API.getWallets().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        wallets = list.map<Wallet>((model) => Wallet.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getWallets();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallets")),
      body: ListView.builder(
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
                        builder: (context) =>
                            ListOfEntriesPage(walletId: wallets[index].id)))
                .then((value) {
              setState(() {
                _getWallets();
              });
            });
          },
          onLongPress: () {
            //
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete"),
                    content: const Text("Delete this wallet?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            //
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () async {
                            //
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
