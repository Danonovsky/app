import 'package:app/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewWalletPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  AddNewWalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _addWallet() {
      API.addWallet(_nameController.text).then((res) {
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

    return Scaffold(
        appBar: AppBar(title: const Text("Add wallet")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name")),
              TextButton(onPressed: _addWallet, child: const Text("Add"))
            ]),
          ),
        ));
  }
}
