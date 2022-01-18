import 'dart:convert';

import 'package:app/models/category.dart';
import 'package:app/models/entry_type.dart';
import 'package:app/models/priority.dart';
import 'package:app/models/wallet.dart';
import 'package:app/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddNewEntryPage extends StatefulWidget {
  const AddNewEntryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddNewEntryState();
  }
}

class _AddNewEntryState extends State {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Category> categories = <Category>[];
  List<Wallet> wallets = <Wallet>[];

  Category? category;
  Wallet? wallet;
  entryTypeEnum? entryType = entryTypeEnum.expense;
  PriorityEnum? priority = PriorityEnum.medium;

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getWallets();
    _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(DateTime.now().year + 1));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  _addEntry() {
    API
        .addEntry(
            double.parse(_amountController.text),
            _descriptionController.text,
            selectedDate,
            category!.id,
            wallet!.id,
            entryType!,
            priority!)
        .then((res) {
      //
      if (res.statusCode == 201) {
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                title: Text("Error"), content: Text("An error occured")));
      }
    });
  }

  _getCategories() {
    API.getCategories().then((res) {
      //
      Iterable list = json.decode(res.body);
      setState(() {
        categories =
            list.map<Category>((model) => Category.fromJson(model)).toList();
        category = categories[0];
      });
    });
  }

  _getWallets() {
    API.getWallets().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        wallets = list.map<Wallet>((model) => Wallet.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add entry")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: "Amount")),
              TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description")),
              InkWell(
                  onTap: () async {
                    await _selectDate(context);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _dateController,
                        enabled: false,
                        decoration: const InputDecoration(labelText: "Date"),
                      ))),
              DropdownButtonFormField<Wallet>(
                hint: const Text("Select wallet"),
                decoration: const InputDecoration(labelText: "Wallet"),
                value: wallet,
                items: wallets.map((Wallet e) {
                  return DropdownMenuItem(value: e, child: Text(e.name));
                }).toList(),
                onChanged: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    wallet = _;
                  });
                },
              ),
              DropdownButtonFormField<Category>(
                decoration: const InputDecoration(labelText: "Category"),
                hint: const Text("Select a category"),
                value: category,
                items: categories.map((Category e) {
                  return DropdownMenuItem(value: e, child: Text(e.name));
                }).toList(),
                onChanged: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    category = _;
                  });
                },
              ),
              DropdownButtonFormField<entryTypeEnum>(
                hint: const Text("Type"),
                decoration: const InputDecoration(labelText: "Type"),
                value: entryType,
                items: entryTypeEnum.values.map((e) {
                  return DropdownMenuItem(
                      value: e, child: Text(e.toShortString()));
                }).toList(),
                onChanged: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    entryType = _;
                  });
                },
              ),
              DropdownButtonFormField<PriorityEnum>(
                hint: const Text("Priority"),
                decoration: const InputDecoration(labelText: "Priority"),
                value: priority,
                items: PriorityEnum.values.map((e) {
                  return DropdownMenuItem(
                      value: e, child: Text(e.toShortString()));
                }).toList(),
                onChanged: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    priority = _;
                  });
                },
              ),
              TextButton(onPressed: _addEntry, child: const Text("Add"))
            ]),
          ),
        ));
  }
}
