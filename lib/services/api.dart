import 'dart:convert';

import 'package:app/models/entry_type.dart';
import 'package:app/models/priority.dart';
import 'package:app/services/base_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class API {
  static Future getWallets() async {
    var url = Uri.parse("$api/Wallet");
    var res =
        await http.get(url, headers: headers(await storage.read(key: "jwt")));
    return res;
  }

  static Future getEntries(String walletId) async {
    var url = Uri.parse("$api/Entry/Wallet/$walletId");
    var res =
        await http.get(url, headers: headers(await storage.read(key: "jwt")));
    return res;
  }

  static Future<http.Response> addWallet(String name) async {
    var url = Uri.parse("$api/Wallet");
    var body = json.encode({"name": name});
    var res = await http.post(url,
        body: body, headers: headers(await storage.read(key: "jwt")));
    return res;
  }

  static Future<http.Response> addEntry(
      double amount,
      String description,
      DateTime date,
      String categoryId,
      String walletId,
      entryTypeEnum entryType,
      PriorityEnum priority) async {
    var url = Uri.parse("$api/Entry");
    var body = json.encode({
      "amount": amount,
      "description": description,
      "date": DateFormat("yyyy-MM-ddTHH:mm:ss").format(date),
      "categoryId": categoryId,
      "walletId": walletId,
      "entryType": entryType.toShortString(),
      "priority": priority.toShortString(),
    });
    var res = await http.post(url,
        body: body, headers: headers(await storage.read(key: "jwt")));
    return res;
  }

  static Future<http.Response> deleteEntry(String id) async {
    var url = Uri.parse("$api/Entry/$id");
    var res = await http.delete(url,
        headers: headers(await storage.read(key: "jwt")));
    return res;
  }

  static Future<http.Response> deleteWallet(String id) async {
    var url = Uri.parse("$api/Wallet/$id");
    var res = await http.delete(url,
        headers: headers(await storage.read(key: "jwt")));
    return res;
  }

  static Future<http.Response> getCategories() async {
    var url = Uri.parse("$api/Category");
    var res = await http.get(url);
    return res;
  }
}
