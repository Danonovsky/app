import 'dart:convert';

import 'package:app/models/entry.dart';
import 'package:app/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListOfEntriesPage extends StatefulWidget {
  final String walletId;
  const ListOfEntriesPage({Key? key, required this.walletId}) : super(key: key);

  @override
  _ListOfEntriesState createState() {
    return _ListOfEntriesState();
  }
}

class _ListOfEntriesState extends State<ListOfEntriesPage> {
  List<Entry> entries = <Entry>[];

  _getEntries() {
    API.getEntries(widget.walletId).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        entries = list.map<Entry>((model) => Entry.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getEntries();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entries")),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) => ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entries[index].getPriorityColor(),
            ),
          ),
          onLongPress: () {
            //ble
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete"),
                    content: const Text("Delete this entry?"),
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
                            await API.deleteEntry(entries[index].id);
                            _getEntries();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Delete"))
                    ],
                  );
                });
          },
          trailing: Text(DateFormat('dd/MM/yyyy').format(entries[index].date)),
          title: Text(entries[index].category.name),
          enableFeedback: true,
          subtitle: Text(entries[index].toListDescription()),
        ),
      ),
    );
  }
}
