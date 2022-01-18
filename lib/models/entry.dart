import 'package:app/models/category.dart';
import 'package:app/models/entry_type.dart';
import 'package:app/models/priority.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Entry {
  String id;
  double amount;
  String description;
  DateTime date;
  String categoryId;
  Category category;
  String walletId;
  entryTypeEnum entryType;
  PriorityEnum priority;

  Entry(
      {required this.id,
      required this.amount,
      required this.description,
      required this.date,
      required this.categoryId,
      required this.category,
      required this.walletId,
      required this.entryType,
      required this.priority});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      categoryId: json['categoryId'],
      category: Category.fromJson(json['category']),
      walletId: json['walletId'],
      entryType: entryTypeFromString(json['entryType']),
      priority: priorityFromString(json['priority']),
    );
  }

  String toListDescription() {
    String base = "";
    if (entryType == entryTypeEnum.income) {
      base += "+ ";
    } else {
      base += "- ";
    }
    base += "${amount.toStringAsFixed(2)} PLN";
    return base;
  }

  Color getPriorityColor() {
    if (priority == PriorityEnum.high) {
      return Colors.red;
    }
    if (priority == PriorityEnum.medium) {
      return Colors.orange;
    }
    return Colors.green;
  }
}
